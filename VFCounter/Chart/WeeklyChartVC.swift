//
//  WeeklyChartVC.swift
//  VFCounter
//
//  Created by Sunmi on 2020/08/25.
//  Copyright © 2020 creativeSun. All rights reserved.
//

import UIKit
import Charts

class WeeklyChartVC: ChartBaseVC {

    let lblweek = VFTitleLabel(textAlignment: .center, font: .systemFont(ofSize: SizeManager().dateViewFontSize))
    let chartView = BarChartView()

    private let dataManager = DataManager()
    private var weekday = [String]()    
    weak var delegate: UpdateDateDelegate?
    
    lazy var arrowButtons: [UIButton] = {
        var buttons = [UIButton]()
        var img = ["chartL", "chartR"]
        (0 ..< 2).forEach { index in

            let button = UIButton()
            button.setImage(UIImage(named: img[index]), for: .normal)
            buttons.append(button)
        }
        return buttons
    }()

    lazy var weekStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 130
        stackView.axis = .horizontal
        stackView.distribution = .fill
        return stackView
    }()
    
    var date: Date? {
        didSet {
            if let newDate = date {
                strategy.date = newDate
                updatePeriod()
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        configure()
        connectAction()
        configureChart()
        applyChartOption()
        connectHandler()
        configureMarker()
        model.loadChart()
        self.updatePeriod()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        model.removeobserver()
    }
    
    private func configure() {
        view.addSubViews(weekStackView, lblweek)
        arrowButtons.forEach {
            weekStackView.addArrangedSubview($0)
        }

        weekStackView.snp.makeConstraints { make in
            make.top.equalTo(view).offset(7)
            make.centerX.equalTo(view.snp.centerX)
            make.height.equalTo(32)
        }

        lblweek.snp.makeConstraints { make in
            make.leading.equalTo(arrowButtons[0].snp.trailing)
            make.centerY.equalTo(weekStackView.snp.centerY)
            make.width.equalTo(130)
        }
        changedWeekLabel(period: strategy.period)
    }

    func changedWeekLabel(period: String) {
        lblweek.text = period
    }
    
    func displayData() {
        let datemap = strategy.strDateMap
        setDataCount(datemap: datemap)
    }
    func connectAction() {

        arrowButtons[0].addTargetClosure { _ in
            self.updatePeriod()
            self.strategy.previous()
            self.changedWeekLabel(period: self.strategy.period)
        }
        arrowButtons[1].addTargetClosure { _ in
            self.updatePeriod()
            self.strategy.next()
            self.changedWeekLabel(period: self.strategy.period)
        }
    }
    
    func connectHandler() {
        model.refreshChartHandler = { h_refresh in
            self.displayData()
        }
    }

    func setDataCount(datemap: [String]) {
        let groupSpace = 0.3
        let barSpace = 0.05
        let barWidth = 0.3

        var veggieChartEntry: [BarChartDataEntry] = []
        var fruitChartEntry: [BarChartDataEntry] = []
        let type = ["야채", "과일"]
        
        for (index, item) in datemap.enumerated() {

            let customDate = item.extractDate
            let sum = model.getSumItems(date: customDate)
            let item1 = BarChartDataEntry(x: Double(index), y: Double(sum.0))
            let item2 = BarChartDataEntry(x: Double(index), y: Double(sum.1))

            veggieChartEntry.append(item1)
            fruitChartEntry.append(item2)
        }

        var veggieChartDataSet: BarChartDataSet! = nil
        var fruitChartDataSet: BarChartDataSet! = nil

        let set1 = BarChartDataSet(entries: veggieChartEntry, label: "야채")
        set1.setColor(ChartColor.veggieGreen)
        set1.drawValuesEnabled = false

        let set2 = BarChartDataSet(entries: fruitChartEntry, label: "과일")
        set2.setColor(ChartColor.fruitYellow)
        set2.drawValuesEnabled = false

        let data = BarChartData(dataSets: [set1, set2])
        data.setValueFont(.systemFont(ofSize: 10, weight: .light))
        data.setValueFormatter(ValueFormatter())
        data.barWidth = barWidth
        data.groupBars(fromX: Double(0), groupSpace: groupSpace, barSpace: barSpace)

        chartView.data = data

    }
}
