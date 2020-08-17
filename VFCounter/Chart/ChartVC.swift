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

class ChartVC: ChartBaseVC {
    
    var segmentControl: CustomSegmentControl!
    let barChartView = BarChartView()
    var chartDataModel = ChartDataModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        
        if segmentControl.selectedSegmentIndex == 0 {
            chartDataModel.veggies = Array(repeating: nil, count: 7)
            
        } else {
            chartDataModel.veggies = Array(repeating: nil, count: 31)
        }
//        insertData()
        
        //fetch data
//        let veggieCount = UInt32(chartDataModel.veggies.count)
//        setDataCount(count, range: veggieCount)
        
    }
        
//    func setDataCount(_ count: Int, range: UInt32) {
//        let start = 1
//
//        var barchartEntry: BarChartDataEntry!
//
//        let yVals = (start..<start + count).map { (i) -> BarChartDataEntry in
//
//            if let data = chartDataModel.veggies[i - 1] {
//                barchartEntry = BarChartDataEntry(x: Double(i - 1), y: Double(data.amount))
//            }
//            return barchartEntry
//         }
//
//        var set1: BarChartDataSet! = nil
//        if let set = barChartView.data?.dataSets.first as? BarChartDataSet {
//            set1 = set
//            set1.replaceEntries(yVals)
//            barChartView.data?.notifyDataChanged()
//            barChartView.notifyDataSetChanged()
//        } else {
//            set1 = BarChartDataSet(entries: yVals, label: "Veggie")
//            set1.colors = ChartColorTemplates.material()
//            set1.drawValuesEnabled = false
//
//            let data = BarChartData(dataSet: set1)
//            data.setValueFont(UIFont(name: "HelveticaNeue-Light", size: 10)!)
//            data.barWidth = 0.9
//            barChartView.data = data
//        }
//

//    }
    
   
}
