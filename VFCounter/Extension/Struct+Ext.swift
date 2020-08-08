//
//  Struct+Ext.swift
//  VFCounter
//
//  Created by Sunmi on 2020/08/08.
//  Copyright © 2020 creativeSun. All rights reserved.
//

import Foundation



protocol StructExt {
    func allPropertiesAreNotNull() throws -> Bool
}

extension StructExt {
    func allPropertiesAreNotNull() throws -> Bool {

        let mirror = Mirror(reflecting: self)
        return !mirror.children.contains(where: { $0.value as Any? == nil})
    }
}
