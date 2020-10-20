//
//  SettingManager.swift
//  VFCounter
//
//  Created by Sunmi on 2020/08/18.
//  Copyright © 2020 creativeSun. All rights reserved.
//

import Foundation

class SettingManager {

    fileprivate static let userDefaults = UserDefaults(suiteName: "group.com.creativeSun.vfcounter.settings")

    class func setVeggieAlarm(veggieFlag: Bool) {
        userDefaults?.set(veggieFlag, forKey: "VeggieAlarm")
    }

    class func setFruitsAlarm(fruitsFlag: Bool) {
        userDefaults?.set(fruitsFlag, forKey: "FruitAlarm")
    }

    class func setVeggieTaskRate(percent: Float) {
        userDefaults?.set(percent, forKey: "VeggieTaskRate")
    }

    class func setFruitsTaskRate(percent: Float) {
        userDefaults?.set(percent, forKey: "FruitTaskRate")
    }

    class func getAlarmValue(keyName: String) -> Bool? {
        return userDefaults?.bool(forKey: keyName)
    }

    class func getTaskValue(keyName: String) -> Float? {
        return userDefaults?.float(forKey: keyName)
    }

    class func setInitialLaunching(flag: Bool) {
        userDefaults?.set(flag, forKey: "InitialLaunching")
    }

    class func getInitialLaunching(keyName: String) -> Bool? {
        return userDefaults?.bool(forKey: keyName)
    }
    
    class func setPeriodSegment(index: Int) {
        userDefaults?.set(index, forKey: "PeriodSegment")
    }
    
    class func setDataSegment(index: Int) {
        userDefaults?.set(index, forKey: "DataSegment")
    }
    
    class func getPeriodSegment(keyName: String) -> Int? {
        return userDefaults?.integer(forKey: "PeriodSegment")
    }
    
    class func getDataSegment(keyName: String) -> Int? {
        return userDefaults?.integer(forKey: "DataSegment")
    }
    
}
