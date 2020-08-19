//
//  Date+Ext.swift
//  VFCounter
//
//  Created by Sunmi on 2020/08/07.
//  Copyright © 2020 creativeSun. All rights reserved.
//

import Foundation

extension Date {
    
    /// get month, year, day
    func get(_ components: Calendar.Component..., calendar: Calendar = Calendar.current) -> DateComponents {
        return calendar.dateComponents(Set(components), from: self)
    }
    
    func get(_ component: Calendar.Component, calendar: Calendar = Calendar.current) -> Int {
        return calendar.component(component, from: self)
    }

    var localizedDescription: String {
        return description(with: .current)
    }
    
    func getMonth() -> Int {
        let component = self.get(.year,.month,.day)
        let month = component.month ?? 1
        return month
    }

    func startOfMonth(in calendar: Calendar = .current) -> Date {
        return calendar.date(from: calendar.dateComponents([.year, .month], from: calendar.startOfDay(for: self)))!
    }
    
    func endOfMonth(in calendar: Calendar = .current) -> Date {
        return calendar.date(byAdding: DateComponents(month: 1, day: -1), to: self.startOfMonth(in: calendar))!.endOfDay(in: calendar)
    }
    
    func isInSameDay(in calendar: Calendar = .current, date: Date) -> Bool {
        return calendar.isDate(self, equalTo: date, toGranularity: .day)
    }
    
    func isInSameMonth(in calendar: Calendar = .current, date: Date) -> Bool {
        return calendar.component(.month, from: self) == calendar.component(.month, from: date)
    }
      
    func startOfDay(in calendar: Calendar = .current) -> Date {
        return calendar.date(bySettingHour: 0, minute: 0, second: 0, of: self)!
    }
    
    func endOfDay(in calendar: Calendar = .current) -> Date {
        return calendar.date(bySettingHour: 23, minute: 59, second: 59, of: self)!
    }
    
    // Start Of Week, End Of Week
    func startOfWeek(in calendar: Calendar = .current) -> Date {
        let startDate = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self))!
        return calendar.date(byAdding: .day, value: 1, to: startDate)!
    }
    
    func endOfWeek(in calendar: Calendar = .current) -> Date {
        let startDate = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self))!
        return calendar.date(byAdding: .day, value: 7, to: startDate)!
    }
    
}
