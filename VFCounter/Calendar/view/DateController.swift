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
    
    var listCtrl      = DateSettings.HistoryList()
    var monthlyListCtrl = DateSettings.MonthlyList()
    var weekChartCtrl = DateSettings.WeeklyChartController()
    
}
