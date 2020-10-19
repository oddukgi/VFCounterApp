//
//  WeeklyDateStrategy.swift
//  VFCounter
//
//  Created by Sunmi on 2020/09/23.
//  Copyright © 2020 creativeSun. All rights reserved.
//

import Foundation

public class WeeklyDateStrategy: DateStrategy {
    // MARK: - Properties
    struct DateValue {
        var minV: Date?
        var minF: Date?
        var maxV: Date?
        var maxF: Date?
    }
    public var date: Date = Date()
    private var privateMinimumDate: Date?
    private var privateMaximumDate: Date?
    private var vDates: [String] = []
    private var fDates: [String] = []
    private var configs = ValueConfig()
    var dateValue = DateValue()

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

    public init(date: Date) {
        self.date = date
       
    }

    // MARK: - Setting Date
    public func fetchedData() {
        let dataManager = DataManager()

        var vDatemap: [[String: Any]] = []
        var fDatemap: [[String: Any]] = []
        dataManager.getDateDictionary { (veggieDates, fruitDates) in
            vDatemap = veggieDates
            fDatemap = fruitDates
        }
        
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
    
    public func updateLabel() -> (String?, [String]?, [String]?) {

        var isSunday = false
        var datemap = [String]()
        let weekend = ["토", "일"]
        
        let newDate = date.dayBefore.dayOfWeek() ?? ""
       
        if weekend.contains(newDate) {
            let tmpDate = date.getStartOfWeek(value: -5)
            datemap = DateProvider.updateDateMap(date: tmpDate)
        } else {
            
            date = date.getStartOfWeek()
            datemap = DateProvider.updateDateMap(date: date)
        }
    
        let weeklyDate = setWeeklyDate(startDate: datemap.first!, endDate: datemap.last!)
        let commonDate = checkDate(datemap: datemap)

        return (weeklyDate, commonDate, datemap)
    }

    // 공통 날짜 가져오기
    private func checkDate(datemap: [String]) -> [String] {
        var items = Set<String>()
        let dataManager = DataManager()
        datemap.forEach { (element) in

            let item = element.components(separatedBy: " ").first

            dataManager.getSpecificDate(date: item!) { (veggies, fruits) in
             if veggies.count > 0 {
                 items.insert(element)
             }

             if fruits.count > 0 {
               items.insert(element)
              }
            }
        }

        return Array(items).sorted()
    }

    private func setWeeklyDate(startDate: String, endDate: String) -> String {
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

//        print("Weekly: \(privateMinimumDate),\(privateMaximumDate)")
    }
    
    public func previous() {

        guard let minDate = privateMinimumDate else { return }
        let dateMap = date.getWeekDates()
        // 최소 날짜까지 넘김
        if date > minDate && dateMap.contains(date) {
            date = self.date.aDayInLastWeek.getStartOfWeek()
        }
    }

    public func next() {
        if date <= privateMaximumDate! {
            date = self.date.aDayInNextWeek.getStartOfWeek()
        }
    }
}
