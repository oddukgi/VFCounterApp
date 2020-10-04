//
//  DateController.swift
//  VFCounter
//
//  Created by Sunmi on 2020/09/17.
//  Copyright © 2020 creativeSun. All rights reserved.
//

import Foundation

struct DateSettings {
    static var `default` = DateSettings()
    private init() {}
    var periodController = DateSettings.PeriodController()
}

extension DateSettings {
    struct PeriodController {
       var weekDate: Date?
       var monthDate: Date?
    }
}
