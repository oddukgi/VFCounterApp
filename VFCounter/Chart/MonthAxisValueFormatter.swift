//
//  MonthAxisValueFormatter.swift
//  VFCounter
//
//  Created by Sunmi on 2020/08/13.
//  Copyright © 2020 creativeSun. All rights reserved.
//

import UIKit
import Charts

class MonthAxisValueFormatter: NSObject, IAxisValueFormatter {
    
    weak var chart: BarLineChartViewBase?

    init(chart: BarLineChartViewBase) {
        self.chart = chart
    }

    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        let now = Date()
    
        let endDate   = now.endOfWeek()
        let endComponents = endDate.get(.year,.month, .day)
        let month   = endComponents.month ?? 1
        let year    = endComponents.year ?? 1900
        var day = Int(value)
        day = determineDayOfMonth(to: year, forDays: day, month: month)
        
        return String(day)
        
    }
    
    private func days(forMonth month: Int, year: Int) -> Int {
         // month is 0-based
         switch month {
         case 1:
             var is29Feb = false
             if year < 1582 {
                 is29Feb = (year < 1 ? year + 1 : year) % 4 == 0
             } else if year > 1582 {
                 is29Feb = year % 4 == 0 && (year % 100 != 0 || year % 400 == 0)
             }
             
             return is29Feb ? 29 : 28
             
         case 3, 5, 8, 10:
             return 30
             
         default:
             return 31
         }
     }
     
    
    private func determineDayOfMonth(to year: Int, forDays days: Int, month: Int) -> Int {
        var count = 0
        var daysForMonth = 0
        
        while count < month {
            let year = year
            daysForMonth += self.days(forMonth: count % 12, year: year)
            count += 1
        }
        
        return days - daysForMonth
    }
    
}
