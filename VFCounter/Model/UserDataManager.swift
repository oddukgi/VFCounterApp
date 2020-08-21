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
    static let monthConfiguration = "Month"
    
    static let userStack = DataStack(xcodeModelName: "VFCounterDB")
   
    // monthly 1 ~ 12
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
}


