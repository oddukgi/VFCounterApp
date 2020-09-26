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
 
    private var dateStrategy: DateStrategy!
    private var veggieChartDataSet: BarChartDataSet!
    private var fruitChartDataSet: BarChartDataSet!
    private let dataManager = DataManager()
    private var weekday = Array<String>()

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
    
    
 
    init(dateStrategy: DateStrategy) {
        self.dateStrategy = dateStrategy
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
        updatePeriod()
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
    
    
    func updatePeriod() {
        dateStrategy.setDateRange()
        let data = dateStrategy.updateLabel()
        lblweek.text = data.0
  
        let datamap = data.2!
        
        
        if veggieChartDataSet != nil {
            veggieChartDataSet.removeAll()
        }
        
        if fruitChartDataSet != nil {
            fruitChartDataSet.removeAll()
        }

   	    updateChartData(count: 1, date: datamap[0])

        for i in 1...6 {
             self.updateChartData(date: datamap[i])
         }      
    }
    
    func connectAction() {
        
        arrowButtons[0].addTargetClosure { _ in
            self.dateStrategy.previous()
            self.updatePeriod()

        }
        arrowButtons[1].addTargetClosure { _ in
            self.dateStrategy.next()
            self.updatePeriod()
        }
    }

    func updateChartData(count: Int = 7, date: String) {
        let customDate = date.components(separatedBy: " ")
        dataManager.getSumItems(date: customDate[0]) { (veggieSum, fruitSum) in
            self.setDataCount(count: count, sumVeggie : veggieSum, sumFruit: fruitSum, day: customDate[1])
        }
    }
    
    func singleData(sumVeggie: Int16, sumFruit: Int16, day: String) -> [BarChartDataSet] {
        
        let index = day.getWeekdayIndex()
        veggieChartDataSet = BarChartDataSet(entries: [BarChartDataEntry(x: Double(index),
                                                                         y: Double(sumVeggie))], label: "야채")
        
        fruitChartDataSet = BarChartDataSet(entries: [BarChartDataEntry(x: Double(index),
                                                                        y: Double(sumFruit))], label: "과일")
        return [veggieChartDataSet, fruitChartDataSet]
        
    }
    
    func multipleData(sumVeggie : Int16, sumFruit: Int16, day: String) -> [BarChartDataSet] {
        
        let index = day.getWeekdayIndex()

        veggieChartDataSet.append(BarChartDataEntry(x: Double(index), y: Double(sumVeggie)))
        fruitChartDataSet.append(BarChartDataEntry(x: Double(index), y: Double(sumFruit)))

        return  [veggieChartDataSet, fruitChartDataSet]
    }

    // update value
    func setDataCount(count: Int = 7, sumVeggie : Int16, sumFruit: Int16, day: String) {
              
        let groupSpace = 0.3
        let barSpace = 0.05
        let barWidth = 0.3
        var chartDataArray = [BarChartDataSet]()
      
        if count == 1 {
            chartDataArray = singleData(sumVeggie: sumVeggie, sumFruit: sumFruit, day: day)
        } else {
            chartDataArray = multipleData(sumVeggie: sumVeggie, sumFruit: sumFruit, day: day)
        }
 
        chartDataArray[0].setColor(ChartColor.veggieGreen)
        chartDataArray[0].drawValuesEnabled = false

        chartDataArray[1].setColor(ChartColor.fruitYellow)
        chartDataArray[1].drawValuesEnabled = false
        
        let chartData = BarChartData(dataSets: [chartDataArray[0], chartDataArray[1]])
        
        chartData.setValueFont(.systemFont(ofSize: 10, weight: .light))
        chartData.barWidth = barWidth
        chartData.groupBars(fromX: 0, groupSpace: groupSpace, barSpace: barSpace)
   
        chartView.data = chartData
    }

}

