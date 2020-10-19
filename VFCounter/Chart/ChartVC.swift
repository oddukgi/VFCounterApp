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
    private var dateConfigure = ChartVC.DateConfigure()
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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Chart"
        self.navigationController?.navigationBar.barTintColor = UIColor.white
        view.backgroundColor = .systemBackground
        
        self.currentValue = nil
        prepareNotificationAddObserver()
        configureDataFilterView()
        configure()
       
        displayCurrentTab(0)
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

        default:
            calendarController.view.isHidden = false
            configureCalendar()
            calendarController.present(above: self, contentView: contentView)
        }

        return vc
    }

    func displayCurrentTab(_ index: Int) {
        if let vc = viewControllerForSelectedIndex(index) {
            showChildVC(vc)
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
        let dataManager = DataManager()
        let defaultV = Int(SettingManager.getTaskValue(keyName: "VeggieTaskRate") ?? 0)
        let defaultF = Int(SettingManager.getTaskValue(keyName: "FruitTaskRate") ?? 0)

        let maxValues = datamanager.getMaxData(date: date)
        let maxVeggie = (maxValues.0 == 0) ? defaultV : maxValues.0
        let maxFruit = (maxValues.1 == 0) ? defaultF : maxValues.1

        valueConfig.maxVeggies = maxVeggie
        valueConfig.maxFruits = maxFruit
    }

    fileprivate func showPickUpViewController(tag: Int) {

        let datetime = dateConfigure.date.changeDateTime(format: .date)

        checkMaxValueFromDate(date: datetime)
        let datemodel = DateModel(date: datetime, tag: tag, sumV: valueConfig.sumVeggies,
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
          
            change(to: periodIndex)
        } else {
            dateConfigure.calendarDate = dateTime
            if dataIndex == 0 {
                calendarController.moveToSpecificDate(date: dateConfigure.calendarDate)
            } else {
                change(to: periodIndex)
            }
        }
        
//        SettingManager.setDataSegmentCtrl(index: dataIndex)
//        SettingManager.setPeriodSegmentCtrl(index: periodIndex)
         
        displayMessage(name: name, dateTime: dateTime)
//        print("ChartVC Date: \(dateConfigure.date),\(dateConfigure.calendarDate)")
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
    func change(to index: Int) {

        if datafilterView.dataSegmentControl.selectedIndex == 0 {
            removeCurrentVC()

            DispatchQueue.main.async {
                self.displayCurrentTab(index)
            }
        } else {
            removeCurrentVC()
            DispatchQueue.main.async {
                self.valueChangedIndex(to: self.datafilterView.dataSegmentControl.selectedIndex)
            }
        }
    }

    // datafilter
    func valueChangedIndex(to index: Int) {

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
                self.dateStrategy = MonthlyDateStrategy(date: dateConfigure.date)
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
}
