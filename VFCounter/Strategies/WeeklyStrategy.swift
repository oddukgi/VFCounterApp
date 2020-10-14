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

    public var date: Date = Date()

    private var privateMinimumDate: Date?
    private var privateMaximumDate: Date?
    private var minVeggieDate: Date?
    private var minFruitDate: Date?
    private var vDates: [String] = []
    private var fDates: [String] = []
    private var configs = ValueConfig()

    // MARK: - Date Setting

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
        maximumDate = self.date
    }

    // MARK: - Setting Date
    public func updateLabel() -> (String?, [String]?, [String]?) {

        if DateSettings.default.periodController.weekDate == nil {
             date = date.getStartOfWeek()
         } else {
             date = DateSettings.default.periodController.weekDate!
         }

        let datemap = DateProvider.updateDateMap(date: date)
        let weeklyDate = setWeeklyDate(startDate: datemap.first!, endDate: datemap.last!)
        let commonDate = checkDate(datemap: datemap)

        return (weeklyDate, commonDate, datemap)
    }

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

    public func fetchedData() {
        let dataManager = DataManager()

        dataManager.getDateDictionary { (veggieDates, fruitDates) in

            veggieDates.forEach { (item) in
                _ = item.compactMap({ if $0 == "date" {  vDates.append($1 as? String ?? "" ) } })
            }

            fruitDates.forEach { (item) in
                _ = item.compactMap({ if $0 == "date" {  fDates.append($1 as? String ?? "") } })
            }
        }

        minVeggieDate = vDates.last?.changeDateTime(format: .date)
        minFruitDate = fDates.last?.changeDateTime(format: .date)

    }

    public func setMinimumDate() {
        
        switch (minVeggieDate, minFruitDate) {
        case let (oldVDates?, .none):
            privateMinimumDate = oldVDates
        case let (.none, oldFDates?):
            privateMinimumDate = oldFDates
        case let (.none, .none):
            privateMinimumDate = date
        default:
            guard let oldVDates = minVeggieDate, let oldFDates = minFruitDate else { return }
            (oldVDates < oldFDates) ? (privateMinimumDate = oldVDates) : (privateMinimumDate = oldFDates)
      }
    }
    public func setMaximumDate() {
        
    }
    
    public func previous() {

        guard let minDate = privateMinimumDate else { return }
        date = self.date.aDayInLastWeek.getStartOfWeek()
        let dateMap = date.getWeekDates()

        // 최소 날짜까지 넘김
        if date > minDate {
            DateSettings.default.periodController.weekDate = date
        } else {
            // 최소날짜에 도달
            if dateMap.contains(minDate) {
                DateSettings.default.periodController.weekDate = date
            }
        }
    }

    public func next() {
        let now = Date()
        if date <= now {
            date = self.date.aDayInNextWeek.getStartOfWeek()
            DateSettings.default.periodController.weekDate = date
        }
    }
}
