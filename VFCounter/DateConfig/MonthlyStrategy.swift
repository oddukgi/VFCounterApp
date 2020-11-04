//
//  MonthlyStrategy.swift
//  VFCounter
//
//  Created by Sunmi on 2020/09/23.
//  Copyright © 2020 creativeSun. All rights reserved.
//

import Foundation
import CoreStore

public class MonthlyDateStrategy: DateStrategy {
    
    public var date: Date = Date()
    
    private var privateMinimumDate: Date?
    private var privateMaximumDate: Date?
    private var vDates: [String] = []
    private var fDates: [String] = []
    private var dateValue = DateValue()

    public var mininumDate: Date? {
        set {
            self.privateMinimumDate = newValue
        }
        get {
            return self.privateMinimumDate
        }
    }

   public var maximumDate: Date? {
        set {
            self.privateMaximumDate = newValue?.endOfMonth()
        }
        get {
            return self.privateMaximumDate
        }
    }

    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "YYYY MM"
        return formatter
    }()
    
    public var period: String {
       return dateFormatter.string(from: date)
    }
    
    // MARK: - Object Lifecycle
    public init(date: Date) {
        self.date = date
    }

    public func getDateMap() -> [Date] {
        let monthDates = DateProvider.updateDateMap(date: date, isWeekly: false)
        return monthDates
    }
    
    public var strDateMap: [String] {
        
        let datemap = getDateMap()
        let strDates = datemap.map { $0.changeDateTime(format: .longDate) }
        return strDates
    }
    
    public func getCommonDate() -> [String] {
        let strDates = strDateMap
        let dataManager = CoreDataManager()
        var items = Set<String>()
    
        strDates.forEach { (element) in
            // get yyyy.MM.dd
            let shortDate = element.extractDate
            guard dataManager.getEntityCount(date: shortDate) > 0 else { return }
            items.insert(element)
        }
    
        return Array(items).sorted()
    }
    
    public func fetchedData() {
        let dataManager = DataManager()

        let type = ["야채", "과일"]
        // 전체 데이터 가져오기
        let vDatemap = getDateMap(type: type[0])
        let fDatemap = getDateMap(type: type[1])
        
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
    
    // MARK: - Setting Date
    public func getDateMap(type: String) -> [[String: Any]] {
        guard let queryDict = try? Storage.dataStack
                .queryAttributes(From<Category>().select(NSDictionary.self, .attribute(\.$date))
                .where(\.$type == type).orderBy(.descending(\.$date))) else { return [[:]] }
        return queryDict
    }
    
    public func setMinimumDate() {

        switch (dateValue.minV, dateValue.minF) {
        case let (oldVDates?, .none):
            privateMinimumDate = dateValue.minV
        case let (.none, oldFDates?):
            privateMinimumDate = dateValue.minF
        case let (.none, .none):
            privateMinimumDate = date
        default:
            guard let minVeggie = dateValue.minV, let minFruit = dateValue.minF else { return }
            (minVeggie < minFruit) ? (privateMinimumDate = minVeggie) : (privateMinimumDate = minFruit)
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
 
    }

    public func previous() {
        
        guard let minDate = privateMinimumDate else { return }
       
        if date > minDate {

            var firstDate = minDate.startOfMonth()
            let map = firstDate.getMonthlyDates()
            
            if map.contains(date) { return }
            
            date = date.lastMonth
//            DateSettings.default.periodController.monthDate = date
        }
    }

    public func next() {
        guard let maxDate = privateMaximumDate else { return }
        let maxYear = maxDate.getYear
        let maxMonth = maxDate.getMonth
        let year = date.getYear
        let month = date.getMonth

        if ((year == maxYear) && (month < maxMonth)) || (year != maxYear) {
            date = date.nextMonth
//            DateSettings.default.periodController.monthDate = date
        }
    }

}
