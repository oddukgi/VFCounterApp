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

    
    func getSumItems(date: String, completion: @escaping (Int16, Int16) -> Void) {
    
        let _ = try? UserDataManager.dataStack.perform(synchronous: { (transaction) in
            
            let veggieSum = try transaction.queryValue(From<Veggies>().select(Int16.self, .sum(\.amount)).where(format: "%K BEGINSWITH[c] %@",#keyPath(DataType.date),date))
            let fruitSum  = try transaction.queryValue(From<Fruits>().select(Int16.self, .sum(\.amount)).where(format: "%K BEGINSWITH[c] %@",#keyPath(DataType.date),date))
            completion(veggieSum!, fruitSum!)
            
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
            
            print(">>\(updateEntity.createdDate!)")
          })
          
       
    }

    func getData<T: DataType>(tag: Int, index: Int, _ objectType: T.Type, newDate: String,
                              completion: @escaping (Date) -> Void) {
        var configuration = ""
        tag == 0 ? (configuration = UserDataManager.veggieConfiguration): (configuration = UserDataManager.fruitsConfiguration)
        let orderBy = OrderBy<T>(.descending(\.createdDate))
    
        let _ = try? UserDataManager.dataStack.perform(synchronous: { (transaction) in
                
            let entity = try transaction.queryAttributes(
                From<T>(configuration),Select("createdDate"), Where<T>("%K BEGINSWITH[c] %@",#keyPath(DataType.date),newDate),orderBy
               
            )
            
            let date = entity[index]["createdDate"] as? Date
            completion(date!)

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
    
    func sortByTime<T: DataType>(_ objectType: T.Type, section:Int) -> [T]? {
        var configuration = ""
        section == 0 ? (configuration = UserDataManager.veggieConfiguration): (configuration = UserDataManager.fruitsConfiguration)
        let orderBy = OrderBy<T>(.descending(\.createdDate))
        guard let mostRecentData = try? UserDataManager.dataStack.fetchAll(From<T>(configuration),orderBy) else { return nil }
        return mostRecentData
    }
}
