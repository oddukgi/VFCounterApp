//
//  VFCounterTests.swift
//  VFCounterTests
//
//  Created by Sunmi on 2020/07/21.
//  Copyright © 2020 creativeSun. All rights reserved.
//

import XCTest
@testable import VFCounter

class VFCounterTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            _ = HomeVC()
        }
    }
    
    func testAmount() {
        
        let dataManager = DataManager()
        let veggieAmount = Int(SettingManager.getTaskValue(keyName: "VeggieTaskRate") ?? 0)
        let fruitAmount = Int(SettingManager.getTaskValue(keyName: "FruitTaskRate") ?? 0)

        var vDates = Array<String>()
        var fDates = Array<String>()
        
        dataManager.getDateDictionary { (veggieDates, fruitDates) in
            
            veggieDates.forEach { (item) in
                _ = item.compactMap ({ if $0 == "date" {  vDates.append($1 as! String) } })
            }
            
            
            fruitDates.forEach { (item) in
                _ = item.compactMap ({ if $0 == "date" {  fDates.append($1 as! String) } })
            }
        }
        
        vDates.forEach { (date) in

            let amount = dataManager.getSumItems(date: date)
            print(amount.0, veggieAmount)
            XCTAssertTrue(amount.0 < veggieAmount)
        }
        
        fDates.forEach { (date) in

            let amount = dataManager.getSumItems(date: date)
            print(amount.1, fruitAmount)
            XCTAssertTrue(amount.1 < fruitAmount)
        }
        
    }
    
    
    func compareStoreDate() {

        let today = Date().changeDateTime(format: .date)
        var vDates = Array<String>()
        var fDates = Array<String>()
        
        let dataManager = DataManager()
        dataManager.getDateDictionary { (veggieDates, fruitDates) in
            
            veggieDates.forEach { (item) in
                _ = item.compactMap ({ if $0 == "date" {  vDates.append($1 as! String) } })
            }
            
            
            fruitDates.forEach { (item) in
                _ = item.compactMap ({ if $0 == "date" {  fDates.append($1 as! String) } })
            }
        }
        
        vDates.forEach { (date) in

            if date.contains(today) {
                XCTAssertTrue(date.contains(today))
            }
        }
        
    }
  
}
