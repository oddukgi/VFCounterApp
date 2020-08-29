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
    
    func changeDateTimeKR(format: String) -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
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
}


// Time Comparison (included seconds)

extension Date {
    func secondsFromBeginningOfTheDay() -> TimeInterval {
        let calendar = Calendar.current
        //omitting fractions of seconds for simplicity
        let dateComponents = calendar.dateComponents([.hour, .minute,.second], from: self)
        // calcurate seconds
        let dateSeconds = dateComponents.hour! * 3600 + dateComponents.minute! * 60 + dateComponents.second!
       
        return TimeInterval(dateSeconds)
    }
    
    // Interval between two times of the day in seconds
    func timeOfDayInterval(toDate date: Date) -> TimeInterval {
        let date1Seconds = self.secondsFromBeginningOfTheDay()
        let date2Seconds = date.secondsFromBeginningOfTheDay()
        return date2Seconds - date1Seconds
    }
}
// get next week

