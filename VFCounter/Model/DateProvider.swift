//
//  DateProvider.swift
//  VFCounter
//
//  Created by Sunmi on 2020/08/28.
//  Copyright © 2020 creativeSun. All rights reserved.
//

import Foundation

class DateProvider {
    
    class func updateDateMap(date: Date, _ completion: DateMaps) {
        let mDate = date.getWeekDates()
        let arrDates = mDate.map { $0.changeDateTime(format: .longDate)}
        completion(arrDates)        
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
