//
//  CalendarValue.swift
//  CalendarApp
//
// Modified by Sunmi on 2020/09/03.
// Copyright © 2020 creativeSun. All rights reserved.


import Foundation

enum CalendarMode {
    case single, range
}

protocol CalendarValue {
    static var mode: CalendarMode { get set }
    func outOfRange(minDate: Date?, maxDate: Date?) -> Bool
}

struct CalendarRange: CalendarValue, Hashable {

    var fromDate: Date
    var toDate: Date
    
    static var mode: CalendarMode = .single
    
    init(from fromDate: Date, to toDate: Date) {
        self.fromDate = fromDate
        self.toDate = toDate
    }
    
    static func from(_ fromDate: Date, to toDate: Date) -> CalendarRange {
        return CalendarRange(from: fromDate, to: toDate)
    }
    
    var onSameDay: Bool {
        return self.fromDate.isInSameDay(date: self.toDate)
    }
    
    func outOfRange(minDate: Date?, maxDate: Date?) -> Bool {
        return self.fromDate < minDate ?? self.fromDate || self.toDate > maxDate ?? self.toDate
    }
    
}

enum CalendarModeSingle {
    case single
    
}
enum CalendarModeRange {
    case range
    
}

extension Date: CalendarValue {
    
    static var mode: CalendarMode = .single
    
    func outOfRange(minDate: Date?, maxDate: Date?) -> Bool {
        return self < minDate ?? self || self > maxDate ?? self
    }
    
}
