//
//  ChartVC.swift
//  VFCounter
//
//  Created by Sunmi on 2020/07/21.
//  Copyright © 2020 creativeSun. All rights reserved.
//

import UIKit
import Charts
import SnapKit
import CoreStore

class ChartVC: ChartBaseVC {
    
    var segmentControl: CustomSegmentControl!
    let barChartView = BarChartView()
    let dataManager = DataManager()
    let dateConverter = DateConverter(date: Date())

    private var veggieSum: Int16 = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Chart"
        view.backgroundColor = .systemBackground
        configure()
        configureChart()
        applyChartOption()
        configureMarker()
        updateChartData()
    }
  
    @objc func changedIndexSegment(sender: UISegmentedControl) {
        
        let index = sender.selectedSegmentIndex
        
        switch index {
        case 0:
            print("Tapped \(index)")
  
        default:
            print("Tapped \(index)")
 
        }
    }
    
    override func updateChartData() {
        if self.shouldHideData {
            barChartView.data = nil
            return
        }
        
//        getSumOfValueInEntity()

        
    }
        
    func setDataCount(count: Int, sumVeggie : Int16, sumFruit: Int16) {
       
        let start = 1
        var barchartEntry: BarChartDataEntry!

        let yVeggie = (start..<start + count).map { (i) -> BarChartDataEntry in

            let index = dateConverter.getWeekDayIndex() + 1
            
            if i == index {
                barchartEntry = BarChartDataEntry(x: Double(i - 1), y: Double(sumVeggie))
            } else {
                barchartEntry = BarChartDataEntry(x: Double(i - 1), y: 0)
            }
            return barchartEntry
        }
        
        let yFruit = (start..<start + count).map { (i) -> BarChartDataEntry in

            let index = dateConverter.getWeekDayIndex() + 1
            
            if i == index {
                barchartEntry = BarChartDataEntry(x: Double(i - 1), y: Double(sumFruit))
            } else {
                barchartEntry = BarChartDataEntry(x: Double(i - 1), y: 0)
            }
            return barchartEntry
        }

        var veggie: BarChartDataSet! = nil
        veggie = BarChartDataSet(entries: yVeggie, label: "Veggie")
        veggie.setColor(ChartColor.veggieGreen)
        veggie.drawValuesEnabled = false

        var fruit: BarChartDataSet! = nil
        fruit = BarChartDataSet(entries: yFruit, label: "Fruit")
        fruit.setColor(ChartColor.fruitYellow)
     
        let data = BarChartData(dataSets: [veggie, fruit])
        data.setValueFont(.systemFont(ofSize: 10, weight: .light))
        data.barWidth = 0.3
        data.groupBars(fromX: 0, groupSpace: 0.08, barSpace: 0.03)

        barChartView.data = data
    }
    
    
    func getSumOfValueInEntity() {
      
        //getSumItems()
        dataManager.getSumItems(date: "") { (veggieSum, fruitSum) in
            print("\(veggieSum) \(fruitSum)")
            
            DispatchQueue.main.async {
                if self.segmentControl.selectedSegmentIndex == 0 {
                    self.setDataCount(count: 7, sumVeggie : veggieSum, sumFruit: fruitSum)
                } else {
                    self.setDataCount(count: 31,sumVeggie : veggieSum, sumFruit: fruitSum)
                }
            }
        }
        
    }
   
}
