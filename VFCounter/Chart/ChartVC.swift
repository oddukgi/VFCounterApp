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
    let contentView     = UIView()
    let weeklyChartView = UIView()
    var monthlyChartView: UIView!
    
    var currentVC: UIViewController?
    
    let now = Date()

    lazy var weeklyChartVC: UIViewController? = {
        let date = now.changeDateTime(format: .date)
        let weeklyChartVC = WeeklyChartVC(date: date)
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
        configure()
        displayCurrentTab(TabIndex.firstChildTab.rawValue)
     
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
    
    func displayCurrentTab(_ index: Int) {
        
        if let vc = viewControllerForSelectedIndex(index) , index == 0{
            self.addChild(vc)
            vc.didMove(toParent: self)
            vc.view.frame = self.contentView.bounds
            self.contentView.addSubview(vc.view)
            self.currentVC = vc
        }
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


}

