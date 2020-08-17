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
       
    weak var chart: BarLineChartViewBase?

    init(chart: BarLineChartViewBase) {
        self.chart = chart
    }
    
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        
        let day = ["Sun", "Mon", "Tue", "Wed", "Thur", "Fri", "Sat"]
        let index = Int(value)
        return day[index]
    }


}
