//
//  MonthlyStrategy.swift
//  VFCounter
//
//  Created by Sunmi on 2020/09/23.
//  Copyright © 2020 creativeSun. All rights reserved.
//

import Foundation

struct MonthlyList {
    var startDate: Date?
    var format: String = "YYYY MM"
    var locale = Locale(identifier: "ko_KR")

}

struct DateValue {
    var minV: Date?
    var minF: Date?
    var maxV: Date?
    var maxF: Date?
}

public class MonthlyDateStrategy: DateStrategy {

    public var date: Date = Date()

    private var privateMinimumDate: Date?
    private var privateMaximumDate: Date?

    // MARK: - Date Setting    
    private var vDates: [String] = []
    private var fDates: [String] = []

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

    let monthList = MonthlyList()
    var dateValue = DateValue()

    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = monthList.locale
        formatter.dateFormat = monthList.format
        return formatter
    }()

    // MARK: - Object Lifecycle
    public init(date: Date) {
        self.date = date
    }

    // MARK: - Setting Date
    public func updateLabel() -> (String?, [String]?, [String]?) {

        let strDate = dateFormatter.string(from: date)
        let datemap = DateProvider.updateDateMap(date: date, isWeekly: false)
        let monthlyDate = checkDate(datemap: datemap)

        return (strDate, monthlyDate, datemap)
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

    public func fetchedData() {
        let dataManager = DataManager()
        dataManager.getDateDictionary { (veggieDates, fruitDates) in

            veggieDates.forEach { (item) in
                _ = item.compactMap({ if $0 == "date" {  vDates.append($1 as? String ?? "") } })
            }

            fruitDates.forEach { (item) in
                _ = item.compactMap({ if $0 == "date" {  fDates.append($1 as? String ?? "") } })
            }
        }

        dateValue.minV = vDates.last?.changeDateTime(format: .date)
        dateValue.minF = fDates.last?.changeDateTime(format: .date)
        dateValue.maxV = vDates.first?.changeDateTime(format: .date)
        dateValue.maxF = fDates.first?.changeDateTime(format: .date)
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

        if let minDate = privateMinimumDate, date > minDate.startOfMonth().dayAfter {
            date = date.lastMonth
            DateSettings.default.periodController.monthDate = date
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
            DateSettings.default.periodController.monthDate = date
        }
    }

}
