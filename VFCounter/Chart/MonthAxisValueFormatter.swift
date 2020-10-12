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
    var date: Date!

    init(chart: BarLineChartViewBase, date: Date) {
        self.chart = chart
        self.date = date
    }

    public func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        let days = Int(value)
        let endOfMonth = date.getLastDayMonth()
        var arrayDay = [Int]()
        var count = 1

        while count <= endOfMonth {
            arrayDay.append(count)
            count += 1
        }

        return String(format: "%d", arrayDay[days])
     }
}
