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
    let contentView     = UIView()
    let calendarController = CalendarController(mode: .single)
    private var mainListModel: MainListModel?
    
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
        connectMonthHandler()
        connectCurrendDateHandler()
        uiconfig.periodSegmentCtrl.setIndex(index: 0)
        uiconfig.datafilterView.dataSegmentControl.setIndex(index: 0)
    }
    
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        mainListModel?.removeobserver()
//    }
    
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
       
        contentView.addSubview(vc.view)
        vc.view.frame = contentView.bounds
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
                calendarController.present(above: self, contentView: contentView)
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
    
    func connectMonthHandler() {
        calendarController.updateMonthHandler = { value in
            guard let date = value else { return }
            self.dateConfigure.calendarDate = date
            self.calendarController.moveToSpecificDate(date: self.dateConfigure.calendarDate)
           
        }
    }
    
    func connectCurrendDateHandler() {
        calendarController.sendCurrentDateHandler = { date in
            guard let date = date else { return }
            self.dateConfigure.calendarDate = date
            print("curent date: \(date)")
        }
    }
    
    @objc fileprivate func selectCalendarDate(_ notification: Notification) {

        if let userDate = notification.userInfo?["selectdate"] as? Date {
            dateConfigure.calendarDate = userDate
            calendarController.refreshCalendar(date: userDate)
        }
    }
    
    @objc func tappedAdd(_ sender: VFButton) {
        // haptic feedback with UIImpactFeedbackGenerator
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        showPickUpViewController()
    }

    fileprivate func showPickUpViewController() {
        
        let kinds = SettingManager.getKindSegment(keyName: "KindOfItem") ?? ""
        
        var type = (kinds == "") ? ("야채") : kinds
        
        let arrDate = updateMinMaxDate()
        let date = arrDate[0].changeDateTime(format: .longDate).extractDate

        let model = ItemModel(date: date, type: type, config: chartModel.valueConfig,
                              minDate: arrDate[0], maxDate: arrDate[1])
        DispatchQueue.main.async {
            let pickItemVC = PickItemVC(delegate: self, model: model, sectionFilter: .chart)
    
            let navController = UINavigationController(rootViewController: pickItemVC)
            self.present(navController, animated: true)
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
        let periodListVC = PeriodListVC(delegate: self, strategy: strategy, valueConfig: chartModel.valueConfig)
        self.showChildVC(periodListVC)
    }
    
    fileprivate func createWeeklyModel(_ vc: UIViewController, item: Items, config: ValueConfig) {
        
        var periodModel: PeriodListModel!
        var dateStrategy: DateStrategy?
        let dataSegmentIndex =
        print("createWeeklyModel, \(dateConfigure.date)")
      
        let dataIndex = uiconfig.datafilterView.selectedItem
        
        if vc.className == "PeriodListVC" {
            let periodVC = vc as! PeriodListVC
             // 날짜 업데이트 하고, 엔티티 생성
            
            periodModel = periodVC.listmodel
            periodModel.createEntity(item: item, config: config)
     
        } else {
            let weeklyChartVC = vc as! WeeklyChartVC
       
            periodModel = weeklyChartVC.model
            periodModel.createEntity(item: item, config: config)
        
        }
        
    }
    
    fileprivate func createMonthlyModel(_ date: String, item: Items, config: ValueConfig) {
        mainListModel = MainListModel(date: date)
        mainListModel?.createEntity(item: item, config: chartModel.valueConfig)
    }
    
    func updateViewController(item: Items, config: ValueConfig) {
        
        let periodIndex = uiconfig.periodSegmentCtrl.selectedIndex
        let dataIndex = uiconfig.datafilterView.selectedItem
       
        print("Class Name: \(currentVC?.className)")

        let dateTime = item.entityDT ?? Date()
        
        print("DateTime: \(dateTime)")
        if dataIndex == 1 {
            dateConfigure.date = dateTime ?? Date()
            
            if currentVC?.className == "PeriodListVC" {
                let periodListVC = currentVC as! PeriodListVC
                createWeeklyModel(periodListVC, item: item, config: config)
                scrollToSection(date: item.date, periodListVC: periodListVC)
            }
            
        } else {
            dateConfigure.calendarDate = dateTime ?? Date()

            if periodIndex == 0 {
                var weeklyChartVC = currentVC as! WeeklyChartVC
                weeklyChartVC.date =  dateConfigure.calendarDate
                createWeeklyModel(weeklyChartVC, item: item, config: config)
            
            } else {

                let date = item.date.extractDate
                createMonthlyModel(date, item: item, config: config)
                calendarController.updateMonthHandler?(item.entityDT)
                
            }
            
        }
    }
    
    func scrollToSection(date: String, periodListVC: PeriodListVC) {
    
        let model = periodListVC.listmodel
        let section = model.findSections(date: date)
        periodListVC.tableView.scrollToTop(animated: true, section: section)
    }
    
    func getMinMaxDate(isCalendar: Bool = false) -> [Date] {

        let datemap = strategy.getDateMap()
        var minDate: Date?
        var maxDate: Date?
        
        let firstDate = datemap.first
        var lastDate = datemap.last
        
        print("getMinMaxDate: \(firstDate), \(lastDate)")
        
        minDate = firstDate
        if lastDate == Date() {
            maxDate = lastDate?.dayBefore
        } else {
            
            if isCalendar {
                let date = datemap.filter { $0.onlyDate == Date().onlyDate }
                if date.count > 0 { lastDate = Date() }
            }
            maxDate = lastDate
        }
        return [minDate!, maxDate!]
    }
    
    func updateMinMaxDate() -> [Date] {
        
        var dates = [Date]()
        let periodIndex = uiconfig.periodSegmentCtrl.selectedIndex
        let dataIndex = uiconfig.datafilterView.selectedItem
        
        if periodIndex == 1 && dataIndex == 0 {
            
            strategy = MonthlyDateStrategy(date: dateConfigure.calendarDate)
            strategy.fetchedData()
            strategy.setMinimumDate()
            strategy.setMaximumDate()
            
            dates = getMinMaxDate(isCalendar: true)
        } else {
            dates = getMinMaxDate()
        }
        
        return dates
    }
    
    fileprivate func updateDateRange() {
        if uiconfig.periodSegmentCtrl.selectedIndex == 0 {
            strategy = WeeklyDateStrategy(date: dateConfigure.date)
        } else {
            
            print("Date Configure: \(dateConfigure.calendarDate)")
            if dateConfigure.calendarDate > dateConfigure.date {  dateConfigure.calendarDate = Date() }
            
            strategy = MonthlyDateStrategy(date: dateConfigure.calendarDate)
        }
    }
    
}

extension ChartVC: CustomSegmentedControlDelegate {
    
    func valueChangedPeriod(to index: Int) {
        updateDateRange()
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

        updateDateRange()
        
        switch index {
        
        case 0 :
            removeCurrentVC()
            // Chart
            self.displayCurrentTab(uiconfig.periodSegmentCtrl.selectedIndex)

        default:
            
            // List
            removeCurrentVC()
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
