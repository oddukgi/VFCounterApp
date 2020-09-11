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
    
    private var configuration = ""
    func configureEntity<T: DataType>(_ objectType: T.Type, transaction: SynchronousDataTransaction,
          configuration: String) -> T {
          let entityItem = transaction.create(Into<T>(configuration))

          return entityItem
      }

    

    func createEntity(item: VFItemController.Items, tag: Int) {
          
          var entityItem: DataType? 
          
        _ = try? UserDataManager.dataStack.perform(synchronous: { (transaction) in
          
              // create veggies entity
              if tag == 0 {
                entityItem = configureEntity(Veggies.self, transaction: transaction, configuration: UserDataManager.veggieConfiguration)
              } else {
                entityItem = configureEntity(Fruits.self, transaction: transaction, configuration: UserDataManager.fruitsConfiguration)
              }
              
              entityItem?.name = item.name
              entityItem?.date = String(item.date.split(separator: " ").first!)
              entityItem?.createdDate = item.date.changeDateTime(format: .dateTime)
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
            
            OperationQueue.main.addOperation {
                completion(veggieSum!, fruitSum!)
            }
        })

    }
    
    func sortByTime<T: DataType>(_ objectType: T.Type, section:Int) -> [T]? {
        section == 0 ? (configuration = UserDataManager.veggieConfiguration): (configuration = UserDataManager.fruitsConfiguration)
        let orderBy = OrderBy<T>(.descending(\.createdDate))
        guard let mostRecentData = try? UserDataManager.dataStack.fetchAll(From<T>(configuration),orderBy) else { return nil }
        return mostRecentData
    }
}
