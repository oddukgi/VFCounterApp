//
//  BaseViewController.swift
//  VFCounter
//
//  Created by Sunmi on 2020/10/09.
//  Copyright © 2020 creativeSun. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    
    var weekday = [String]()
    var datemaps = [String]()
    var selectedIndex: Int = 0
    var periodData = PeriodData()
    var tableSection: Int = 0
    var dateStrategy: DateStrategy!
    var isAddedItem = false
    
    weak var delegate: UpdateDateDelegate?
    var sectionHandler: ((String?) -> Int)?

    init(dateStrategy: DateStrategy, delegate: UpdateDateDelegate, isAddedItem: Bool) {
        self.dateStrategy = dateStrategy
        self.delegate = delegate
        self.isAddedItem = isAddedItem
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func updatePeriod() {
        dateStrategy.fetchedData()
        dateStrategy.setMinimumDate()
        dateStrategy.setMaximumDate()
    }
    
    func changeDefaultDate(date: Date) {
        dateStrategy.date = date
    }

}
