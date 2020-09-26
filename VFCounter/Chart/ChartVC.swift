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
    
    
    let now = Date()

    private var settings: DateSettings = DateSettings.default
    private var calendarDate = Date()
    
    lazy var weeklyChartVC: UIViewController? = {
        dateStrategy =  WeeklyDateStrategy(date: self.now)
        let weeklyChartVC = WeeklyChartVC(dateStrategy: dateStrategy)
        return weeklyChartVC
    }()
    

    let calendarConroller = CalendarController(mode: .single)
    
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
        view.backgroundColor = .systemBackground
        prepareNotificationAddObserver()
        configureDataFilterView()
        configure()
        displayCurrentTab(TabIndex.firstChildTab.rawValue)
        connectAction()
    }

    func removeCurrentVC() {
        self.currentVC?.view.removeFromSuperview()
        self.currentVC?.removeFromParent()
    }

    @objc func changedIndexSegment(sender: UISegmentedControl) {
        removeCurrentVC()
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
            calendarDate = userDate
        }
    }
    
    func connectAction() {
      
        datafilterView.dataBtn.addTargetClosure { _ in

            self.datafilterView.selectSection(section: .data)
            self.displayCurrentTab(self.segmentControl.selectedSegmentIndex)
        }
        
        datafilterView.listBtn.addTargetClosure { _ in

            
            self.datafilterView.selectSection(section: .list)
            
            if self.segmentControl.selectedSegmentIndex == 0 {
                self.dateStrategy = WeeklyDateStrategy(date: self.now)
            } else {
                self.dateStrategy = MonthlyDateStrategy(date: self.calendarDate)
            }
            
            self.showChildVC(PeriodListVC(dateStrategy: self.dateStrategy))
        }
    }
    

}

