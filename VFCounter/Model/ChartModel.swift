//
//  ChartModel.swift
//  VFCounter
//
//  Created by Sunmi on 2020/10/31.
//  Copyright © 2020 creativeSun. All rights reserved.
//

import UIKit
import CoreStore

// chart feature takes on here
class ChartModel {
    
    var valueConfig = ValueConfig()
    
    func getCurrentDate(periodIndex: Int, dataIndex: Int,
                        configure: ChartVC.DateConfigure) -> String {
        var strDate = ""
        switch periodIndex {
        case 0:
            let date = configure.date.changeDateTime(format: .date)
            return date
            
        default:
            if dataIndex == 0 {
                strDate = configure.calendarDate.changeDateTime(format: .date)
            } else {
                strDate = configure.date.changeDateTime(format: .date)
            }
            return strDate
        }

    }

    private func queryMax(date: String, type: String) -> Int {
        
        let max = try! Storage.dataStack.queryValue(From<Category>()
                                                        .select(Int.self, .attribute(\.$max))
                                                        .where(\.$date == date && \.$type == type)) ?? 0
        return max
    }
    
    func checkMaxValueFromDate(date: String) {
        let defaultV = Int(SettingManager.getMaxValue(keyName: "VeggieAmount") ?? 0)
        let defaultF = Int(SettingManager.getMaxValue(keyName: "FruitAmount") ?? 0)

        let type = ["야채", "과일"]
        var values: [Int] = []
        type.map { type in
            let value = CoreDataManager.queryMax(date: date, type: type)
            values.append(value)
        }
        
        let maxVeggie = (values[0] == 0) ? defaultV : values[0]
        let maxFruit = (values[1] == 0) ? defaultF : values[1]

        valueConfig.maxVeggies = maxVeggie
        valueConfig.maxFruits = maxFruit
    }

}
