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
    private var oldVDates: Date?
    private var oldFDates: Date?
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



    
    
    // MARK: - Object Lifecycle
    public init(date: Date) {
        self.date = date
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
    
    
    private func setWeeklyDate(startDate: String, endDate: String) -> String {
        let startDateArray = startDate.components(separatedBy: [".", " "])
        let endDateArray = endDate.components(separatedBy: ["."," "])

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
            privateMinimumDate = date.lastMonth
        }
        
        if let dateA = oldVDates, let dateB = oldFDates {
            
            if dateA < dateB {
                privateMinimumDate = dateA
            } else {
                privateMinimumDate = dateB
            }
            
        }
    }
    
    public func previous() {
        guard let minDate = privateMinimumDate else { return }
        date = self.date.aDayInLastWeek.getStartOfWeek()

        if date >= minDate {
            DateSettings.default.periodController.weekDate = date
        }
    }
    
    public func next() {
        
        let now = Date()
        if date <= now {
            
            date = self.date.aDayInNextWeek.getStartOfWeek()
            DateSettings.default.periodController.weekDate = date
        }
    }
    
    func getLimitAmount(date: String) {
     
        let dataManager = DataManager()
        configs.maxVeggies = Int(SettingManager.getTaskValue(keyName: "VeggieTaskRate") ?? 0)
        configs.maxFruits = Int(SettingManager.getTaskValue(keyName: "FruitTaskRate") ?? 0)
        
    
        
        
    }
    
}
