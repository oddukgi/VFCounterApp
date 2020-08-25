//
//  WeeklyChartVC.swift
//  VFCounter
//
//  Created by Sunmi on 2020/08/25.
//  Copyright © 2020 creativeSun. All rights reserved.
//

import UIKit

class WeeklyChartVC: UIViewController {

   
    var date: String?
    
    init(date: String) {
        super.init(nibName: nil, bundle: nil)
        self.date = date
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red

    }
}
