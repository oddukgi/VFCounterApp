//
//  CalendarShortcut.swift
//  CalendarApp
//
//  Modified by Sunmi on 2020/09/05.
//  Copyright © 2020 RetailDriver LLC. All rights reserved.
//  Copyright © 2020 creativeSun. All rights reserved.
//

import Foundation

struct CalendarShortcut<Value: CalendarValue>: Hashable {
    
    private var id: UUID = UUID()
    public var name: String
    public var action: () -> Value
    
    public init(name: String, action: @escaping () -> Value) {
        self.name = name
        self.action = action
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(self.id)
    }
    
    public static func == (lhs: CalendarShortcut<Value>, rhs: CalendarShortcut<Value>) -> Bool {
        return lhs.id == rhs.id
    }
    
    internal func isEqual(to value: Value) -> Bool {
        if let date1 = self.action() as? Date, let date2 = value as? Date {
            return date1.isInSameDay(date: date2)
        } else if let value1 = self.action() as? CalendarRange, let value2 = value as? CalendarRange {
            return value1 == value2
        }
        return false
    }
           
}

extension CalendarShortcut where Value == CalendarRange {
    
    static var today: CalendarShortcut {
        return CalendarShortcut(name: "Today") {
            let now = Date()
            return CalendarRange(from: now.startOfDay(), to: now.endOfDay())
        }
    }
    
    static var lastWeek: CalendarShortcut {
        return CalendarShortcut(name: "Last week") {
            let now = Date()
            let weekAgo = Calendar.current.date(byAdding: .day, value: -7, to: now)!
            return CalendarRange(from: weekAgo.startOfDay(), to: now.endOfDay())
        }
    }
    
    static var lastMonth: CalendarShortcut {
        return CalendarShortcut(name: "Last month") {
            let now = Date()
            let monthAgo = Calendar.current.date(byAdding: .month, value: -1, to: now)!
            return CalendarRange(from: monthAgo.startOfDay(), to: now.endOfDay())
        }
    }
    
}

extension CalendarShortcut where Value == Date {
    
    static var today: CalendarShortcut {
        return CalendarShortcut(name: "Today") {
            return Date()
        }
    }
    
    static var yesterday: CalendarShortcut {
        return CalendarShortcut(name: "Yesterday") {
            return Calendar.current.date(byAdding: .day, value: -1, to: Date())!
        }
    }
    
    static var tomorrow: CalendarShortcut {
        return CalendarShortcut(name: "Tomorrow") {
            return Calendar.current.date(byAdding: .day, value: 1, to: Date())!
        }
    }
    
}
