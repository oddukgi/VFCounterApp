//
//  WeeklyChartVC+Ext.swift
//  VFCounter
//
//  Created by Sunmi on 2020/08/27.
//  Copyright © 2020 creativeSun. All rights reserved.
//

import UIKit
import Charts

extension WeeklyChartVC {
    
    func configureChart() {
        view.addSubview(chartView)
        
        let height = SizeManager().chartHeight
        print("Size: \(view.bounds.width) \(view.bounds.height)")
        chartView.snp.makeConstraints { make in
            make.top.equalTo(weekStackView.snp.bottom).offset(10)
            make.width.equalTo(view.bounds.width)
            make.height.equalTo(height)
        }

    }
    
    func applyChartOption() {
           
        self.setup(barLineChartView: chartView)
        chartView.delegate = self
        chartView.drawBarShadowEnabled = false
        chartView.drawValueAboveBarEnabled = false
        chartView.maxVisibleCount = 7
      
        let xAxis = chartView.xAxis
        xAxis.labelPosition = .bottom
        xAxis.centerAxisLabelsEnabled = true
        xAxis.labelFont = NanumSquareRound.regular.style(sizeOffset: 12)
        xAxis.valueFormatter = WeekDayAxisValueFormatter(weekdays: [ "월","화","수","목","금","토","일" ])
        xAxis.axisMinimum = 0
        xAxis.axisMaximum = 7
        xAxis.drawAxisLineEnabled = true
        xAxis.drawGridLinesEnabled = true
        chartView.rightAxis.enabled = false
        
        let leftAxisFormatter = NumberFormatter()
        leftAxisFormatter.minimumFractionDigits = 0
        leftAxisFormatter.maximumFractionDigits = 0
        leftAxisFormatter.positiveSuffix = " g"
        
        let leftAxis = chartView.leftAxis
        
        leftAxis.drawAxisLineEnabled = true
        leftAxis.drawGridLinesEnabled = true
        leftAxis.labelFont = Seoulnamsan.medium.style(offset: 13)
        leftAxis.labelCount = 8
        leftAxis.labelPosition = .outsideChart
        leftAxis.spaceTop = 0.2
        leftAxis.axisMinimum = 0
        
        
        let l = chartView.legend
        l.horizontalAlignment = .right
        l.verticalAlignment = .top
        l.orientation = .horizontal
        l.drawInside = false
        l.form = .circle
        l.font = Seoulnamsan.light.style(offset: 9)
        
        l.yOffset = 5
        l.xEntrySpace = 5
        l.yEntrySpace = 8
    }
    
    func configureMarker() {
        
        let marker = BalloonMarker(color: ColorHex.iceBlue,
                                   font: NanumSquareRound.bold.style(sizeOffset: 14),
                                   textColor: .black,
                                   insets: UIEdgeInsets(top: 8, left: 8, bottom: 20, right: 8))
        
        marker.chartView = chartView
        marker.minimumSize = CGSize(width: 70, height: 40)
        chartView.marker = marker
    }
}
