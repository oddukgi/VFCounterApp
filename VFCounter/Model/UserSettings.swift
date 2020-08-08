//
//  UserSettings.swift
//  VFCounter
//
//  Created by Sunmi on 2020/08/08.
//  Copyright © 2020 creativeSun. All rights reserved.
//

import Foundation

struct UserSettings: Codable, Hashable {
    var title      : String
    var alarmOn    : Bool
    var taskPercent: Float
    
    func hasNilField() -> Bool {
          return ([title, alarmOn, taskPercent] as [Any?]).contains(where: { $0 == nil})
      }
}
