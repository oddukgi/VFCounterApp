//
//  WeekDayAxisValueFormatter.swift
//  VFCounter
//
//  Created by Sunmi on 2020/08/13.
//  Copyright © 2020 creativeSun. All rights reserved.
//

import UIKit
import Charts

// we'll put label on weekdays from SUN to SAT
class WeekDayAxisValueFormatter: NSObject, IAxisValueFormatter {
       
    var weekdays = [String]()
    
    init(weekdays: [String]) {
        self.weekdays = weekdays
    }
    
    
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
       
        let index = Int(value.rounded())
        guard weekdays.indices.contains(index), index == Int(value) else { return "" }
        return weekdays[ index % (weekdays.count)]
    }
}
