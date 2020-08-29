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
    let dateConverter = DateConverter(date: Date())
    
    lazy var weeklyChartVC: UIViewController? = {
        let date = dateConverter.changeDate(format: "yyyy.MM.dd", option: 1)
        let weeklyChartVC = WeeklyChartVC(date: date)
        return weeklyChartVC
        
    }()
    
    lazy var monthlyChartVC: UIViewController? = {
        let now = Date()
        let date = dateConverter.changeDate(format: "yyyy.MM", option: 1)
        let monthlyChartVC = MontlyChartVC(date: date)
        
        return monthlyChartVC
          
    }()
    
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
    
    func displayCurrentTab(_ index: Int) {
        if let vc = viewControllerForSelectedIndex(index) {
            
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
            vc = monthlyChartVC
        }
        
        return vc
    }
   
}

