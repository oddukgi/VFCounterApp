//
//  DataManager.swift
//  VFCounter
//
//  Created by Sunmi on 2020/08/21.
//  Copyright © 2020 creativeSun. All rights reserved.
//

import Foundation
import CoreStore

class DataManager {
    
    // MARK: Fetched Data
    
    static func fetchVeggieData(date: String) -> [DataType] {
        
        return try! UserDataManager.dataStack
            .fetchAll(From<Veggies>(UserDataManager.veggieConfiguration)
            .where(format: "%K BEGINSWITH[c] %@", #keyPath(DataType.date), date).orderBy(.descending(\.createdDate)))
    }
    
    static func fetchFruitData(date: String) -> [DataType] {
        
        return try! UserDataManager.dataStack
            .fetchAll(From<Fruits>(UserDataManager.fruitsConfiguration)
            .where(format: "%K BEGINSWITH[c] %@", #keyPath(DataType.date), date).orderBy(.descending(\.createdDate)))
    }

    func getEntityCount(date: String, section: Int) -> Int {
        
        var itemCount = 0
        
        if section == 0 {
            itemCount = DataManager.fetchVeggieData(date: date).count
        } else {
            itemCount = DataManager.fetchFruitData(date: date).count
        }
        
        return itemCount
     
    }

    // MARK: Create Entity
    func configureEntity<T: DataType>(_ objectType: T.Type, transaction: SynchronousDataTransaction,
          configuration: String) -> T {
          let entityItem = transaction.create(Into<T>(configuration))

          return entityItem
      }

    func createEntity(item: VFItemController.Items, tag: Int, valueConfig: ValueConfig?) {

          var entityItem: DataType?

        let date = item.entityDT?.changeDateTime(format: .selectedDT)
        let newDate = date!.replacingOccurrences(of: "-", with: ".").components(separatedBy: " ")

        _ = try? UserDataManager.dataStack.perform(synchronous: { (transaction) in

                         // create veggies entity
              if tag == 0 {
                entityItem = configureEntity(Veggies.self, transaction: transaction, configuration: UserDataManager.veggieConfiguration)
              } else {
                entityItem = configureEntity(Fruits.self, transaction: transaction, configuration: UserDataManager.fruitsConfiguration)
              }
            
            guard let config = valueConfig else { return }
            entityItem?.name = item.name
            entityItem?.date = newDate[0]
            entityItem?.createdDate = item.entityDT
            entityItem?.image = item.image?.pngData()
            entityItem?.amount = Int16(item.amount)
            entityItem?.maxveggie = Int16(config.maxVeggies)
            entityItem?.maxfruit = Int16(config.maxFruits)

          })

       }

    // MARK: Get Sum values from Entity
    func getSumItems(date: String) -> (Int, Int) {
        var veggieFilter = Where<Veggies>() && Where("%K BEGINSWITH[c] %@", #keyPath(DataType.date), date)
        var fruitFilter = Where<Fruits>() && Where("%K BEGINSWITH[c] %@", #keyPath(DataType.date), date)

        let totalVeggies = try? UserDataManager.dataStack.queryValue(From<Veggies>(),
            Select<Veggies, Int16>(.sum("amount")), veggieFilter)

        let totalFruits = try? UserDataManager.dataStack.queryValue(From<Fruits>(),
            Select<Fruits, Int16>(.sum("amount")), fruitFilter)

        return (Int(totalVeggies ?? 0), Int(totalFruits ?? 0))
    }

    // MARK: Update Data from Entity
    func modfiyEntity<T: DataType>(item: VFItemController.Items, originTime: Date,
                                   _ objectType: T.Type) {

        var configuration = ""
        let date = item.entityDT?.changeDateTime(format: .selectedDT)
        let newDate = date!.replacingOccurrences(of: "-", with: ".").components(separatedBy: " ")

        objectType == Veggies.self ? (configuration = UserDataManager.veggieConfiguration): (configuration = UserDataManager.fruitsConfiguration)

        guard let existingEntity = try? UserDataManager.dataStack.fetchOne(From<T>(configuration)
            .where(\.createdDate == originTime)) else { return  }

        _ = try? UserDataManager.dataStack.perform(synchronous: { (transaction) in
            let updateEntity = transaction.edit(existingEntity)!
            updateEntity.name = item.name
            updateEntity.date = newDate[0]
            updateEntity.createdDate = item.entityDT!
            updateEntity.image = item.image?.pngData()
            updateEntity.amount = Int16(item.amount)

          })
    }

    // MARK: find createdDate
    func fetchedDate<T: DataType>(tag: Int, index: Int, _ objectType: T.Type, newDate: String,
                              completion: @escaping (Date) -> Void) {
        var configuration = ""
        tag == 0 ? (configuration = UserDataManager.veggieConfiguration): (configuration = UserDataManager.fruitsConfiguration)
        let orderBy = OrderBy<T>(.descending(\.createdDate))

        _ = try? UserDataManager.dataStack.perform(synchronous: { (transaction) in

            let entity = try? transaction.queryAttributes(
                From<T>(configuration), Select("createdDate"), Where<T>("%K BEGINSWITH[c] %@", #keyPath(DataType.date), newDate), orderBy)

            if let entity = entity {
                if let date = entity[index]["createdDate"] as? Date {
                    completion(date)
                }
            }
         })
    }

    // MARK: Get Entity
    func getEntity<T: DataType>(originTime: Date, _ objectType: T.Type) -> DataType {

        var configuration = ""
        objectType == Veggies.self ? (configuration = UserDataManager.veggieConfiguration): (configuration = UserDataManager.fruitsConfiguration)

        guard let existingEntity = try? UserDataManager.dataStack.fetchOne(From<T>(configuration)
                                    .where(\.createdDate == originTime)) else { return DataType() }
        
        return existingEntity
    }
    
    // MARK: Delete entity
    func deleteEntity<T: DataType>(originTime: Date, _ objectType: T.Type) {

        var configuration = ""
        objectType == Veggies.self ? (configuration = UserDataManager.veggieConfiguration): (configuration = UserDataManager.fruitsConfiguration)

        //"createdDate"), Where<T>("%K BEGINSWITH[c] %@",#keyPath(DataType.date),newDate),orderBy
        guard let existingEntity = try? UserDataManager.dataStack.fetchOne(From<T>(configuration)
            .where(\.createdDate == originTime)) else { return  }

        _ = try? UserDataManager.dataStack.perform(synchronous: { (transaction) in
            transaction.delete(existingEntity)

        })

    }

    func getDateDictionary(completion: @escaping DataDictionary) {
        _ = try? UserDataManager.dataStack.perform(synchronous: { (transaction) in

            let veggieData = try transaction.queryAttributes(From<Veggies>()
                                                                .select(NSDictionary.self,
                                                              .attribute(\.name),
                                                              .attribute(\.date))
                                                              .orderBy(.descending(\.date)))

            let fruitData = try transaction.queryAttributes(From<Fruits>()
                                                                .select(NSDictionary.self,
                                                              .attribute(\.name),
                                                              .attribute(\.date))
                                                              .orderBy(.descending(\.date)))
            completion(veggieData, fruitData)

        })
    }

    // MARK: Retrieve Date from entity
    func getSpecificDate(date: String, completion: @escaping DataDictionary) {
        _ = try? UserDataManager.dataStack.perform(synchronous: { (transaction) in
            let veggieData = try transaction.queryAttributes(From<Veggies>()
                                                                .select(NSDictionary.self,
                                                              .attribute(\.name),
                                                              .attribute(\.amount)).orderBy(.descending(\.createdDate))
                                                              .where(format: "%K BEGINSWITH[c] %@", #keyPath(DataType.date), date))

            let fruitData = try transaction.queryAttributes(From<Fruits>()
                                                                .select(NSDictionary.self,
                                                              .attribute(\.name),
                                                              .attribute(\.amount)).orderBy(.descending(\.createdDate))
                                                              .where(format: "%K BEGINSWITH[c] %@", #keyPath(DataType.date), date))

            completion(veggieData, fruitData)

        })

    }

    func getEntityCount<T: DataType>(date: String, section: Int,
                                            _ objectType: T.Type, completion: @escaping (Int?) -> Void) {
 
        var configuration = ""

        section == 0 ? (configuration = UserDataManager.veggieConfiguration): (configuration = UserDataManager.fruitsConfiguration)
        _ = try? UserDataManager.dataStack.perform(synchronous: { (transaction) in

            let count = try? transaction.fetchCount(
                From<T>(configuration), Where<T>("%K BEGINSWITH[c] %@", #keyPath(DataType.date), date))
           
            completion(count)
            
        })

    }

    func getMaxData(date: String) -> (Int, Int) {
        var veggieFilter = Where<Veggies>() && Where("%K BEGINSWITH[c] %@", #keyPath(DataType.date), date)
        var fruitFilter = Where<Fruits>() && Where("%K BEGINSWITH[c] %@", #keyPath(DataType.date), date)

        let maxVeggie = try? UserDataManager.dataStack
            .queryValue(From<Veggies>(), Select<Veggies, Int16>(.maximum("maxveggie")), veggieFilter)

        let maxFruit = try? UserDataManager.dataStack
            .queryValue(From<Fruits>(), Select<Fruits, Int16>(.maximum("maxfruit")), fruitFilter)

        return (Int(maxVeggie ?? 0), Int(maxFruit ?? 0))
    }
    
}
