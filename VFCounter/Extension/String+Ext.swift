//
//  String+Ext.swift
//  VFCounter
//
//  Created by Sunmi on 2020/08/03.
//  Copyright © 2020 creativeSun. All rights reserved.
//

import UIKit

extension String {
    func format(_ arguments: CVarArg...) -> String {
        let args = arguments.map {
            if let arg = $0 as? Int { return String(arg) }
            if let arg = $0 as? Float { return String(arg) }
            if let arg = $0 as? Double { return String(arg) }
            if let arg = $0 as? Int64 { return String(arg) }
            if let arg = $0 as? String { return String(arg) }
//            if let arg = $0 as? Character { return String(arg) }

            return "(null)"
            } as [CVarArg]

        return String.init(format: self, arguments: args)
    }

    /// Generates a `UIImage` instance from this string using a specified
    /// attributes and size.
    ///
    /// - Parameters:
    ///     - attributes: to draw this string with. Default is `nil`.
    ///     - size: of the image to return.
    /// - Returns: a `UIImage` instance from this string using a specified
    /// attributes and size, or `nil` if the operation fails.

    func image(withAttributes attributes: [NSAttributedString.Key: Any]? = nil, size: CGSize? = nil) -> UIImage? {
        let size = size ?? (self as NSString).size(withAttributes: attributes)
        return UIGraphicsImageRenderer(size: size).image { _ in
            (self as NSString).draw(in: CGRect(origin: .zero, size: size),
                                    withAttributes: attributes)
        }
    }

    func imageWith(fontSize: CGFloat = 10, width: CGFloat = 20, height: CGFloat = 20, textColor: UIColor = .black) -> UIImage? {
         let frame = CGRect(x: 0, y: 0, width: width, height: height)
         let nameLabel = UILabel(frame: frame)
         nameLabel.textAlignment = .center
         nameLabel.backgroundColor = .clear
         nameLabel.textColor = textColor
         nameLabel.font = UIFont.systemFont(ofSize: fontSize, weight: .semibold)
         nameLabel.text = self
         UIGraphicsBeginImageContext(frame.size)
          if let currentContext = UIGraphicsGetCurrentContext() {
             nameLabel.layer.render(in: currentContext)
             let nameImage = UIGraphicsGetImageFromCurrentImageContext()
             return nameImage
          }
          return nil
    }

    func trimmingTime(start: Int, end: Int) -> String {
        var time = self
        let start = time.index(time.startIndex, offsetBy: start)
        let end = time.index(time.endIndex, offsetBy: end)
        let range = start..<end
        time.removeSubrange(range)
        return time
    }

    func changeDateTime(format: Date.Format) -> Date {
       let formatter = DateFormatter()
        formatter.dateFormat = format.rawValue
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.timeZone = TimeZone.current
        return formatter.date(from: self)!
    }

    func getWeekdayIndex() -> Int {

        let days = ["월", "화", "수", "목", "금", "토", "일"]
        return days.firstIndex(of: self)!
    }

    func containsWeekday() -> Bool {
        return rangeOfCharacter(from: CharacterSet(charactersIn: "월화수목금토일")) != nil
    }

    func containsNumber() -> String {
        let aSet = NSCharacterSet(charactersIn: "0123456789").inverted
        let compSepByCharInSet = self.components(separatedBy: aSet)
        let numberFiltered = compSepByCharInSet.joined(separator: "")
        return numberFiltered
    }

    func doesStringContains(input: String) -> Bool {
        return self.range(of: input, options: .caseInsensitive) != nil
    }
    
    var extractDate: String {
        return self.components(separatedBy: " ")[0]
    }
    
    func retrieveKind() -> String {

        var type = ""
        let name = self
        let fruit = [
                        "사과", "살구", "아보카도", "바나나", "블루베리", "체리",
                        "코코넛", "용과", "포도", "자몽", "아오리", "샤인머스캣",
                        "천도복숭아", "키위", "레몬", "망고", "망고스틴", "멜론",
                        "오렌지", "복숭아", "배", "감", "파인애플", "자두",
                        "석류", "라즈베리", "딸기", "귤", "수박"
                    ]

        for item in fruit {
            if item.doesStringContains(input: name) {
                type = "과일"
                break
            } else {
                type = "야채"
            }
        }
        
        return type
    }
    
    func getWeekday() -> String {
        
        var date = self
//        print("getWeekday: \(date)")
        let weekday =  date.changeDateTime(format: .date).startOfDay().getWeekday()
        let fullDate = date + " \(weekday)"
        return fullDate
    }
}

extension Double {

    // convert double to string
    func roundValue() -> String {
        return String(format: "%.5f", self)
    }
}

/*
 let numberFormatter = NumberFormatter()
 numberFormatter.roundingMode = .floor         // 형식을 버림으로 지정
 numberFormatter.minimumSignificantDigits = 2  // 자르길 원하는 자릿수
 numberFormatter.maximumSignificantDigits = 2
 let originalNum = 1.6759402                   // 원하는 숫자
 let newNum = numberFormatter.string(from: originalNum) // result 1.67
 */
