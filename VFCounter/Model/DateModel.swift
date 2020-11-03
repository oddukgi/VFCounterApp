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
    var valueConfig: ValueConfig

    init(date: String = "", type: String, config: ValueConfig) {
        self.date = date
        self.type  = type
        self.valueConfig = config
        changeDateFormat()

    }

    mutating func changeDateFormat() {
        self.date += Date().changeDateTime(format: .onlyTime)
    }
}

struct ItemDate {
    var oldItem: String = ""
    var newItem: String = ""
    var oldDate: String = ""
    var newDate: String = ""
    var entityDT: Date = Date()
    init() { }
}
