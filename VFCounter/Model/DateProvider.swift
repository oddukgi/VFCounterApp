//
//  DateProvider.swift
//  VFCounter
//
//  Created by Sunmi on 2020/08/28.
//  Copyright © 2020 creativeSun. All rights reserved.
//

import Foundation



protocol UpdateDateDelegate: class {
    func sendChartDate(date: Date)
}

struct ValueConfig {
    var maxVeggies: Int = 0
    var maxFruits: Int  = 0
    var sumVeggies: Int  = 0
    var sumFruits: Int  = 0

    init() {}
}

class DateProvider {

    class func updateDateMap(date: Date, isWeekly: Bool = true) -> [String] {

        var dates = [Date]()
        let startOfMonth = date.startOfMonth(in: Calendar.current)
        isWeekly ? (dates = date.getWeekDates()) : (dates = startOfMonth.getMonthlyDates())
        let arrDates = dates.map { $0.changeDateTime(format: .longDate)}
        return arrDates
    }
}
