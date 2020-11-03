//
//  Storage.swift
//  VFCounter
//
//  Created by Sunmi on 2020/10/27.
//  Copyright © 2020 creativeSun. All rights reserved.
//

import CoreStore
import Foundation

struct Storage {
    // MARK: - Create DataStack and storage
        
        static let dataStack: DataStack = {
    
         let dataStack = DataStack(
            CoreStoreSchema(
                modelVersion: "V1",
                entities: [
                    Entity<Category>("Section")
                ],
                versionLock: [
                    "Section": [0xd557a0d6006f501, 0x24d0fba6e17727c6, 0x2e798bfc3cabe171, 0x7cd38369cfcfd923]
                ]
            )
        )

    // create SQLLite file
        do {
    
            try dataStack.addStorageAndWait(
                SQLiteStore(
                    fileName: "MainList.Data.sqlite",
                    localStorageOptions: .recreateStoreOnModelMismatch
                )
            )
        } catch {
            fatalError(error.localizedDescription)
        }
            
        return dataStack
    
    }()

}
