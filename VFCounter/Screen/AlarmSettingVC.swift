//
//  AlarmSettingVC.swift
//  VFCounter
//
//  Created by Sunmi on 2020/08/05.
//  Copyright © 2020 creativeSun. All rights reserved.
//

import UIKit

// group 
// section

// tableview, UITextField, UIPickerView

// Show, Hide (DateTimePicker, Percentage)

class AlarmSettingVC: UIViewController {
    
    enum Section: Int {
        case veggies = 0, fruits
        
        func description() -> String {
            switch self {
            case .veggies:
                return "야채"
            case .fruits:
                return "과일"
            }
        }
 
    }


    var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let flag = SettingManager.getInitialLaunching(keyName: "InitialLaunching"),
           flag == false {
                SettingManager.setInitialLaunching(flag: true)
            }
        
        configureTableView()

    }

}

extension AlarmSettingVC { 

    func configureTableView() {
        tableView = UITableView(frame: .zero, style: .grouped)
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = UITableView.automaticDimension
        
        tableView.register(UINib(nibName: "SwitchVeggieCell", bundle: nil), forCellReuseIdentifier: SwitchVeggieCell.reuseIdentifier)
        tableView.register(UINib(nibName: "SwitchFruitCell", bundle: nil), forCellReuseIdentifier: SwitchFruitCell.reuseIdentifier)
        tableView.register(UINib(nibName: "MaxAmountVeggieCell", bundle: nil), forCellReuseIdentifier: MaxAmountVeggieCell.reuseIdentifier)
        tableView.register(UINib(nibName: "MaxAmountFruitCell", bundle: nil), forCellReuseIdentifier: MaxAmountFruitCell.reuseIdentifier)
        
        let gesture = UITapGestureRecognizer(target: tableView, action: #selector(UITextView.endEditing(_:)))
        tableView.addGestureRecognizer(gesture)
    }
}
