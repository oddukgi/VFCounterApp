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

public class MonthlyDateStrategy: DateStrategy {

    
    public var date: Date = Date()
    
    
    private var privateMinimumDate: Date?
    private var privateMaximumDate: Date?
    private var oldVDates: Date?
    private var oldFDates: Date?
    
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
            
            dataManager.reorderData(date: item!) { (veggies, fruits) in
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
                _ = item.compactMap ({ vDates.append($1 as! String) })
            }
            
            
            fruitDates.forEach { (item) in
                _ = item.compactMap ({ fDates.append($1 as! String) })
            }
        }
        
        oldVDates = vDates.last?.changeDateTime(format: .date)
        oldFDates = fDates.last?.changeDateTime(format: .date)
    }
    
   public func setDateRange() {
        if oldVDates == nil && oldFDates == nil {
            privateMinimumDate = date
        }
    
        privateMaximumDate = Date()
        
        if let dateA = oldVDates, let dateB = oldFDates {
            
            if dateA < dateB {
                privateMinimumDate = dateA
            } else {
                privateMinimumDate = dateB
            }
            
        }
    }
    
    public func previous() {
        if let minDate = privateMinimumDate,  date >= minDate.startOfDay()  {
            date = date.lastMonth

            DateSettings.default.periodController.monthDate = date
        }
    }
 
    public func next() {
        
        let year = date.getYear
        let month = date.getMonth
        let maxYear = privateMaximumDate!.getYear
        let maxMonth = privateMaximumDate!.getMonth
        
        
        if ((year == maxYear) && (month < maxMonth)) ||
                (year != maxYear)  {
        
            date = date.nextMonth
            DateSettings.default.periodController.monthDate = date
        }
    }
    
    public func calcurateItems() {
        
    }
}
