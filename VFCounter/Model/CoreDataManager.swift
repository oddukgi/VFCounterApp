//
//  CoreDataManager.swift
//  VFCounter
//
//  Created by Sunmi on 2020/10/31.
//  Copyright © 2020 creativeSun. All rights reserved.
//

import CoreStore
import Foundation

class CoreDataManager {

    private var itemList: ListPublisher<Category>?
    var deleteDate: ((String?) -> Void)?

    init(itemList: ListPublisher<Category>?) {
        self.itemList = itemList
    }
    
    convenience init() {
        self.init(itemList: nil)
    }
    
    static func queryMax(date: String, type: String) -> Int {
        
        let max = try! Storage.dataStack.queryValue(From<Category>()
                                                        .select(Int.self, .attribute(\.$max))
                                                        .where(\.$date == date && \.$type == type)) ?? 0
        return max
    }
    
    func createEntity(item: Items, config: ValueConfig) {
            
        let date = item.entityDT?.changeDateTime(format: .dateTime).extractDate
        var flag = false
        Storage.dataStack.perform(asynchronous: { transaction in
            
            let category = transaction.create(Into<Category>())
            category.name = item.name
            category.date = date
            category.createdDate = item.entityDT
            category.image = item.image?.pngData()
            category.amount = item.amount
            
            (category.type == "야채") ? (category.max = config.maxVeggies) : (category.max = config.maxFruits)

        }, completion: { result in
            
            switch result {
            case .failure(let error):
                print(error.localizedDescription)
            case .success:
                print("Success")
              }
           }
        )
        
    }
        
    // MARK: calcurate sum
    func getSumEntity(date: String, type: String) -> Int? {
        
        guard let queryDict = try? Storage.dataStack.queryAttributes(
                From<Category>().select(NSDictionary.self, .sum(\.$amount, as: "total"))
                    .where(\.$date == date && \.$type == type)) else { return nil }
        
        let object = queryDict[0]
        
        return object["total"] as? Int
    }
    
    func modifyEntity(item: Items, oldDate: Date, editDate: Date? = nil) {
        
        let date = item.entityDT?.changeDateTime(format: .selectedDT)
        let newDate = date!.replacingOccurrences(of: "-", with: ".").components(separatedBy: " ")

        Storage.dataStack.perform(
            asynchronous: { (transaction) in
                guard let entity =  try? transaction.fetchOne(From<Category>()
                                                                .where(\.$createdDate  == oldDate)) else { return }

                let date = editDate ?? Date()
        
                let newEntity = transaction.edit(entity)!
                newEntity.name = item.name
                newEntity.date = newDate[0]
                newEntity.createdDate = item.entityDT!
                newEntity.image = item.image?.pngData()
                newEntity.amount = item.amount

            },
            completion: { result in
                
                switch result {
                case .failure(let error):
                    print(error)
                case .success:
                    print("Success Modify")
                    //refetch
                }
            }
        )
    }
        
    func deleteEntity(date: String, index: Int, type: String) {
    
        let createdDate = getCreatedDate(index: index, type: type, date: date)
        Storage.dataStack.perform(asynchronous: { (transaction) in
            guard let entity =  try? transaction.fetchOne(From<Category>().where(\.$createdDate == createdDate
                                                                                    &&  \.$type == type)) else { return }
            
            print(entity.createdDate?.changeDateTime(format: .dateTime))
            transaction.delete(entity)
           
        }, completion: { result in
            
            switch result {
            case .failure(let error):
                print(error)
            case .success:
                print("Success")
              }
            }
        )
    }
    
    func getEntityCount(date: String) -> Int {
        
        let count = try! Storage.dataStack.perform(
            synchronous: { (transaction) -> Int in

                let itemCount = try! transaction.fetchCount(From<Category>().where(\.$date == date))
                return itemCount
            }
        )
        return count
    }
    
    func getSubCategoryCount(date: String, type: String) -> Int {
        
        let count = try! Storage.dataStack.perform(
            synchronous: { (transaction) -> Int in

                let itemCount = try! transaction.fetchCount(From<Category>().where(\.$date == date
                                                                && \.$type == type ))
                return itemCount
            }
        )
        return count
    }

    func getCreatedDate(index: Int, type: String, date: String) -> Date {
        
        do {
            let queryDict = try Storage.dataStack.queryAttributes(
                From<Category>()
                    .select(NSDictionary.self, .attribute(\.$createdDate))
                    .where(\.$type == type && \.$date == date)
                    .orderBy(.descending(\.$createdDate))
            )
            let date = queryDict[index]["createdDate"] as! Date
            return date

        } catch {
            print(error.localizedDescription)
        }
        
        return Date()
    }
        
    func getAttributes(type: String, date: String) -> DictArray {
        guard let queryDict = try? Storage.dataStack
                .queryAttributes(From<Category>().select(NSDictionary.self, .attribute(\.$amount))
                                    .where(\.$date == date
                                            && \.$type == type)) else { return [[:]] }
        
        return queryDict
    }
        
    func reloadRingWithMax(valueConfig: ValueConfig, strDate: String) {
         
            let type = ["야채", "과일"]
            let maxVeggie = (valueConfig.maxVeggies)
            let maxFruit = (valueConfig.maxFruits)

        guard let veggieAmounts = getAttributes(type: type[0], date: strDate),
              let fruitAmounts = getAttributes(type: type[1], date: strDate) else { return }
            var sum: [Int] = [0, 0]

        for i in 0 ..< veggieAmounts.count {
            let value = veggieAmounts[i]["amount"] as! Int
            sum[0] += value
            if sum[0] > maxVeggie {
                self.deleteEntity(date: strDate, index: i, type: type[0])
            }
        }
        
        for i in 0 ..< fruitAmounts.count {
            let value = fruitAmounts[i]["amount"] as! Int
            sum[1] += value
            if sum[1] > maxFruit {
                self.deleteEntity(date: strDate, index: i, type: type[1])
            }
        }
        
     }

}
