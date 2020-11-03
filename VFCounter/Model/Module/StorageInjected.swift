//
//  StorageInjected.swift
//  VFCounter
//
//  Created by Sunmi on 2020/10/28.
//  Copyright © 2020 creativeSun. All rights reserved.
//

import Foundation

protocol StorageInjected {}

extension StorageInjected {
    var storage: Storage {
        return Storage()
    }
}
