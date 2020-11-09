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

protocol DateProtocol {
    var newDate: String { get set }
}

enum SectionFilter: String {

    case main, chart
    var kind: String {
        return rawValue
    }
}

struct ValueConfig {
    var maxVeggies: Int = 0
    var maxFruits: Int  = 0
    var sumVeggies: Int  = 0
    var sumFruits: Int  = 0

    init() {}
}

class DateProvider {

    class func updateDateMap(date: Date, isWeekly: Bool = true) -> [Date] {

        var dates = [Date]()
        let startOfMonth = date.startOfMonth(in: Calendar.current)
        isWeekly ? (dates = date.getWeekDates()) : (dates = startOfMonth.getMonthlyDates())
        return dates
    }
}
