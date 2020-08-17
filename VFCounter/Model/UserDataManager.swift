//
//  UserDataManager.swift
//  VFCounter
//
//  Created by Sunmi on 2020/08/15.
//  Copyright © 2020 creativeSun. All rights reserved.
//

import Foundation
import CoreStore

struct UserDataManager {
    
    static let veggieConfiguration = "Veggies"
    static let fruitsConfiguration = "Fruits"
    
    static let userStack = DataStack(xcodeModelName: "VFCounterDB")
   
    static let dataStack: DataStack = {
        try! userStack.addStorageAndWait(
            SQLiteStore(
                fileName: "UserData_Veggie.sqlite",
                configuration: veggieConfiguration,
                localStorageOptions: .recreateStoreOnModelMismatch
            )
        )
        try! userStack.addStorageAndWait(
            SQLiteStore(
                fileName: "UserData_Fruits.sqlite",
                configuration: fruitsConfiguration,
                localStorageOptions: .recreateStoreOnModelMismatch
            )
        )
        
        return userStack
        
    }()
    
    static func getEntity<T: DataType>(_ objectType: T.Type, transaction: SynchronousDataTransaction,
        configuration: String) -> T {
        let entityItem = transaction.create(Into<T>(configuration))

        return entityItem
    }

    static func createEntity(item: VFItemController.Items, tag: Int) {
        
        var entityItem: DataType? =  nil
        
        _ = try? dataStack.perform(synchronous: { (transaction) in
            
            // create veggies entity
            if tag == 0 {
                entityItem = getEntity(Veggies.self, transaction: transaction, configuration: veggieConfiguration)
            } else {
                entityItem = getEntity(Fruits.self, transaction: transaction, configuration: fruitsConfiguration)
            }
            
            entityItem?.name = item.name
            entityItem?.time = item.time
            
            let datetimeConverter = DateConverter(date: item.date)
            entityItem?.date = datetimeConverter.getEntityDT()
            entityItem?.image = item.image?.pngData()
            entityItem?.amount = Int32(item.amount)
            
        })
     
     }

    static func updateVeggiesEntity(item: VFItemController.Items, tag: Int) {
        // check DataType existing or not
        var configuration = ""
        var entity: DataType? = nil
        
        tag == 0 ? ( configuration = veggieConfiguration ) : (configuration = fruitsConfiguration )
        
        if let existingEntity = try? dataStack.fetchOne(From<DataType>(configuration)
            .where(\.name == item.name && \.time == item.time)) {
            
            entity = existingEntity
        }
        
        do {
            let _ = try dataStack.perform(synchronous: { transaction -> Bool in
   
                entity = transaction.edit(entity)!
                entity?.name = item.name
                entity?.name = item.name
                entity?.time = item.time
                
                let datetimeConverter = DateConverter(date: item.date)
                entity?.date = datetimeConverter.getEntityDT()
                entity?.image = item.image?.pngData()
                entity?.amount = Int32(item.amount)
                return transaction.hasChanges
          })
        } catch {
            print(error.localizedDescription)
        }
    }
    
    
    static func deleteAllEntity()  {
       
        _ = try? dataStack.perform( synchronous: { (transaction) -> Bool in
            try transaction.deleteAll(From<DataType>())
            return transaction.hasChanges
        })
    }
    
    static func deleteItemFromEntity(item: VFItemController.Items, tag: Int) {
        
        var configuration = ""
        tag == 0 ? ( configuration = veggieConfiguration ) : (configuration = fruitsConfiguration )
        
        guard let existingEntity = try? dataStack.fetchOne(From<DataType>(configuration).where(\.name == item.name && \.time == item.time)) else { return }
        
        // transaction edit
        do {
             let _ = try dataStack.perform(synchronous: { (transaction) -> Bool in
                transaction.delete(existingEntity)
                return transaction.hasChanges
             })
            
        } catch {
            print(error.localizedDescription)
        }
    }
    
    
    static func getEntity<T: DataType>(_ objectType: T.Type, section: Int) -> T? {
        
        var configuration = ""
        section == 0 ? (configuration = veggieConfiguration): (configuration = fruitsConfiguration)
        guard let entity = try? dataStack.fetchOne(From<T>(configuration)) else {
            return nil
        }

        return entity
    }
  
    static func sortEntity<T: DataType>(_ objectType: T.Type, section: Int) -> [T]? {
        var configuration = ""
        section == 0 ? (configuration = veggieConfiguration): (configuration = fruitsConfiguration)
        guard let entity = try? dataStack.fetchAll(From<T>(configuration).orderBy(.descending(\.time))) else {
            return nil
        }
        return entity
    }
    
}


