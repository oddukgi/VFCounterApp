//
//  DateModel.swift
//  VFCounter
//
//  Created by Sunmi on 2020/09/30.
//  Copyright © 2020 creativeSun. All rights reserved.
//

import Foundation

protocol CalendarVCDelegate: class {
    func updateDate(date: Date, isUpdateCalendar: Bool)
}

struct DateModel {
    var date: String
    var tag: Int
    var sumV: Int
    var sumF: Int
    var maxV: Int
    var maxF: Int

    init(date: String = "", tag: Int, sumV: Int, sumF: Int, maxV: Int, maxF: Int) {
        self.date = date
        self.tag  = tag
        self.sumV = sumV
        self.sumF = sumF
        self.maxV = maxV
        self.maxF = maxF

        changeDateFormat()

    }

    mutating func changeDateFormat() {
        self.date += Date().changeDateTime(format: .onlyTime)
    }
}
