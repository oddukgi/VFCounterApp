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
    private var dateStrategy: DateStrategy!
    
    
    let now = Date()
    private var settings: DateSettings = DateSettings.default
    private var calendarDate = Date()
    
    lazy var weeklyChartVC: UIViewController? = {
        dateStrategy =  WeeklyDateStrategy(date: self.now)
        let weeklyChartVC = WeeklyChartVC(dateStrategy: dateStrategy)
        return weeklyChartVC
    }()
    

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
        calendarController.minimumDate = now.getFirstMonthDate()
        calendarController.maximumDate = now
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
            vc = weeklyChartVC
       
        default:
            configureCalendar()
            calendarController.present(above: self, contentView: contentView)
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
    
    @objc func tappedAdd(_ sender: VFButton) {
        print("tapped add")
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
                self.dateStrategy = WeeklyDateStrategy(date: self.now)
            } else {
                self.dateStrategy = MonthlyDateStrategy(date: self.calendarDate)
            }
            
            self.showChildVC(PeriodListVC(dateStrategy: self.dateStrategy))            
        }
    }
}
