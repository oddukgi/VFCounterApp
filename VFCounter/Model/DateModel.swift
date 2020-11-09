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

struct ItemModel {
    var date: String
    var type: String
    var minDate: Date?
    var maxDate: Date?
    var valueConfig: ValueConfig

    init(date: String = "", type: String, config: ValueConfig,
         minDate: Date? = nil, maxDate: Date? = nil) {
        self.date = date
        self.type  = type
        self.minDate = minDate
        self.maxDate = maxDate
        self.valueConfig = config
        changeDateFormat()

    }

    mutating func changeDateFormat() {
        self.date += Date().changeDateTime(format: .onlyTime)
    }
}

struct PopupItem {
    var oldItem: String = ""
    var newItem: String = ""
    var oldDate: String = ""
    var newDate: String = ""
    var indexForEdit: Int = 0
    var entityDT: Date = Date()
    init() { }
}
