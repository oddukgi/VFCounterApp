//
//  DateProvider.swift
//  VFCounter
//
//  Created by Sunmi on 2020/08/28.
//  Copyright © 2020 creativeSun. All rights reserved.
//

import Foundation

class DateProvider {

    class func updateDateMap(date: Date, isWeekly: Bool = true) -> [String] {

        var dates = [Date]()
        let startOfMonth = date.startOfMonth(in: Calendar.current)
        isWeekly ? (dates = date.getWeekDates()) : (dates = startOfMonth.getMonthlyDates())
        let arrDates = dates.map { $0.changeDateTime(format: .longDate)}
        return arrDates
    }
}

struct Weeks: Hashable {
    var day: String
    let identifiable = UUID()

    func hash(into hasher: inout Hasher) {
        hasher.combine(identifiable)
    }
}

struct SubItems: Hashable {
    var element: DataType
    let identifiable = UUID()

    func hash(into hasher: inout Hasher) {
        hasher.combine(identifiable)
    }
}

struct ValueConfig {
    var maxVeggies: Int = 0
    var maxFruits: Int  = 0
    var sumVeggies: Int  = 0
    var sumFruits: Int  = 0

    init() {}
}
