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
        formatter.locale = Locale(identifier: "ko_KR")
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
    

    
    func changeDate(format: String, option: Int) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_KR")
        (option == 1) ? ( dateFormatter.dateStyle = .short ) : ( dateFormatter.dateStyle = .medium)
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: date)
    }
    
    func getWeekDayIndex() -> Int {
        let component = date.get(.year,.month,.day,.weekday)
        return component.weekday!
    }
    
    func convertDayToInt() -> Int {
        let component = date.get(.year,.month,.day,.weekday)
        return component.day!
    }  
}

