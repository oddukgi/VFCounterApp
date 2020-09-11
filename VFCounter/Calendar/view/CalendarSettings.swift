//
//  CalendarSettings.swift
//  CalendarApp
//
// Modified by Sunmi on 2020/09/02.
// Copyright © 2020 creativeSun. All rights reserved.



import Foundation

struct CalendarSettings {
    static var `default` = CalendarSettings()
    
    private init() {}
    
    var controller = CalendarSettings.Controller()
    var dayCell = CalendarSettings.DayCell()
    var weekView = CalendarSettings.WeekView()
    var monthSelectView = CalendarSettings.MonthSelectView()
    
    
    
}
