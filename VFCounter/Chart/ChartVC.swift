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
    
    var segmentControl: CustomSegmentControl!
    var bottomSegmentControl: CustomSegmentControl!
    let contentView     = UIView()
    let weeklyChartView = UIView()
    var monthlyChartView: UIView!
    var datafilterView: DataFilterView!

    var currentVC: UIViewController?
    private var dateStrategy: DateStrategy!
    private var periodRange: PeriodRange = .weekly
    
    
    let now = Date()

    private var settings: DateSettings = DateSettings.default
    private var calendarMonth: CalendarSettings.MonthSelectView = CalendarSettings.default.monthSelectView
    
    lazy var weeklyChartVC: UIViewController? = {
        settings.periodController.weekDate = now.dayBefore
        let weeklyChartVC = WeeklyChartVC(setting: settings.periodController)
        return weeklyChartVC
    }()
    

    let calendarConroller = CalendarController(mode: .single)
    
    var currentValue: CalendarValue? {
        didSet {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy.MM.dd"
            formatter.locale = Locale(identifier: "ko_KR")
            if let date = self.currentValue as? Date {
                print(formatter.string(from: date))
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Chart"
        view.backgroundColor = .systemBackground
        prepareNotificationAddObserver()
        configureDataFilterView()
        configure()
        displayCurrentTab(TabIndex.firstChildTab.rawValue)
        connectAction()
    }

    
    
    @objc func changedIndexSegment(sender: UISegmentedControl) {
        self.currentVC?.view.removeFromSuperview()
        self.currentVC?.removeFromParent()
        displayCurrentTab(sender.selectedSegmentIndex)
    }
    
    func configureCalendar() {
        calendarConroller.initialValue = self.currentValue as? Date
        calendarConroller.minimumDate = now.getLast12Month()
        calendarConroller.maximumDate = now
    }
    
    fileprivate func configureDataFilterView() {
        datafilterView = DataFilterView(frame: CGRect(x: 0, y: 0,
                                                      width: view.frame.width, height: view.frame.height))
        view.addSubview(datafilterView)
        datafilterView.snp.makeConstraints {
            $0.bottom.equalTo(view.snp.bottom).offset(-8)
            $0.centerX.equalTo(view.snp.centerX)
        }
        datafilterView.selectSection(section: .data)
    }
    
    fileprivate func showChildVC(_ vc: UIViewController) {
        self.addChild(vc)
        self.contentView.addSubview(vc.view)
        vc.view.frame = self.contentView.bounds
        self.currentVC = vc
        print(contentView.frame.width, contentView.frame.height)
        contentView.layer.borderWidth = 1
        vc.didMove(toParent: self)
    }
    
    
    func viewControllerForSelectedIndex(_ index: Int) -> UIViewController? {
        var vc: UIViewController?
        
        switch index {
        case TabIndex.firstChildTab.rawValue:
            vc = weeklyChartVC
        default:
            configureCalendar()
            calendarConroller.present(above: self, contentView: contentView)
        }
        
        return vc
    }
    
    func displayCurrentTab(_ index: Int) {
        if let vc = viewControllerForSelectedIndex(index) , index == 0{
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
          
            self.settings.periodController.monthDate = userDate
        }
    }
    
    
    func connectAction() {
      
        datafilterView.dataBtn.addTargetClosure { _ in
            print("tapped data button")
            self.datafilterView.selectSection(section: .data)
            self.displayCurrentTab(self.segmentControl.selectedSegmentIndex)
        }
        
        datafilterView.listBtn.addTargetClosure { _ in
            print("tapped list button")
            self.datafilterView.selectSection(section: .list)
            
            if self.segmentControl.selectedSegmentIndex == 0 {
                self.dateStrategy = WeeklyDateStrategy(date: self.now)
                self.periodRange = .weekly
                
            } else {
                
                
                let newDate = self.settings.periodController.monthDate!
                print(newDate)
                self.dateStrategy = MonthlyDateStrategy(date: newDate)
                self.periodRange = .monthly

            }
            self.showChildVC(PeriodListVC(periodRange: self.periodRange,
                                           dateStrategy: self.dateStrategy))
        }
    }
    

}

