//
//  ChartBaseVC.swift
//  VFCounter
//
//  Created by Sunmi on 2020/08/13.
//  Copyright © 2020 creativeSun. All rights reserved.
//

#if canImport(UIKit)
    import UIKit
#endif

import Charts

class ChartBaseVC: UIViewController, ChartViewDelegate {

    var shouldHideData: Bool = false
    var strategy: DateStrategy!
    private var model: PeriodListModel!
    
    var pModel: PeriodListModel {
        return model
    }
    
    init(strategy: DateStrategy) {
        self.strategy = strategy
        model = PeriodListModel(strategy: strategy, kind: .chart)
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initialize()
    }

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.initialize()
    }

    private func initialize() {
        self.edgesForExtendedLayout = []

    }

    func updateChartData() {
        fatalError("updateChartData not overridden")
    }

    func setup(pieChartView chartView: PieChartView) {
        chartView.usePercentValuesEnabled = true
        chartView.drawSlicesUnderHoleEnabled = false
        chartView.holeRadiusPercent = 0.58
        chartView.transparentCircleRadiusPercent = 0.61
        chartView.chartDescription?.enabled = false
        chartView.setExtraOffsets(left: 5, top: 10, right: 5, bottom: 5)

        chartView.drawCenterTextEnabled = true

        let paragraphStyle = NSParagraphStyle.default.mutableCopy() as? NSMutableParagraphStyle ??  NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = .byTruncatingTail
        paragraphStyle.alignment = .center

        let centerText = NSMutableAttributedString(string: "Charts\nby Daniel Cohen Gindi")
        centerText.setAttributes([.font: UIFont(name: "HelveticaNeue-Light", size: 13)!,
                                  .paragraphStyle: paragraphStyle], range: NSRange(location: 0, length: centerText.length))
        centerText.addAttributes([.font: UIFont(name: "HelveticaNeue-Light", size: 11)!,
                                  .foregroundColor: UIColor.gray], range: NSRange(location: 10, length: centerText.length - 10))
        centerText.addAttributes([.font: UIFont(name: "HelveticaNeue-Light", size: 11)!,
                                  .foregroundColor: UIColor(red: 51/255, green: 181/255, blue: 229/255, alpha: 1)], range: NSRange(location: centerText.length - 19, length: 19))
        chartView.centerAttributedText = centerText

        chartView.drawHoleEnabled = true
        chartView.rotationAngle = 0
        chartView.rotationEnabled = true
        chartView.highlightPerTapEnabled = false

        let l = chartView.legend
        l.horizontalAlignment = .right
        l.verticalAlignment = .top
        l.orientation = .vertical
        l.drawInside = true
        l.xEntrySpace = 7
        l.yEntrySpace = 0
        l.yOffset = 0
    }

    func setup(radarChartView chartView: RadarChartView) {
        chartView.chartDescription?.enabled = false
    }

    func setup(barLineChartView chartView: BarLineChartViewBase) {
        chartView.chartDescription?.enabled = false
        chartView.dragEnabled = false
        chartView.setScaleEnabled(false)
        chartView.pinchZoomEnabled = false

        let xAxis = chartView.xAxis
        xAxis.labelPosition = .bottom
        chartView.rightAxis.enabled = false
    }

    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        NSLog("chartValueSelected")

        if entry.y == 0.0 {
            chartView.highlightValue(nil, callDelegate: false)
        }
    }

    func chartValueNothingSelected(_ chartView: ChartViewBase) {
        NSLog("chartValueNothingSelected")
    }

    func chartScaled(_ chartView: ChartViewBase, scaleX: CGFloat, scaleY: CGFloat) {

    }

    func chartTranslated(_ chartView: ChartViewBase, dX: CGFloat, dY: CGFloat) {

    }

    func updatePeriod() {
        strategy.fetchedData()
        strategy.setMinimumDate()
        strategy.setMaximumDate()
    }
}
