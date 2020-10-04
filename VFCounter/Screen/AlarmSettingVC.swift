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

    let reuseIdentifer = "AlarmSettings"
    var tableView: UITableView!
    
    var veggieSwitch = UISwitch()
    var veggieSlider = CustomSlider()
    var fruitsSwitch = UISwitch()
    var fruitsSlider = CustomSlider()
    
    var veggieSettings = UserSettings(title: "야채",
                                      alarmOn: false, taskPercent: 0)
    var fruitsSettings = UserSettings(title: "과일",
                                      alarmOn: false, taskPercent: 0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        initialize()
        loadDataFromUserDefaults()
    }

    func loadDataFromUserDefaults() {
        
        // check initial launching
        
        if let alarm = SettingManager.getAlarmValue(keyName: "VeggieAlarm") {
            veggieSettings.alarmOn = alarm
            veggieSwitch.isOn = alarm
            veggieSwitch.isOn ? (veggieSlider.isEnabled = true) : (veggieSlider.isEnabled = false)
        }
        
        if let alarm = SettingManager.getAlarmValue(keyName: "FruitAlarm") {
            fruitsSettings.alarmOn = alarm
            fruitsSwitch.isOn = alarm
            fruitsSwitch.isOn ? (fruitsSlider.isEnabled = true) : (fruitsSlider.isEnabled = false)
        }
        
        if let flag = SettingManager.getInitialLaunching(keyName: "InitialLaunching"),
           flag == false {
                SettingManager.setInitialLaunching(flag: true)
            }
        
    
        if let rate = SettingManager.getTaskValue(keyName: "VeggieTaskRate") {
            veggieSettings.taskPercent = rate
            veggieSlider.value = rate
        }
    
        if let rate = SettingManager.getTaskValue(keyName: "FruitTaskRate") {
            fruitsSettings.taskPercent = rate
            fruitsSlider.value = rate
        }

    }
    
    @objc func changedSwitch(_ sender: UISwitch) {

        let tag = sender.tag

        switch tag {
        case 0:
            veggieSettings.alarmOn = sender.isOn
            SettingManager.setVeggieAlarm(veggieFlag: sender.isOn)
            sender.isOn ? (veggieSlider.isEnabled = true) : (veggieSlider.isEnabled = false)
      
        default:
            fruitsSettings.alarmOn = sender.isOn
            SettingManager.setFruitsAlarm(fruitsFlag: sender.isOn)
            sender.isOn ? (fruitsSlider.isEnabled = true) : (fruitsSlider.isEnabled = false)
            changedColorOfSwitch(sender.isOn)
        }

    }
    
    func changedColorOfSwitch(_ flag: Bool) {
        if flag == true {
            fruitsSwitch.onTintColor = ColorHex.orangeyRed
            fruitsSwitch.subviews[0].subviews[0].backgroundColor = ColorHex.orangeyRed
      
        } else {
            fruitsSwitch.backgroundColor = .clear
            fruitsSwitch.subviews[0].subviews[0].backgroundColor = ColorHex.switchWhite
        }
  
    }

    @objc fileprivate func initializeRate(_ notification: Notification) {
     
        if let maxValue = notification.userInfo?["VeggieTaskRate"] as? Int {
            veggieSlider.maximumValue = Float(maxValue)
            veggieSlider.value = Float(maxValue)
            
            fruitsSlider.maximumValue = Float(maxValue)
            fruitsSlider.value = Float(maxValue)

        }
    }
    
}

extension AlarmSettingVC { 
    
    func initialize() {
        veggieSlider.values(min: 0, max: 500, current: 0)
        let width = (view.frame.width / 2) + 80
        veggieSlider.frame = CGRect(x: 0, y: 0, width: width, height: 57)
        veggieSlider.delegate = self
        veggieSlider.thumbTintColor(.white)
        veggieSlider.minimumTrackTintColor(SliderColor.greenishTeal)
        veggieSlider.maximumTrackTintColor(SliderColor.maximumTrackTint)
        veggieSlider.isContinuous = true

        fruitsSlider.values(min: 0, max: 500, current: 0)
        fruitsSlider.frame = CGRect(x: 0, y: 0, width: width, height: 57)
        fruitsSlider.delegate = self
        fruitsSlider.thumbTintColor(.white)
        fruitsSlider.minimumTrackTintColor(SliderColor.orangeyRed)
        fruitsSlider.maximumTrackTintColor(SliderColor.maximumTrackTint)
        fruitsSlider.isContinuous = true
        
        
        veggieSwitch.addTarget(self, action: #selector(changedSwitch(_:)), for: .valueChanged)
        fruitsSwitch.addTarget(self, action: #selector(changedSwitch(_:)), for: .valueChanged)
        
        // set border color when isOn is false
        fruitsSwitch.tintColor = ColorHex.switchWhite
        // set border color when isOn is true
        fruitsSwitch.onTintColor = ColorHex.orangeyRed
    }

    
    func configureTableView() {
        tableView = UITableView(frame: .zero, style: .grouped)
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseIdentifer)
    }
    

    func connectCell(_ cell: UITableViewCell,for indexPath: IndexPath){
        
        let section = indexPath.section
       
        switch section {

        case 0:
            if indexPath.item == 0 {
                cell.textLabel?.text = "목표량 설정"
                cell.accessoryView = veggieSwitch
                veggieSwitch.tag = 0
           } else {
                
                cell.textLabel?.text = "\(Int(veggieSettings.taskPercent))g"
                cell.accessoryView = veggieSlider
                veggieSlider.tag = 1
            }
        
        default:
        
           if indexPath.item == 0 {
                cell.textLabel?.text = "목표량 설정"
                cell.accessoryView = fruitsSwitch
                fruitsSwitch.tag = 2
           } else {
            
                cell.textLabel?.text = "\(Int(fruitsSettings.taskPercent))g"
                cell.accessoryView = fruitsSlider
                fruitsSlider.tag = 3
            }
        }
    }
    
}
