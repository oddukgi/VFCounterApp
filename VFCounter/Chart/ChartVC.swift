//
//  ChartVC.swift
//  VFCounter
//
//  Created by Sunmi on 2020/07/21.
//  Copyright © 2020 creativeSun. All rights reserved.
//

import UIKit
import SnapKit
import CoreStore

class ChartVC: UIViewController {

    var periodSegmentCtrl: CustomSegmentedControl!
    var datafilterView: DataFilterView!

    let contentView     = UIView()
    let weeklyChartView = UIView()
    var monthlyChartView: UIView!

    lazy var btnAdd: VFButton = {
        let button = VFButton()
        button.addImage(imageName: "add")
        return button
    }()

    private var weeklyChartVC: WeeklyChartVC?
    private let calendarController = CalendarController(mode: .single)
    private var valueConfig = ValueConfig()
    private var currentVC: UIViewController?
    private let datamanager = DataManager()
    var dateConfigure = ChartVC.DateConfigure()
    private var dateStrategy: DateStrategy!
    private var currentValue: CalendarValue? {
        didSet {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy.MM.dd"
            formatter.locale = Locale(identifier: "ko_KR")

        }
    }

    deinit {
        removeNotification()
    }
    
    static var firstLoading: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Chart"
        self.navigationController?.navigationBar.barTintColor = UIColor.white
        view.backgroundColor = .systemBackground
        
        self.currentValue = nil
        prepareNotificationAddObserver()
        configureDataFilterView()
        configure()
        valueChangedPeriod(to: 0)

    }
    
    func removeCurrentVC() {
        self.currentVC?.view.removeFromSuperview()
        self.currentVC?.removeFromParent()
    }

    private func configureCalendar() {
        calendarController.initialValue = self.currentValue as? Date
        calendarController.minimumDate = Date().getFirstMonthDate()
        calendarController.maximumDate = Date()
        calendarController.isRingVisible = true
    }

    fileprivate func configureDataFilterView() {
        datafilterView = DataFilterView()
        view.addSubViews(datafilterView)
        datafilterView.snp.makeConstraints {
            $0.bottom.equalTo(view.snp.bottom).offset(-8)
            $0.centerX.equalTo(view.snp.centerX)
            $0.size.equalTo(CGSize(width: 200, height: 40))
        }
        datafilterView.dataSegmentControl.delegate = self
    }

    fileprivate func showChildVC(_ vc: UIViewController) {
        self.addChild(vc)
        self.contentView.addSubview(vc.view)
        vc.view.frame = self.contentView.bounds
        self.currentVC = vc
        vc.didMove(toParent: self)
    }

    func viewControllerForSelectedIndex(_ index: Int) -> UIViewController? {

        var vc: UIViewController?

        switch index {
        case 0:
            calendarController.view.isHidden = true
            dateStrategy =  WeeklyDateStrategy(date: dateConfigure.date)
            let weeklyChartVC = WeeklyChartVC(dateStrategy: dateStrategy)
            vc = weeklyChartVC
            weeklyChartVC.delegate = self

        default:
            calendarController.view.isHidden = false
            configureCalendar()
            calendarController.present(above: self, contentView: contentView)
        }

        return vc
    }

    func displayCurrentTab(_ index: Int) {
        if let vc = viewControllerForSelectedIndex(index) {
            self.showChildVC(vc)
        }
    }

    fileprivate func prepareNotificationAddObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateCalendarDate(_:)),
                                               name: .updateMonth, object: nil)
    }

    fileprivate func removeNotification() {
        NotificationCenter.default.removeObserver(self, name: .updateMonth, object: nil)
    }
    // MARK: action
    @objc fileprivate func updateCalendarDate(_ notification: Notification) {
        if let userDate = notification.userInfo?["usermonth"] as? Date {
            dateConfigure.calendarDate = userDate
        }
    }

    @objc func tappedAdd(_ sender: VFButton) {
        showPickUpViewController(tag: 0)
    }

    fileprivate func checkMaxValueFromDate(date: String) {
        let defaultV = Int(SettingManager.getTaskValue(keyName: "VeggieTaskRate") ?? 0)
        let defaultF = Int(SettingManager.getTaskValue(keyName: "FruitTaskRate") ?? 0)

        let maxValues = datamanager.getMaxData(date: date)
        let maxVeggie = (maxValues.0 == 0) ? defaultV : maxValues.0
        let maxFruit = (maxValues.1 == 0) ? defaultF : maxValues.1

        valueConfig.maxVeggies = maxVeggie
        valueConfig.maxFruits = maxFruit
    }

    fileprivate func showPickUpViewController(tag: Int) {
        
        let date = getCurrentDate()
        checkMaxValueFromDate(date: date)
        let datemodel = DateModel(date: date, tag: tag, sumV: valueConfig.sumVeggies,
                                  sumF: valueConfig.sumFruits, maxV: valueConfig.maxVeggies,
                                  maxF: valueConfig.maxFruits)
        DispatchQueue.main.async {
            let itemPickVC = PickItemVC(delegate: self, datemodel: datemodel, sectionFilter: .chart)
            let navController = UINavigationController(rootViewController: itemPickVC)
            self.present(navController, animated: true)
        }
    }

    fileprivate func updateView(name: String, dateTime: Date) {
        
        let periodIndex = periodSegmentCtrl.selectedIndex
        let dataIndex = datafilterView.selectedItem
      
        if periodIndex == 0 {
            dateConfigure.date = dateTime
          
            valueChangedPeriod(to: periodIndex)
        } else {
            dateConfigure.calendarDate = dateTime
            if dataIndex == 0 {
                
                DispatchQueue.main.async {
                    self.calendarController.moveToSpecificDate(date: self.dateConfigure.calendarDate)
                }
            } else {
                valueChangedPeriod(to: periodIndex)
            }
        }
        displayMessage(name: name, dateTime: dateTime)
    }
    
    func displayMessage(name: String, dateTime: Date) {
        
        let txtTime = dateTime.changeDateTime(format: .shortDT)
        DispatchQueue.main.async {
            let text = "\(name), \(txtTime) \n 추가완료"
            self.presentAlertVC(title: "알림", message: text, buttonTitle: "OK")
        }
    }

}

extension ChartVC: CustomSegmentedControlDelegate {
    
    func valueChangedPeriod(to index: Int) {
        
        var dataIndex = datafilterView.dataSegmentControl.selectedIndex
        if dataIndex == 0 {
            removeCurrentVC()
            self.displayCurrentTab(index)
        } else {
            removeCurrentVC()
            self.valueChangedData(to: self.datafilterView.dataSegmentControl.selectedIndex)
        }
    }

    func valueChangedData(to index: Int) {

        switch index {
        case 0 :
            removeCurrentVC()
            self.displayCurrentTab(self.periodSegmentCtrl.selectedIndex)

        default:
            removeCurrentVC()
            if self.periodSegmentCtrl.selectedIndex == 0 {
                self.dateStrategy = WeeklyDateStrategy(date: dateConfigure.date)
            } else {
                
                if dateConfigure.calendarDate > dateConfigure.date {  dateConfigure.calendarDate = Date() }
                self.dateStrategy = MonthlyDateStrategy(date: dateConfigure.calendarDate)
           }
            
            self.showChildVC(PeriodListVC(dateStrategy: self.dateStrategy))
        }
    
    }
}

extension ChartVC: PickItemVCProtocol {
    func addItems(item: VFItemController.Items, tag: Int) {

        if !item.name.isEmpty {
            let stringDate = String(item.date.split(separator: " ").first!)
            checkMaxValueFromDate(date: stringDate)
            datamanager.createEntity(item: item, tag: tag, valueConfig: valueConfig)

            NotificationCenter.default.post(name: .updateDateTime,
                                            object: nil, userInfo: ["userdate": stringDate])
            updateView(name: item.name, dateTime: item.entityDT!)
        }
    }

    func updateItems(item: VFItemController.Items, time: Date?, tag: Int) {

    }

}

extension ChartVC {
    struct DateConfigure {
        var calendarDate = Date()
        var date = Date()
        var indexPeriod: Int = 0
        var indexData: Int = 0
        
    }
    
    // synchronize date with current view
    func getCurrentDate() -> String {
        
        // segment control 인덱스 가져오기 (0:주, 1:월) / (0: 데이터, 1:리스트)
        let periodIndex = periodSegmentCtrl.selectedIndex
      
        switch periodIndex {
        case 0:
            let date = dateConfigure.date.changeDateTime(format: .date)
            return date
            
        default:
            return dateConfigure.calendarDate.changeDateTime(format: .date)
        }
        
        return ""
        
    }

}

extension ChartVC: WeeklyChartDelegate {
    
    func sendChartDate(date: Date) {
        dateConfigure.date = date
    }
}
