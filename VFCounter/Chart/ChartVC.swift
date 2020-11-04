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

    var uiconfig = ChartVC.UIConfigure()
    var dateConfigure = ChartVC.DateConfigure()
    var currentVC: UIViewController?
    var strategy: DateStrategy!
    let chartModel = ChartModel()
    let calendarController = CalendarController(mode: .single)
    private var mainListModel: MainListModel!
    
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
    
    fileprivate func setNavigationBar() {
        self.title = "데이터"
        self.navigationController?.navigationBar.barTintColor = UIColor.white
        view.backgroundColor = .systemBackground
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.currentValue = nil
        setNavigationBar()
        prepareNotificationAddObserver()
        configureDataFilterView()
        configureCalendar()
        configureSubviews()
        uiconfig.periodSegmentCtrl.setIndex(index: 0)
        uiconfig.datafilterView.dataSegmentControl.setIndex(index: 0)
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
       calendarController.isPopupVisible = false
    }

    fileprivate func configureDataFilterView() {
        uiconfig.datafilterView = DataFilterView()
        view.addSubViews(uiconfig.datafilterView)
        
        let segmentSize = SizeManager().segmentSize()
  
        uiconfig.datafilterView.snp.makeConstraints {
            $0.bottom.equalTo(view.snp.bottom).offset(-8)
            $0.centerX.equalTo(view.snp.centerX)
            $0.size.equalTo(segmentSize)
        }
        uiconfig.datafilterView.dataSegmentControl.delegate = self
    }

    fileprivate func showChildVC(_ vc: UIViewController) {
        self.addChild(vc)
        uiconfig.contentView.addSubview(vc.view)
        vc.view.frame = uiconfig.contentView.bounds
        self.currentVC = vc
        vc.didMove(toParent: self)
    }

    func viewControllerForSelectedIndex(_ index: Int) -> UIViewController? {

        var vc: UIViewController?

        switch index {
        case 0:
            
            print("Chart Date: \(dateConfigure.date)")
            strategy =  WeeklyDateStrategy(date: dateConfigure.date)
            let weeklyChartVC = WeeklyChartVC(strategy: strategy)
            weeklyChartVC.delegate = self
            vc = weeklyChartVC
            currentVC = weeklyChartVC
            
        default:
            vc = calendarController
            currentVC = vc
        }

        return vc
    }

    func displayCurrentTab(_ index: Int) {
        
        if let vc = viewControllerForSelectedIndex(index) {
            switch index {
            case 0:
                self.showChildVC(vc)
            default:
                calendarController.present(above: self, contentView: uiconfig.contentView)
                currentVC = calendarController
            }
        }
    }

    fileprivate func prepareNotificationAddObserver() {

        NotificationCenter.default.addObserver(self, selector: #selector(self.selectCalendarDate(_:)),
                                               name: .selectDateCalendar, object: nil)
    }

    fileprivate func removeNotification() {
        NotificationCenter.default.removeObserver(self, name: .selectDateCalendar, object: nil)
    }
    
    func connectDatehandler() {
        calendarController.updateMonthHandler = { value in
            guard let date = value else { return }
            self.dateConfigure.calendarDate = date
            self.calendarController.refreshCalendar(date: date)
        }
    }
    
    @objc fileprivate func selectCalendarDate(_ notification: Notification) {

        if let userDate = notification.userInfo?["selectdate"] as? Date {
            dateConfigure.calendarDate = userDate
            calendarController.refreshCalendar(date: userDate)
        }
    }
    
    func connectDateAction() {
        calendarController.doneHandler = { newDate in
            self.currentValue = newDate
        }
    }
    
    @objc func tappedAdd(_ sender: VFButton) {
        // haptic feedback with UIImpactFeedbackGenerator
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        showPickUpViewController()
    }

    fileprivate func showPickUpViewController() {
        
        let date = currentDate()
        chartModel.checkMaxValueFromDate(date: date)
        
        let kinds = SettingManager.getKindSegment(keyName: "KindOfItem") ?? ""
        
        var type = (kinds == "") ? ("야채") : kinds
        
        let model = ItemModel(date: date, type: type, config: chartModel.valueConfig)
        DispatchQueue.main.async {
            let pickItemVC = PickItemVC(delegate: self, model: model, sectionFilter: .chart)
            let navController = UINavigationController(rootViewController: pickItemVC)
            self.present(navController, animated: true)
        }
    }

    func updateView(name: String, dateTime: Date) {
        
        let periodIndex = uiconfig.periodSegmentCtrl.selectedIndex
        let dataIndex = uiconfig.datafilterView.selectedItem
        
        print("New DateTime: \(dateTime)")
        
        if periodIndex == 0 {
            dateConfigure.date = dateTime
            valueChangedPeriod(to: periodIndex)
            
        } else {
            dateConfigure.calendarDate = dateTime
            switch dataIndex {
            case 0:
                
                self.calendarController.moveToSpecificDate(date: self.dateConfigure.calendarDate)
                
            default:
                valueChangedPeriod(to: periodIndex)
            }
        }
        
        guard name.count > 0 else { return }
        displayMessage(name: name, dateTime: dateTime)
    
    }
    
    func updateViews(dateTime: Date?) {

        print("DateTime: \(dateTime)")
        let periodIndex = uiconfig.periodSegmentCtrl.selectedIndex
        let dataIndex = uiconfig.datafilterView.selectedItem
       
        if periodIndex == 0 {
            dateConfigure.date = dateTime ?? Date()
            valueChangedPeriod(to: periodIndex)
        } else {
            dateConfigure.calendarDate = dateTime ?? Date()

            if dataIndex == 0 {
                calendarController.moveToSpecificDate(date: self.dateConfigure.calendarDate)
            } else {
                valueChangedData(to: dataIndex)
            }
        }
    }
    
    func displayMessage(name: String, dateTime: Date) {
        
        let txtTime = dateTime.changeDateTime(format: .shortDT)
        let text = "\(name), \(txtTime) \n 추가완료"
        self.presentAlertVC(title: "알림", message: text, buttonTitle: "OK")
    }
    
    func switchViewWithDataFilter(for pIndex: Int) {
        let dfIndex = uiconfig.datafilterView.dataSegmentControl.selectedIndex
        if dfIndex == 0 {
            self.displayCurrentTab(pIndex)
        } else {
            self.valueChangedData(to: dfIndex)
        }
    }
    
    func displayPeriodList() {
        let periodListVC = PeriodListVC(delegate: self, strategy: strategy)
        self.showChildVC(periodListVC)
    }
    
    func publishList(_ date: String, item: Items, config: ValueConfig) {
        mainListModel = MainListModel(date: date)
        mainListModel.createEntity(item: item, config: chartModel.valueConfig)
    }

}

extension ChartVC: CustomSegmentedControlDelegate {
    
    func valueChangedPeriod(to index: Int) {
        
        switch index {
        case 0:
            removeCurrentVC()
            switchViewWithDataFilter(for: index)
        default:
            removeCurrentVC()
            switchViewWithDataFilter(for: index)
        }
    }

    func valueChangedData(to index: Int) {

        switch index {
        case 0 :
            removeCurrentVC()
            // Chart
            self.displayCurrentTab(uiconfig.periodSegmentCtrl.selectedIndex)

        default:
            
            // List
            removeCurrentVC()
            if uiconfig.periodSegmentCtrl.selectedIndex == 0 {
                strategy = WeeklyDateStrategy(date: dateConfigure.date)
            } else {
               
                print("Date Configure: \(dateConfigure.calendarDate)")
                if dateConfigure.calendarDate > dateConfigure.date {  dateConfigure.calendarDate = Date() }
                strategy = MonthlyDateStrategy(date: dateConfigure.calendarDate)
           }
    
            displayPeriodList()
        }
    }
}

extension ChartVC {
    
    struct DateConfigure {
        var calendarDate = Date()
        var date = Date()
        var indexPeriod: Int = 0
        var indexData: Int = 0
        
    }
    struct UIConfigure {
        
        let contentView     = UIView()
        let weeklyChartView = UIView()
        var monthlyChartView: UIView!
        var periodSegmentCtrl: CustomSegmentedControl!
        var datafilterView: DataFilterView!

        lazy var btnAdd: VFButton = {
            let button = VFButton()
            button.addImage(imageName: "add")
            return button
        }()
    
    }
}
