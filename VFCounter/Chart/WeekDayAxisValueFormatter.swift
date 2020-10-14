//
//  WeekDayAxisValueFormatter.swift
//  VFCounter
//
//  Created by Sunmi on 2020/08/13.
//  Copyright © 2020 creativeSun. All rights reserved.
//

import UIKit
import Charts

class WeekDayAxisValueFormatter: NSObject, IAxisValueFormatter {

    private var calendar: Calendar = .current
    private var weekdays = [String]()

    override init() {
        super.init()
        calendar.locale = Locale(identifier: "ko_KR")
        calendar.timeZone = TimeZone.current
        weekdays = calendar.shortWeekdaySymbols
        weekdays.append(weekdays.remove(at: 0))
    }

    func stringForValue(_ value: Double, axis: AxisBase?) -> String {

        let index = Int(value.rounded())
        guard weekdays.indices.contains(index), index == Int(value) else { return "" }
        return weekdays[ index % (weekdays.count)]
    }
}
