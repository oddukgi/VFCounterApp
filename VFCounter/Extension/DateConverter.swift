//
//  DateConverter.swift
//  VFCounter
//
//  Created by Sunmi on 2020/07/22.
//  Copyright © 2020 creativeSun. All rights reserved.
//

import Foundation


class TimeFormatter {
    
    
    lazy var getTimeForm = self.getTimeFormatter()
    
    private func getTimeFormatter() -> DateFormatter {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.current
        formatter.dateFormat = "h:mm a"
        return formatter
    }
}

class DateConverter {
    
    var date: Date
    lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.setLocalizedDateFormatFromTemplate("yyyy.MM.dd EEE")
        
        return formatter
    }()

    init(date: Date) {
        self.date = date
        
    }

    func convertDate() -> String {
        let currentDate = dateFormatter.string(from: date)
        // remove bracket ( )
        let trimmedBracket = currentDate.replacingOccurrences(of: "(", with: "", options:
          NSString.CompareOptions.literal, range: nil).replacingOccurrences(of: ")", with: "", options:
        NSString.CompareOptions.literal, range: nil)
        
        // remove whitespace
        var newDate = trimmedBracket.replacingOccurrences(of: " ", with: "")
        let index = newDate.index(newDate.startIndex, offsetBy: 10)
        newDate.replaceSubrange(index...index, with: "  ")
        return newDate
    }


}
