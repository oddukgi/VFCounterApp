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
        case shortDT = "yyyy.MM.dd h:mm a"
        case longDate = "yyyy.MM.dd EEE"
        case onlyTime = " h:mm:ss a"
        case time = " h:mm a"
        case pickerTime = " HH:mm:ss"
        case selectedDT = "yyyy-MM-dd HH:mm:ss"
        case day       = "EEE"
    }

    /// get month, year, day
    func get(_ components: Calendar.Component..., calendar: Calendar = Calendar.current) -> DateComponents {
        return calendar.dateComponents(Set(components), from: self)
    }

    func get(_ component: Calendar.Component, calendar: Calendar = Calendar.current) -> Int {
        return calendar.component(component, from: self)
    }

    var getYear: Int {
        let component = self.get(.year, .month, .day)
        let year = component.year ?? 1900
        return year
    }

    var getMonth: Int {
        let component = self.get(.year, .month, .day)
        let month = component.month ?? 1
        return month
    }

    var getDay: Int {
        let component = self.get(.year, .month, .day)
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

    func isInSameDay(in calendar: Calendar = .current, date: Date) -> Bool {
        return calendar.isDate(self, equalTo: date, toGranularity: .month)
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
    func startOfWeek(in calendar: Calendar = .current, value: Int = 1) -> Date {
        let startDate = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self))!
        return calendar.date(byAdding: .day, value: value, to: startDate)!
    }

    func endOfWeek(in calendar: Calendar = .current, value: Int = 7) -> Date {
        let startDate = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self))!
        return calendar.date(byAdding: .day, value: value, to: startDate)!
    }
    
    func getLastDayMonth() -> Int {
        let date = endOfMonth()
        let component = date.get(.year, .month, .day)
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

    var lastMonth: Date {
        return Calendar.current.date(byAdding: .month, value: -1, to: self)!
    }

    var nextMonth: Date {
        return Calendar.current.date(byAdding: .month, value: +1, to: self)!
    }
    
    func getWeekday() -> String {

        print(self)
        var weekday = ""
        var calendar = Calendar(identifier: .gregorian)
        calendar.locale = NSLocale(localeIdentifier: "ko_KR") as Locale
        var weekDays = calendar.shortWeekdaySymbols
        weekDays.append(weekDays.remove(at: 0))
        
        let index = calendar.component(.weekday, from: self)
        // 일1,  ~ 토 7
     
        return (index == 1) ? weekDays[6] : weekDays[index - 2]
  
    }

}

extension Date {

    // get 7 days
    func getWeekDates() -> [Date] {

        var arrThisWeek: [Date] = []
        for index in 0 ..< 7 {
            arrThisWeek.append(Calendar.current.date(byAdding: .day, value: index, to: self)!)
            
        }

        return arrThisWeek
    }

    // get 30 days
    func getMonthlyDates() -> [Date] {
        var arrThisMonth: [Date] = []
        let lastDayOfMonth = self.getLastDayMonth()
        for index in 0 ..< lastDayOfMonth {
            arrThisMonth.append(Calendar.current.date(byAdding: .day, value: index, to: self)!)
        }

        return arrThisMonth
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
         dateFormatter.dateFormat = "E"
         let weekday = dateFormatter.string(from: self)
         return weekday
     }
    
    func getFirstMonthDate(in calendar: Calendar = .current) -> Date? {
        var minDateComponent = calendar.dateComponents([.year, .month, .day], from: self)
        minDateComponent.month = 1
        minDateComponent.day = 1
        return calendar.date(from: minDateComponent)?.endOfDay()
    }
    
    func compareTo(date: Date, toGranularity: Calendar.Component ) -> ComparisonResult {
        var cal = Calendar.current
        return cal.compare(self, to: date, toGranularity: toGranularity)
    }
    
    func getCurrentWeek() -> [Date] {
        var calendar = Calendar.current
        calendar.firstWeekday = 2 // Start on Monday (or 1 for Sunday)
        let today = calendar.startOfDay(for: self)
        var week = [Date]()
        if let weekInterval = calendar.dateInterval(of: .weekOfYear, for: today) {
            for i in 0...6 {
                if let day = calendar.date(byAdding: .day, value: i, to: weekInterval.start) {
                    week += [day]
                }
            }
        }
        
        return week
    }
    
    func compareDate(date1: Date?) -> Bool {
        let order = Calendar.current.compare(date1!, to: self, toGranularity: .day)
        switch order {
        case .orderedAscending:
            return true
            
        case .orderedDescending:
            return true
            
        default:
            return false
        }
    }

}
