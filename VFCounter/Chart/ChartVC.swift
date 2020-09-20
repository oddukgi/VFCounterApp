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
    let now = Date()

    private var settings: DateSettings = DateSettings.default
    
    lazy var weeklyChartVC: UIViewController? = {
        settings.weekChartCtrl.startDate = now.dayBefore
        let weeklyChartVC = WeeklyChartVC(setting: settings.weekChartCtrl)
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
 
    func connectAction() {
      
        datafilterView.dataBtn.addTargetClosure { _ in
            print("tapped data button")
            self.datafilterView.selectSection(section: .data)
            self.displayCurrentTab(self.segmentControl.selectedSegmentIndex)
        }
        
        datafilterView.listBtn.addTargetClosure { _ in
            print("tapped list button")
            self.datafilterView.selectSection(section: .list)
            var periodRange: PeriodRange
            self.segmentControl.selectedSegmentIndex == 0 ? (periodRange = .weekly) : (periodRange = .monthly)
            self.settings.listCtrl.startDate = self.now.dayBefore
            self.showChildVC(HistoryVC(periodRange: periodRange, setting: self.settings.listCtrl))
        }
    }
}

