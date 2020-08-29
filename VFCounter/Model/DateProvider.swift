//
//  DateProvider.swift
//  VFCounter
//
//  Created by Sunmi on 2020/08/28.
//  Copyright © 2020 creativeSun. All rights reserved.
//

import Foundation

class DateProvider {
    
    class func updateDateMap(date: Date, format: String = "yyyy.MM.dd EEE", _ completion: DateMaps) {
        let mDate = date.getWeekDates()
        let arrDates = mDate.map { $0.changeDateTimeKR(format: format)}
        completion(arrDates)        
    }
    
}
