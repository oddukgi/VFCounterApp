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

    class func setVeggieAmount(percent: Float) {
        userDefaults?.set(percent, forKey: "VeggieAmount")
    }

    class func setFruitsAmount(percent: Float) {
        userDefaults?.set(percent, forKey: "FruitAmount")
    }

    class func getAlarmValue(keyName: String) -> Bool? {
        return userDefaults?.bool(forKey: keyName)
    }

    class func getMaxValue(keyName: String) -> Float? {
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
    
    class func setKindSegment(kind: String) {
        userDefaults?.set(kind, forKey: "KindOfItem")
    }
    
    class func getKindSegment(keyName: String) -> String? {
        return userDefaults?.string(forKey: "KindOfItem")
    }
    
}
