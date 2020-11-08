//
//  WeeklyDateStrategy.swift
//  VFCounter
//
//  Created by Sunmi on 2020/09/23.
//  Copyright © 2020 creativeSun. All rights reserved.
//

import Foundation
import CoreStore

public class WeeklyDateStrategy: DateStrategy {

    public var date: Date = Date()
    private var privateMinimumDate: Date?
    private var privateMaximumDate: Date?
    private var vDates: [String] = []
    private var fDates: [String] = []
    private var dateValue = DateValue()

    private var mininumDate: Date? {

        set {
            self.privateMinimumDate = newValue
        }
        get {
            return self.privateMinimumDate
        }
    }

    private var maximumDate: Date? {
        set {
            self.privateMaximumDate = newValue?.endOfMonth()
        }
        get {
            return self.privateMaximumDate
        }
    }
    
    public func getDateMap() -> [Date] {
        
        let weeks = date.getCurrentWeek()
        return weeks
    }
    
    public var strDateMap: [String] {
        
        let datemap = getDateMap()
        let strDates = datemap.map { $0.changeDateTime(format: .longDate) }
        return strDates
    }

    public init(date: Date) {
        self.date = date
    }
    
    public func fetchedData() {

        let type = ["야채", "과일"]
        // 전체 데이터 가져오기
        let vDatemap = getDateDictionary(type: type[0])
        let fDatemap = getDateDictionary(type: type[1])
        
        vDatemap.forEach { (item) in
            _ = item.compactMap({ if $0 == "date" {  self.vDates.append($1 as? String ?? "" ) } })
        }

        fDatemap.forEach { (item) in
            _ = item.compactMap({ if $0 == "date" {  self.fDates.append($1 as? String ?? "") } })
        }

        dateValue.minV = vDates.last?.changeDateTime(format: .date)
        dateValue.minF = fDates.last?.changeDateTime(format: .date)
        dateValue.maxV = vDates.first?.changeDateTime(format: .date)
        dateValue.maxF = fDates.first?.changeDateTime(format: .date)

    }
    
    private func getDateDictionary(type: String) -> [[String: Any]] {
        guard let queryDict = try? Storage.dataStack
                .queryAttributes(From<Category>().select(NSDictionary.self, .attribute(\.$date))
                                    .where(\.$type == type).orderBy(.descending(\.$date))) else { return [[:]] }
        
        return queryDict
    }
   
    public var period: String {
        
        let strDates = strDateMap
        return getWeeklyDate(startDate: strDates.first!, endDate: strDates.last!)
    }

    private func getWeeklyDate(startDate: String, endDate: String) -> String {
        let startDateArray = startDate.components(separatedBy: [".", " "])
        let endDateArray = endDate.components(separatedBy: [".", " "])

        var weekPeriod = ""
        let firstMonth = startDateArray[1]
        let secondMonth = endDateArray[1]

        if firstMonth == secondMonth {
            weekPeriod = "\(firstMonth).\(startDateArray[2]) ~ \(endDateArray[2])"

        } else {
            weekPeriod = "\(firstMonth).\(startDateArray[2]) ~ \(secondMonth).\(endDateArray[2])"
        }
        return weekPeriod
    }

    public func setMinimumDate() {
        
        switch (dateValue.minV, dateValue.minF) {
        case let (oldVDates?, .none):
            privateMinimumDate = oldVDates
        case let (.none, oldFDates?):
            privateMinimumDate = oldFDates
        case let (.none, .none):
            privateMinimumDate = date
        default:
            guard let oldVDates = dateValue.minV, let oldFDates = dateValue.minF else { return }
            (oldVDates < oldFDates) ? (privateMinimumDate = oldVDates) : (privateMinimumDate = oldFDates)
        }
    }
    
    public func setMaximumDate() {
        
        switch (dateValue.maxV, dateValue.maxF) {
        case let (oldVDates?, .none):
            privateMaximumDate = dateValue.maxV
        case let (.none, oldFDates?):
            privateMaximumDate = dateValue.maxF
        case let (.none, .none):
            privateMaximumDate = date
        default:
            guard let maxVeggie = dateValue.maxV, let maxFruit = dateValue.maxF else { return }
            (maxVeggie < maxFruit) ? (privateMaximumDate = maxFruit) : (privateMaximumDate = maxVeggie)
      }

        print("Weekly: \(privateMinimumDate),\(privateMaximumDate)")
    }
    
    public func previous() {

        guard let minDate = privateMinimumDate else { return }
      
        print("Previous: \(date)")
        if date >= minDate {

            print("\(date) is next \(minDate)")
            date = self.date.aDayInLastWeek.startOfWeek()
            
        }
    }

    public func next() {
        
        guard let maxDate = privateMaximumDate else { return }
    
        print("Next: \(date)")
        if date <= maxDate {
            
            print("\(date) is before \(maxDate)")
            date = self.date.aDayInNextWeek.startOfWeek()
        }
    }
    
    // 날짜가 datamap에 들어 있는지 확인
    private func checkDateInMap(date: String) -> Bool {
     
        var date = date.changeDateTime(format: .longDate).startOfDay()
        let map = getDateMap()
        let result = map.filter { $0 <= date && date <= $0 }        
        return (result.count > 0) ? true : false
        
    }
    
}
