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
  
    var date: String?
    let lblweek = VFTitleLabel(textAlignment: .center, fontSize: 14)
    let chartView = BarChartView()
 
    private var aDayWeek: Date?
    private var setting: DateSettings.WeeklyChartController
    private var veggieBarChart = [BarChartDataEntry]()
    private var fruitBarChart = [BarChartDataEntry]()

    let dataManager = DataManager()

    lazy var arrowButtons: [UIButton] = {
        var buttons = [UIButton]()
        var img = ["chartL", "chartR"]
        (0 ..< 2).forEach { index in
            
            let button = UIButton()
            button.setImage(UIImage(named: img[index]), for: .normal)
            button.contentMode = .scaleAspectFit
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
    
 
    init(setting: DateSettings.WeeklyChartController) {
        self.setting = setting
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
        getCurrentWeek()
    }
    
    func configure() {
        view.addSubViews(weekStackView,lblweek)
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
    
    func getCurrentWeek() {
        
        if DateSettings.default.weekChartCtrl.startDate == nil {
            aDayWeek = setting.startDate?.getStartOfWeek()
        } else {
            aDayWeek = DateSettings.default.weekChartCtrl.startDate
        }
        changeDate()
    }
    
    func connectAction() {
        arrowButtons[0].addTargetClosure { _ in
            self.aDayWeek = self.aDayWeek?.aDayInLastWeek.getStartOfWeek()
            DateSettings.default.listCtrl.startDate = self.aDayWeek
            self.changeDate()
        }
        arrowButtons[1].addTargetClosure { _ in
            self.aDayWeek = self.aDayWeek?.aDayInNextWeek.getStartOfWeek()
            self.changeDate()
        }
    }

    func changeDate() {
        
        if !veggieBarChart.isEmpty {
            veggieBarChart.removeAll()
        }
        
        if !fruitBarChart.isEmpty {
            fruitBarChart.removeAll()
        }
        
        DateProvider.updateDateMap(date: self.aDayWeek!, period: .weekly) {  [weak self] (datemap) in
            self?.updateWeekLabel(startDate: datemap.first!, endDate: datemap.last!)
            datemap.forEach { item in
                self?.updateChartData(date: item)
            }
        }
    }
    
    func updateWeekLabel(startDate: String, endDate: String) {
        let startDateArray = startDate.components(separatedBy: [".", " "])
        let endDateArray = endDate.components(separatedBy: ["."," "])

        let firstMonth = startDateArray[1]
        let secondMonth = endDateArray[1]

        if firstMonth == secondMonth {
            let value = "\(firstMonth).\(startDateArray[2]) ~ \(endDateArray[2])"
            lblweek.text = value
        } else {
            let value = "\(firstMonth).\(startDateArray[2]) ~ \(secondMonth).\(endDateArray[2])"
            lblweek.text = value
        }
    }
    
    func updateChartData(date: String) {

        let dateArray = date.components(separatedBy: [" "])
        dataManager.getSumItems(date: dateArray.first!) { (veggieSum, fruitSum) in
            self.setDataCount(sumVeggie : veggieSum, sumFruit: fruitSum, day: dateArray.last!)
        }
    }
    
    // update value
    func setDataCount(count: Int = 7, sumVeggie : Int16, sumFruit: Int16, day: String) {
              
        let groupSpace = 0.3
        let barSpace = 0.05
        let barWidth = 0.3
        
        let index = day.getWeekdayIndex()
        let valueA = BarChartDataEntry(x: Double(index), y: Double(sumVeggie))
        veggieBarChart.append(valueA)
    
        let valueB = BarChartDataEntry(x: Double(index), y: Double(sumFruit))
        fruitBarChart.append(valueB)
     
        var veggie: BarChartDataSet! = nil
        veggie = BarChartDataSet(entries: veggieBarChart, label: "야채")
        veggie.setColor(ChartColor.veggieGreen)
        veggie.drawValuesEnabled = false

        var fruit: BarChartDataSet! = nil
        fruit = BarChartDataSet(entries: fruitBarChart, label: "과일")
        fruit.setColor(ChartColor.fruitYellow)
        fruit.drawValuesEnabled = false
        
        let data = BarChartData(dataSets: [veggie, fruit])
        data.setValueFont(.systemFont(ofSize: 10, weight: .light))
        data.barWidth = barWidth
        data.groupBars(fromX: 0, groupSpace: groupSpace, barSpace: barSpace)
   
        chartView.data = data
    }
}


extension WeeklyChartVC {
    struct WeekChartController {
        var startDate: Date?
    }
}
