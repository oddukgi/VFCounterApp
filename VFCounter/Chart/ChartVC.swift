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

    enum TabIndex: Int {
        case firstChildTab = 0
        case secondChildTab = 1
    }
    
    var segmentControl: CustomSegmentedControl!
    var datafilterView: DataFilterView!
   
    let contentView     = UIView()
    let weeklyChartView = UIView()
    var monthlyChartView: UIView!

    lazy var btnAdd: VFButton = {
        let button = VFButton()
        button.addImage(imageName: "add")
        return button
    }()

    var currentVC: UIViewController?
    
    private var dateConfigure = ChartVC.DateConfigure()
    private var dateStrategy: DateStrategy!
    var valueConfig = ValueConfig()

    var weeklyChartVC:  WeeklyChartVC?
    let calendarController = CalendarController(mode: .single)
    
    var currentValue: CalendarValue? {
        didSet {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy.MM.dd"
            formatter.locale = Locale(identifier: "ko_KR")
            
        }
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
        displayCurrentTab(TabIndex.firstChildTab.rawValue)
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
            $0.size.equalTo(CGSize(width: 200, height: 38))
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
        case TabIndex.firstChildTab.rawValue:
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
        if let vc = viewControllerForSelectedIndex(index) , index == 0 {
            showChildVC(vc)
        }
    }
 
    fileprivate func prepareNotificationAddObserver(){
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateDateTime(_:)),
                                               name: .updateMonth, object: nil)
    }
    
    // MARK: action
    @objc fileprivate func updateDateTime(_ notification: Notification) {
        if let userDate = notification.userInfo?["usermonth"] as? Date {
            dateConfigure.calendarDate = userDate
        }
    }
    
    @objc func tappedAdd(_ sender: VFButton) {
        showPickUpViewController(tag: 0)
    }
    

    func showPickUpViewController(tag: Int) {
        let datamanager = DataManager()
        valueConfig.maxVeggies = Int(SettingManager.getTaskValue(keyName: "VeggieTaskRate") ?? 0)
        valueConfig.maxFruits = Int(SettingManager.getTaskValue(keyName: "FruitTaskRate") ?? 0)

        let datetime = dateConfigure.date.changeDateTime(format: .date)
        let datemodel = DateModel(date: datetime, tag: tag, sumV: valueConfig.sumVeggies,
                                  sumF: valueConfig.sumFruits, maxV: valueConfig.maxVeggies,
                                  maxF: valueConfig.maxFruits)
        DispatchQueue.main.async {
            let itemPickVC = PickItemVC(delegate: self, datemodel: datemodel, sectionFilter: .chart)
            let navController = UINavigationController(rootViewController: itemPickVC)
            self.present(navController, animated: true)

        }
    }
    
    func updateView(dateTime: String) {
        
        let periodIndex = segmentControl.selectedIndex
        let dataIndex = datafilterView.dataSegmentControl.selectedIndex
        if dataIndex == 0 {
    
            dateConfigure.date = dateTime.changeDateTime(format: .date)
            if periodIndex == 0 {
                change(to: periodIndex)
            } else {
              calendarController.moveToSpecificDate(date: dateConfigure.date)
            }
            
        } else {
            if self.segmentControl.selectedIndex == 0 {
                dateConfigure.date = dateTime.changeDateTime(format: .date)
            } else {
                dateConfigure.calendarDate = dateTime.changeDateTime(format: .date)
            }
            valueChangedIndex(to: dataIndex)
        }

    }
    
    
}



extension ChartVC: CustomSegmentedControlDelegate {
    func change(to index: Int) {
        
        if datafilterView.dataSegmentControl.selectedIndex == 0 {
            removeCurrentVC()
            displayCurrentTab(index)
        } else {
            removeCurrentVC()
            valueChangedIndex(to: datafilterView.dataSegmentControl.selectedIndex)
        }
    }
    
    func valueChangedIndex(to index: Int) {
        
        switch index {
        case 0 :
            removeCurrentVC()
            self.displayCurrentTab(self.segmentControl.selectedIndex)
            
        default:
            removeCurrentVC()
            if self.segmentControl.selectedIndex == 0 {
                self.dateStrategy = WeeklyDateStrategy(date: dateConfigure.date)
            } else {
                self.dateStrategy = MonthlyDateStrategy(date: dateConfigure.calendarDate)
                
                print("CalendarDate: \(dateConfigure.calendarDate)")
            }
            
            self.showChildVC(PeriodListVC(dateStrategy: self.dateStrategy))            
        }
    }
}


extension ChartVC: PickItemVCProtocol {
    func addItems(item: VFItemController.Items, tag: Int) {
    
        if !item.name.isEmpty {
            let dataManager = DataManager()
            let stringDate = String(item.date.split(separator: " ").first!)
            dataManager.createEntity(item: item, tag: tag)
            
            NotificationCenter.default.post(name: .updateDateTime, object: nil, userInfo: ["userdate": stringDate])
            updateView(dateTime: stringDate)
            
        }
    }
    
    func updateItems(item: VFItemController.Items, time: Date?, tag: Int) {
        
    }
    
    
}


extension ChartVC {
    struct DateConfigure {
        var calendarDate = Date()
        var date = Date()

    }
}
