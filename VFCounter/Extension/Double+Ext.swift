//
//  Double+Ext.swift
//  VFCounter
//
//  Created by Sunmi on 2020/09/30.
//  Copyright © 2020 creativeSun. All rights reserved.
//

import Foundation

extension Double {
    var clean: String {
        return self.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : String(format: "%.3f", self)
    }
}
