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
          
          var entityItem: DataType? =  nil
          
        _ = try? UserDataManager.dataStack.perform(synchronous: { (transaction) in
          
              // create veggies entity
              if tag == 0 {
                entityItem = configureEntity(Veggies.self, transaction: transaction, configuration: UserDataManager.veggieConfiguration)
              } else {
                entityItem = configureEntity(Fruits.self, transaction: transaction, configuration: UserDataManager.fruitsConfiguration)
              }
              
              entityItem?.name = item.name
              entityItem?.time = item.time
              
              entityItem?.date = item.date.getEntityDT()
              entityItem?.image = item.image?.pngData()
              entityItem?.amount = Int16(item.amount)
              
          })
          
       
       }

    // MARK: edit entity
    func updateVeggiesEntity(item: VFItemController.Items, tag: Int) {
          // check DataType existing or not
          var configuration = ""
          var entity: DataType? = nil
          
        tag == 0 ? ( configuration = UserDataManager.veggieConfiguration ) : (configuration = UserDataManager.fruitsConfiguration )
          
        if let existingEntity = try? UserDataManager.dataStack.fetchOne(From<DataType>(configuration)
              .where(\.name == item.name && \.time == item.time)) {
              
              entity = existingEntity
          }
          
          do {
            let _ = try UserDataManager.dataStack.perform(synchronous: { transaction -> Bool in
     
                entity = transaction.edit(entity)!
                entity?.name = item.name
                entity?.time = item.time
                
                entity?.date = item.date.getEntityDT()
                entity?.image = item.image?.pngData()
                entity?.amount = Int16(item.amount)
                return transaction.hasChanges
            })
          } catch {
              print(error.localizedDescription)
          }
      }
      
      
    // MARK: delete all entities
    func deleteAllEntity() {
         
        _ = try? UserDataManager.dataStack.perform( synchronous: { (transaction) in
              try transaction.deleteAll(From<DataType>())
          })
          
      }
      
    // MARK: delete single entity
    func deleteItemFromEntity(name: String, time: String, tag: Int) {
          
          var configuration = ""
        tag == 0 ? ( configuration = UserDataManager.veggieConfiguration ) : (configuration = UserDataManager.fruitsConfiguration )
          
        guard let existingEntity = try? UserDataManager.dataStack.fetchOne(From<DataType>(configuration).where(\.name == name && \.time == time)) else { return }
          
          // transaction edit
          do {
            let _ = try UserDataManager.dataStack.perform(synchronous: { (transaction) -> Bool in
                  transaction.delete(existingEntity)
                  return transaction.hasChanges
               })
              
          } catch {
              print(error.localizedDescription)
          }
      }
      
      
    func getEntity<T: DataType>(_ objectType: T.Type, section: Int) -> T? {
          
          var configuration = ""
        section == 0 ? (configuration = UserDataManager.veggieConfiguration): (configuration = UserDataManager.fruitsConfiguration)
        guard let entity = try? UserDataManager.dataStack.fetchOne(From<T>(configuration)) else {
              return nil
          }

          return entity
      }
    
    func sortEntity<T: DataType>(_ objectType: T.Type, section: Int) -> [T]? {
          var configuration = ""
        section == 0 ? (configuration = UserDataManager.veggieConfiguration): (configuration = UserDataManager.fruitsConfiguration)
        guard let entity = try? UserDataManager.dataStack.fetchAll(From<T>(configuration).orderBy(.descending(\.time))) else {
              return nil
          }
          return entity
      }
      
    //Select<Int>(.maximum("age"))
    
//    let queryingItems: [Any] = [
//
//            try! UserDataManager.dataStack.queryValue(
//                From<Veggies>().select(Int16.self, .count(\.amount))
//            )!,
//
//
//
//    ]
    
    
    func getSumItems(date: String, completion: @escaping (Int16, Int16) -> Void) {
    
        let _ = try? UserDataManager.dataStack.perform(synchronous: { (transaction) in
            
            let veggieSum = try transaction.queryValue(From<Veggies>().select(Int16.self, .sum(\.amount)).where(\.date == date))
            let fruitSum  = try transaction.queryValue(From<Fruits>().select(Int16.self, .sum(\.amount)).where(\.date == date))
            
            completion(veggieSum!, fruitSum!)
        })

    }
    
}
