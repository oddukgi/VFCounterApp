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
    
    // MARK: create entity
    
    private let dateItems  =  [{ (date) -> [DataType] in
            return try! UserDataManager.dataStack.fetchAll(From<DataType>(UserDataManager.veggieConfiguration)
            .where(format: "%K BEGINSWITH[c] %@",
            #keyPath(DataType.date),date).orderBy(.descending(\.createdDate)))
        },
    
       { (date) -> [DataType] in
            return try! UserDataManager.dataStack.fetchAll(From<DataType>(UserDataManager.fruitsConfiguration)
            .where(format: "%K BEGINSWITH[c] %@",
                   #keyPath(DataType.date),date).orderBy(.descending(\.createdDate)))
        }
    ]
    

    func configureEntity<T: DataType>(_ objectType: T.Type, transaction: SynchronousDataTransaction,
          configuration: String) -> T {
          let entityItem = transaction.create(Into<T>(configuration))

          return entityItem
      }

    func createEntity(item: VFItemController.Items, tag: Int) {
          
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
              
              entityItem?.name = item.name
              entityItem?.date = newDate[0]
              entityItem?.createdDate = item.entityDT
              entityItem?.image = item.image?.pngData()
              entityItem?.amount = Int16(item.amount)
           
          })

       }

    // MARK: delete all entities
    func deleteAllEntity() {
         
        _ = try? UserDataManager.dataStack.perform( synchronous: { (transaction) in
              try transaction.deleteAll(From<DataType>())
          })
          
      }
    
      
    func getEntity<T: DataType>(_ objectType: T.Type, section: Int) -> T? {
          
        var configuration = ""
        section == 0 ? (configuration = UserDataManager.veggieConfiguration): (configuration = UserDataManager.fruitsConfiguration)
        guard let entity = try? UserDataManager.dataStack.fetchOne(From<T>(configuration)) else {
              return nil
          }

          return entity
      }

    
    func getSumItems(date: String) -> (Int,Int) {
        var veggieFilter = Where<Veggies>() && Where("%K BEGINSWITH[c] %@", #keyPath(DataType.date),date)
        var fruitFilter = Where<Fruits>() && Where("%K BEGINSWITH[c] %@", #keyPath(DataType.date),date)
    
        let totalVeggies = try? UserDataManager.dataStack.queryValue(From<Veggies>(),
            Select<Veggies,Int16>(.sum("amount")), veggieFilter) ?? 0
        
        let totalFruits = try? UserDataManager.dataStack.queryValue(From<Fruits>(),
            Select<Fruits,Int16>(.sum("amount")), fruitFilter) ?? 0

        return (Int(totalVeggies ?? 0),Int(totalFruits ?? 0))
    }
    
    
    /*
     let _ = try? UserDataManager.dataStack.perform(synchronous: { (transaction) in
         
         let veggieSum = try transaction.queryValue(From<Veggies>().select(Int16.self, .sum(\.amount)).where(format: "%K BEGINSWITH[c] %@",#keyPath(DataType.date),date))
         let fruitSum  = try transaction.queryValue(From<Fruits>().select(Int16.self, .sum(\.amount)).where(format: "%K BEGINSWITH[c] %@",#keyPath(DataType.date),date))
         completion(Int(veggieSum!), Int(fruitSum!))
         
     })
     */
    
    func checkVeggieData(date: String, completion: @escaping ([[String : Any]]) -> Void) {
    
        let _ = try? UserDataManager.dataStack.perform(synchronous: { (transaction) in
            
            let veggieData = try transaction.queryAttributes(From<Veggies>().select(NSDictionary.self,
                                                                                      .attribute(\.name),
                                                                                      .attribute(\.date))
                                                            
            .where(format: "%K BEGINSWITH[c] %@", #keyPath(DataType.date), date))
             completion(veggieData)
        })

    }
        
    
    
    func checkFruitData(date: String, completion: @escaping (String?) -> Void) {
    
        let _ = try? UserDataManager.dataStack.perform(synchronous: { (transaction) in
            
            let fruitData = try transaction.queryValue(From<Veggies>()
            .select(String.self, .attribute(\.name))
            .where(format: "%K BEGINSWITH[c] %@", #keyPath(DataType.date), date))
            completion(fruitData)
    
        })
    }
    
    
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
       
              // create veggies entity
              updateEntity.name = item.name
              updateEntity.date = newDate[0]
              updateEntity.createdDate = item.entityDT!
              updateEntity.image = item.image?.pngData()
              updateEntity.amount = Int16(item.amount)
            
//            print(">>\(updateEntity.createdDate!)")
          })
    }
    
    

    func getData<T: DataType>(tag: Int, index: Int, _ objectType: T.Type, newDate: String,
                              completion: @escaping (Date) -> Void) {
        var configuration = ""
        tag == 0 ? (configuration = UserDataManager.veggieConfiguration): (configuration = UserDataManager.fruitsConfiguration)
        let orderBy = OrderBy<T>(.descending(\.createdDate))
    
        let _ = try? UserDataManager.dataStack.perform(synchronous: { (transaction) in
                
            let entity = try? transaction.queryAttributes(
                From<T>(configuration),Select("createdDate"), Where<T>("%K BEGINSWITH[c] %@",#keyPath(DataType.date),newDate),orderBy)
            
            
            if let entity = entity {
                if let date = entity[index]["createdDate"] as? Date {
                    completion(date)
                }
            }
         })
    }
    
    // @paramter: Int
       
    func deleteEntity<T: DataType>(originTime: Date,_ objectType: T.Type) {
        
        var configuration = ""
        objectType == Veggies.self ? (configuration = UserDataManager.veggieConfiguration): (configuration = UserDataManager.fruitsConfiguration)    
        
        //"createdDate"), Where<T>("%K BEGINSWITH[c] %@",#keyPath(DataType.date),newDate),orderBy
        guard let existingEntity = try? UserDataManager.dataStack.fetchOne(From<T>(configuration)
            .where(\.createdDate == originTime)) else { return  }

        _ = try? UserDataManager.dataStack.perform(synchronous: { (transaction) in
            transaction.delete(existingEntity)
            
        })
        
    }
    
    func getList(date: String, index: Int) -> [SubItems] {
        
        var subitem = [SubItems]()
        let data = dateItems[index](date)
        
        for value in data {
            let item = SubItems(element: value)
            subitem.append(item)
        }
    
        return subitem
    }

    /// 날짜 가져오기
    
    func getDateDictionary(completion: DataDictionary) {
        let _ = try? UserDataManager.dataStack.perform(synchronous: { (transaction) in
            
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
    
    
    /*
     let personJSON = try dataStack.queryAttributes(
         From<MyPersonEntity>(),
         Select("name", "age")
     )
     */
    
    func reorderData(date: String, completion: DataDictionary) {
        let _ = try? UserDataManager.dataStack.perform(synchronous: { (transaction) in
            let veggieData = try transaction.queryAttributes(From<Veggies>()
                                                                .select(NSDictionary.self,
                                                              .attribute(\.name),
                                                              .attribute(\.amount)).orderBy(.descending(\.date))
                                                              .where(format: "%K BEGINSWITH[c] %@", #keyPath(DataType.date), date))
            
            let fruitData = try transaction.queryAttributes(From<Fruits>()
                                                                .select(NSDictionary.self,
                                                              .attribute(\.name),
                                                              .attribute(\.amount)).orderBy(.descending(\.date))
                                                              .where(format: "%K BEGINSWITH[c] %@", #keyPath(DataType.date), date))
            
            completion(veggieData, fruitData)
            
        })
        
    }
    
    
        

}
