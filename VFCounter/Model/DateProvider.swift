//
//  DateProvider.swift
//  VFCounter
//
//  Created by Sunmi on 2020/08/28.
//  Copyright © 2020 creativeSun. All rights reserved.
//

import Foundation

class DateProvider {
    
    class func updateDateMap(date: Date, period: PeriodRange) -> [String]{
        
        var dates = [Date]()
        (period == .weekly) ? (dates = date.getWeekDates()) : (dates = date.getMonthlyDates())
        let arrDates = dates.map { $0.changeDateTime(format: .longDate)}
        return arrDates 
    }
    
}
struct Weeks: Hashable {
    var day: String
    let identifiable = UUID()
    
    func hash(into hasher: inout Hasher){
        hasher.combine(identifiable)
    }
}
struct SubItems: Hashable {
    var element: DataType
    let identifiable = UUID()
    
    func hash(into hasher: inout Hasher){
        hasher.combine(identifiable)
    }
}
