//
//  BaseViewController.swift
//  VFCounter
//
//  Created by Sunmi on 2020/10/09.
//  Copyright © 2020 creativeSun. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    var dateStrategy: DateStrategy!

    init(dateStrategy: DateStrategy) {
        self.dateStrategy = dateStrategy
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    func updatePeriod(_ reloadData: Bool = false) {
        dateStrategy.fetchedData()
        dateStrategy.setMinimumDate()
        dateStrategy.setMaximumDate()
    }
}
