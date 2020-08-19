//
//  TotalDataManager.swift
//  VFCounter
//
//  Created by Sunmi on 2020/08/18.
//  Copyright © 2020 creativeSun. All rights reserved.
//

import Foundation
import CoreStore
import CoreData

struct TotalDataManager {
    
    
    static let shared = TotalDataManager()
    static let veggieTotalConfig = "VeggieTotal"
    static let fruitTotalConfig = "FruitTotal"
      
    static let userDB = DataStack(xcodeModelName: "VFCounterDB")

  
    
    static let dataStack: DataStack = {
        try! userDB.addStorageAndWait(
            SQLiteStore(
                fileName: "VeggieTotal.sqlite",
                configuration: veggieTotalConfig,
                localStorageOptions: .recreateStoreOnModelMismatch
            )
        )
        try! userDB.addStorageAndWait(
            SQLiteStore(
                fileName: "FruitTotal.sqlite",
                configuration: fruitTotalConfig,
                localStorageOptions: .recreateStoreOnModelMismatch
            )
        )
        
        return userDB
    }()
    

    
    static func createEntity(sum: Int16, date: Date,tag: Int) {
       
  
        var veggieEntity: VeggieTotal?
        
       _ = try? dataStack.perform(synchronous: { (transaction) in
           
           // create veggies entity
           if tag == 0 {
            
            
            if let existingEntity = try? dataStack.fetchOne(From<VeggieTotal>(veggieTotalConfig)) {
                veggieEntity = existingEntity
                veggieEntity?.sum = sum
                veggieEntity?.date = date
                
                
            }
            else {
                veggieEntity = transaction.create(Into<VeggieTotal>(veggieTotalConfig))
                veggieEntity?.sum = sum
                veggieEntity?.date = date
            }
            
           } else {
               let entityItem = transaction.create(Into<FruitTotal>(fruitTotalConfig))
                entityItem.sum = sum
                entityItem.date = date
        
            }

       })
    
    }
    
   private static func sumOfVeggies(date: Date) {
       
        let veggies = UserDataManager.sortEntity(Veggies.self, section: 0)
        var sumOfAmount:Int16 = 0
        
        veggies?.forEach { item in
            sumOfAmount += item.amount
        }
        
        createEntity(sum: sumOfAmount, date: date, tag: 0)
    }
    
    
   private static func sumOfFruit(date: Date) {
        let fruits = UserDataManager.sortEntity(Fruits.self, section: 1)
        var sumOfAmount:Int16 = 0
        
        fruits?.forEach { item in
            sumOfAmount += item.amount
        }
    
    
        createEntity(sum: sumOfAmount, date: date, tag: 1)
        
    }
    
    
    static func fetchTotalOfVeggies(date: Date) -> VeggieTotal? {
        
        sumOfVeggies(date: date)
        guard let entity = try? dataStack.fetchOne(From<VeggieTotal>(veggieTotalConfig)) else { return nil }
        
        return entity
    }
    
}
