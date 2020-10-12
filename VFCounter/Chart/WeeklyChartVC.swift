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

    let lblweek = VFTitleLabel(textAlignment: .center, fontSize: 14)
    let chartView = BarChartView()

    private let dataManager = DataManager()
    private var weekday = [String]()

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
        stackView.spacing = 105
        stackView.axis = .horizontal
        stackView.distribution = .fill
        return stackView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        configure()
        connectAction()
        configureChart()
        applyChartOption()
        configureMarker()

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.updatePeriod()
        self.changeLabelText()
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
            make.width.equalTo(105)
        }

        lblweek.font = Seoulnamsan.medium.style(offset: 20)
    }

    private func changeLabelText() {
        let data = dateStrategy.updateLabel()
        lblweek.text = data.0
        let datamap = data.2!
        setDataCount(datemap: datamap)
    }

    func connectAction() {

        arrowButtons[0].addTargetClosure { _ in
            self.updatePeriod()
            self.dateStrategy.previous()
            self.changeLabelText()
        }
        arrowButtons[1].addTargetClosure { _ in
            self.updatePeriod()
            self.dateStrategy.next()
            self.changeLabelText()
        }
    }

    func setDataCount(datemap: [String]) {
        let groupSpace = 0.3
        let barSpace = 0.05
        let barWidth = 0.3

        var veggieChartEntry: [BarChartDataEntry] = []
        var fruitChartEntry: [BarChartDataEntry] = []

        for (index, item) in datemap.enumerated() {

            let customDate = item.components(separatedBy: " ").first!
            let values = dataManager.getSumItems(date: customDate)

            let item1 = BarChartDataEntry(x: Double(index), y: Double(values.0))
            let item2 = BarChartDataEntry(x: Double(index), y: Double(values.1))

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

        // specify the width each bar should have
        data.barWidth = barWidth
        data.groupBars(fromX: Double(0), groupSpace: groupSpace, barSpace: barSpace)

        chartView.data = data

    }
}
