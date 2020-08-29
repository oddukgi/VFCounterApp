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
    let lblweek = VFTitleLabel(textAlignment: .center, fontSize: 15)
    let chartView = BarChartView()
 
    private var aDayWeek: Date?
    private var veggieBarChart = [BarChartDataEntry]()
    private var fruitBarChart = [BarChartDataEntry]()

    let dataManager = DataManager()

    lazy var arrowButtons: [VFButton] = {
        var buttons = [VFButton]()
        var img = ["chartL", "chartR"]
        for i in 0..<2 {
            let button = VFButton()
            button.addImage(imageName: img[i])
            button.contentMode = .scaleAspectFit
            buttons.append(button)
        }
        return buttons
    }()
    
    
    lazy var weekStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 150
        stackView.axis = .horizontal
        stackView.distribution = .fill
        return stackView
    }()
    
 
    init(date: String) {
        super.init(nibName: nil, bundle: nil)
        self.date = date
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
        getCurrentWeek()
    }
    
    func configure() {
      
        view.addSubViews(weekStackView,lblweek)
        arrowButtons[0].snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 32, height: 40))
        }
       
        arrowButtons[1].snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 32, height: 40))
        }
 
        weekStackView.addArrangedSubview(arrowButtons[0])
        weekStackView.addArrangedSubview(arrowButtons[1])
        
        weekStackView.snp.makeConstraints { make in
            make.top.equalTo(view).offset(5)
            make.centerX.equalTo(view.snp.centerX)
            make.height.equalTo(40)
        }
        
        // 80 X 28
        lblweek.snp.makeConstraints { make in
            make.leading.equalTo(arrowButtons[0].snp.trailing)
            make.centerY.equalTo(weekStackView.snp.centerY)
            make.width.equalTo(150)
        }
//        arrowButtons[0].layer.borderWidth = 1
//        arrowButtons[1].layer.borderWidth = 1
//        lblweek.layer.borderWidth = 1
        
        lblweek.font = Seoulnamsan.medium.style(offset: 20)
    }
    
    func getCurrentWeek() {
        let newDate = date?.changeTextToDate(format: "yyyy.MM.dd")
        let startWeekDate = newDate?.getStartOfWeek()
        aDayWeek = startWeekDate
        changeDate()
        
    }
    
    func connectAction() {
        arrowButtons[0].addTargetClosure { _ in
            self.aDayWeek = self.aDayWeek?.aDayInLastWeek.getStartOfWeek()
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
        
        DateProvider.updateDateMap(date: self.aDayWeek!) {  [weak self] (datemap) in
            
//            print(datemap)
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
//            print("\(veggieSum) \(fruitSum)")
            
            DispatchQueue.main.async {
                self.setDataCount(sumVeggie : veggieSum, sumFruit: fruitSum, day: dateArray.last!)
            }
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



