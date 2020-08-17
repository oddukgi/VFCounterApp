//
//  ChartVC+Ext.swift
//  VFCounter
//
//  Created by Sunmi on 2020/08/13.
//  Copyright © 2020 creativeSun. All rights reserved.
//

import UIKit
import Charts

extension ChartVC {
      
    func configure() {
        
        segmentControl = CustomSegmentControl(items: ["주", "월"])
        segmentControl.selectedSegmentIndex = 0
        
        let width = 200
        view.addSubview(segmentControl)
        
        segmentControl.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            make.centerX.equalTo(view.safeAreaLayoutGuide.snp.centerX)
            make.width.equalTo(width)
            make.height.equalTo(30)
        }
        
        // segmentstyle : rounded
        segmentControl.backgroudClr = .white
        segmentControl.tintClr = UIColor(white: 0, alpha: 0)
        segmentControl.selectedSegmentTintClr = ColorHex.weirdGreen

        let defaultFont = NanumSquareRound.bold.style(sizeOffset: 12)
        segmentControl.initConfiguration(font: defaultFont, color: ColorHex.lightGreyBlue)
        segmentControl.selectedConfiguration(font: defaultFont, color: .white)
        segmentControl.addTarget(self, action: #selector(changedIndexSegment), for: .valueChanged)
        
    }
    
    func configureChart() {
        view.addSubview(barChartView)
        
        barChartView.snp.makeConstraints {
            $0.top.equalTo(segmentControl.snp.bottom).offset(22)
            $0.leading.equalTo(view)
            $0.width.equalTo(view.bounds.width)
            $0.bottom.equalTo(view).offset(-221)
        }

    }

}

extension ChartVC {
    func applyChartOption() {
        self.title = "Chart"
        
        self.setup(barLineChartView: barChartView)
        barChartView.delegate = self
        barChartView.drawBarShadowEnabled = false
        barChartView.drawValueAboveBarEnabled = false
        
        let xAxis = barChartView.xAxis
        xAxis.labelPosition = .bottom
        xAxis.granularity = 1
        identifyChartSettings(xAxis)
        
        let leftAxisFormatter = NumberFormatter()
        leftAxisFormatter.minimumFractionDigits = 0
        leftAxisFormatter.maximumFractionDigits = 0
        leftAxisFormatter.positiveSuffix = " g"
        
        let leftAxis = barChartView.leftAxis
        leftAxis.labelFont = NanumSquareRound.bold.style(sizeOffset: 13)
        leftAxis.labelCount = 8
        leftAxis.labelPosition = .outsideChart
        leftAxis.spaceTop = 0.2
        leftAxis.axisMinimum = 0
       
    }
    
    func configureMarker() {
    
        let marker = BalloonMarker(color: .white,
                                   font: NanumSquareRound.bold.style(sizeOffset: 13),
                                   textColor: .white,
                                   insets: UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8))
        
             marker.chartView = barChartView
             marker.minimumSize = CGSize(width: 100, height: 70)
             barChartView.marker = marker

    }
    
    func identifyChartSettings(_ xAxis: XAxis) {
        
        let selectedIndex = segmentControl.selectedSegmentIndex
        
        switch selectedIndex {
            
        case 0:
            barChartView.maxVisibleCount = 7
            xAxis.labelFont = NanumSquareRound.bold.style(sizeOffset: 13)
            xAxis.valueFormatter = WeekDayAxisValueFormatter(chart: barChartView)
             
        default:
            barChartView.maxVisibleCount = 31
            xAxis.labelFont = NanumSquareRound.bold.style(sizeOffset: 11)
            xAxis.valueFormatter = MonthAxisValueFormatter(chart: barChartView)
            
        }
    }

}
