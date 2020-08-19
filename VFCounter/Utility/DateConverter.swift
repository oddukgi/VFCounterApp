//
//  DateConverter.swift
//  VFCounter
//
//  Created by Sunmi on 2020/07/22.
//  Copyright © 2020 creativeSun. All rights reserved.
//

import Foundation

class TimeFormatter {

    var timeformat: String
    lazy var getTimeForm = self.getTimeFormatter()
    
    init(timeformat: String) {
        self.timeformat = timeformat
    }
    
    private func getTimeFormatter() -> DateFormatter {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.current
        formatter.dateFormat = timeformat
        return formatter
    }
    
    func getCurrentTime(date: Date) -> String {
        return getTimeForm.string(from: Date())
    }
}

class DateConverter {
    
    var date: Date
    let dateFormatter = DateFormatter()

    init(date: Date) {
        self.date = date
    }
  
    var stringDT: String {
        return getCurrentDT().string(from: date)
    }
    
    var dateTime: Date {
        let datetime = getCurrentDT().date(from: stringDT)
        return datetime!
    }
    
    func getCurrentDT() -> DateFormatter {
        
        dateFormatter.timeZone = TimeZone.autoupdatingCurrent
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.dateFormat = "M월 d일 EEE a h시 m분"
        
        dateFormatter.amSymbol = "오전"
        dateFormatter.pmSymbol = "오후"
        return dateFormatter
    }
    
    func getEntityDT() -> String {
        dateFormatter.timeZone = TimeZone.autoupdatingCurrent
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.dateFormat = "yyyy.MM.dd"
        
        return dateFormatter.string(from: date)
    }

    func convertDate() -> String {
        let component = date.get(.year,.month,.day,.weekday)
        let year  = component.year ?? 1900
        let month = component.month ?? 1
        let day   = component.day   ?? 1
        let index = component.weekday!
        let weekdays = [1:"일", 2:"월", 3:"화", 4:"수",
                        5:"목", 6:"금", 7:"토"]
        let weekday = weekdays[index]!

        let newDate = "\(year).\(month).\(day) \(weekday)"
//        print(newDate)
        return newDate
    }
    
    func getWeekDayIndex() -> Int {
        let component = date.get(.year,.month,.day,.weekday)
        return component.weekday!
    }
}

