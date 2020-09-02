//
//  Date+Ext.swift
//  VFCounter
//
//  Created by Sunmi on 2020/08/07.
//  Copyright © 2020 creativeSun. All rights reserved.
//

import Foundation

extension Date {
    
    
    enum Format: String {
        case date = "yyyy.MM.dd"
        case dateTime = "yyyy.MM.dd h:mm:ss a"
        case longDate = "yyyy.MM.dd EEE"
        case onlyTime = " h:mm:ss a"
        case pickerTime = " HH:mm:ss"
        case selectedDT = "yyyy-MM-dd HH:mm:ss"
    }
    
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
    
    func getYear() -> Int {
        let component = self.get(.year,.month,.day)
        let year = component.year ?? 1900
        return year
    }
    
    func getMonth() -> Int {
        let component = self.get(.year,.month,.day)
        let month = component.month ?? 1
        return month
    }
    
    func getDay() -> Int {
        let component = self.get(.year,.month,.day)
        let day = component.day ?? 31
        return day
    }

    func startOfMonth(in calendar: Calendar = .current) -> Date {
        return calendar.date(from: calendar.dateComponents([.year, .month], from: calendar.startOfDay(for: self)))!
    }
    
    func endOfMonth(in calendar: Calendar = .current) -> Date {
        return calendar.date(byAdding: DateComponents(month: 1, day: -1),
                             to: self.startOfMonth(in: calendar))!.endOfDay(in: calendar)
    }
    
  
    func startOfDay(in calendar: Calendar = .current) -> Date {
        return calendar.date(bySettingHour: 0, minute: 0, second: 0, of: self)!
    }
    
    func endOfDay(in calendar: Calendar = .current) -> Date {
        return calendar.date(bySettingHour: 23, minute: 59, second: 59, of: self)!
    }
    
    // Start Of Week, End Of Week
    func getStartOfWeek(in calendar: Calendar = .current, value: Int = 1) -> Date {
        let startDate = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self))!
        return calendar.date(byAdding: .day, value: value, to: startDate)!
    }
    
    func getEndOfWeek(in calendar: Calendar = .current, value: Int = 7) -> Date {
        let startDate = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self))!
        return calendar.date(byAdding: .day, value: value, to: startDate)!
    }
    
    func getFirstDayMonth() -> Int {
        let date = startOfMonth()
        let component = date.get(.year,.month,.day)
        return component.day ?? 30
    }
    
    func getLastDayMonth() -> Int {
        let date = endOfMonth()
        let component = date.get(.year,.month,.day)
        return component.day ?? 30
    }
    
    
    func changeDateTime(format: Format) -> String {
        
        let formatter = DateFormatter()
        formatter.dateFormat = format.rawValue
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.timeZone = TimeZone.current
        return formatter.string(from: self)
    }
    
    
    var dayBefore: Date {
        return Calendar.current.date(byAdding: .day, value: -1, to: self)!
    }
    
    var dayAfter: Date {
        return Calendar.current.date(byAdding: .day, value: +1, to: self)!
    }

    var aDayInLastWeek: Date {
        return Calendar.current.date(byAdding: .weekOfYear, value: -1, to: self)!
    }
    
    var aDayInNextWeek: Date {
        return Calendar.current.date(byAdding: .weekOfYear, value: +1, to: self)!
    }

    func getWeekDates() -> [Date] {
        
        var arrThisWeek: [Date] = []
        for i in 0..<7 {
            arrThisWeek.append(Calendar.current.date(byAdding: .day, value: i, to: self)!)
        }
        
        return arrThisWeek
    }
    
    func addDaysToday(days: Int) -> Date? {
        var dateComponents = DateComponents()
        dateComponents.day = days

        return Calendar.current.date(byAdding: dateComponents, to: self) //you can return your own Date here.
    }
    
    func dayOfWeek() -> String? {
         let dateFormatter = DateFormatter()
         dateFormatter.timeZone = TimeZone.current
         dateFormatter.locale = Locale(identifier: "ko_KR")
         dateFormatter.dateFormat = "EEE"
         return dateFormatter.string(from: self)
     }
    
    func getFirstMonthDate(in calendar: Calendar = .current) -> Date? {
        var minDateComponent = calendar.dateComponents([.year, .month, .day], from: self)
        minDateComponent.month = 1
        minDateComponent.day = 1 
        return calendar.date(from: minDateComponent)?.endOfDay()
    }

}

