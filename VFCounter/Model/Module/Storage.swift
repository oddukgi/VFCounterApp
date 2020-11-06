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
                    "Section": [0x383f8045374e8b08, 0xa29659a170998a92, 0xb2ef550dc6ee8dee, 0x8892492b7a9a65de]
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
