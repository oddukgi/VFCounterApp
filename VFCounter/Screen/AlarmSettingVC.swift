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
class AlarmSettingVC: UIViewController, SliderUpdateDelegate {
    
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
    
    var veggieSettings = UserSettings(title: "야채", alarmOn: false, taskPercent: 0)
    var fruitsSettings = UserSettings(title: "과일", alarmOn: false, taskPercent: 0)
    
    private var veggieDataFlag = false
    private var fruitsDataFlag = false

    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        initialize()
//        addUserSettings(userSettings: veggieSettings, actionType: .remove)
        getSettingValue()
       
    }


    func getSettingValue() {
        PersistenceManager.retrieveUserSettings { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let userSettings):
                
                if userSettings.count > 0 {
                   self.updateUI(for: userSettings)
                }
                
            case .failure(let error):
                   print("Something went wrong \(error.rawValue)")
            }

        }
    }
    
    func updateUI(for items: [UserSettings]) {
        
        let data = items
        
        for item in items {
            if !item.hasNilField() {
                guard item.title == "야채" else {
                    
                    fruitsSwitch.isOn = data[1].alarmOn
                    fruitsSettings.alarmOn = data[1].alarmOn
                    
                    fruitsSlider.value = data[1].taskPercent
                    fruitsSettings.taskPercent = data[1].taskPercent
      
                
                    fruitsDataFlag = true
                    
                    return
                }
                veggieSwitch.isOn = data[0].alarmOn
                veggieSettings.alarmOn = data[0].alarmOn
                
                veggieSlider.value = data[0].taskPercent
                veggieSettings.taskPercent = data[0].taskPercent
           
                veggieDataFlag = true
            }
        }

    }
    
    
    @objc func changedSwitch(_ sender: UISwitch) {

        let tag = sender.tag

        switch tag {
        case 0:
            veggieSettings.alarmOn = sender.isOn
            addUserSettings(userSettings: veggieSettings, actionType: .update)

        default:
            fruitsSettings.alarmOn = sender.isOn
//            addUserSettings(userSettings: fruitsSettings)
        }

    }
        

    func sliderTouch(value: Float, tag: Int) {
 
    }
    
    func sliderValueChanged(value: Float, tag: Int) {
        
        switch tag {
        case 1:
            veggieSettings.taskPercent = value
           
            let cell = tableView.cellForRow(at: IndexPath(row: tag, section: 0))
            print(veggieSettings.taskPercent)
            cell?.textLabel?.text = "\(Int(veggieSettings.taskPercent))%"
            addUserSettings(userSettings: veggieSettings, actionType: .update)

        default:
        
             fruitsSettings.taskPercent = value
             let cell = tableView.cellForRow(at: IndexPath(row: tag, section: 1))
             
             print(fruitsSettings.taskPercent)
             cell?.textLabel?.text = "\(Int(fruitsSettings.taskPercent))%"
           //  addUserSettings(userSettings: fruitsSettings, actionType: .update)
        }
    }
    

    func addUserSettings( userSettings: UserSettings, actionType: PersistenceActionType? ) {

        PersistenceManager.updateWith(items: userSettings, actionType: actionType!) { error in
  
            guard let error = error else {
               print("Success")
                return
            }
            
            print("Something went wrong \(error.localizedDescription)")
        }
        
    }
    
}

extension AlarmSettingVC { 
    
    func initialize() {
        veggieSlider.values(min: 0, max: 100, current: 0)
        let width = (view.frame.width / 2) + 80
        veggieSlider.frame = CGRect(x: 0, y: 0, width: width, height: 57)
        veggieSlider.delegate = self
        veggieSlider.thumbTintColor(.white)
        veggieSlider.minimumTrackTintColor(SliderColor.greenishTeal)
        veggieSlider.maximumTrackTintColor(SliderColor.maximumTrackTint)
        veggieSlider.isContinuous = true

        fruitsSlider.frame = CGRect(x: 0, y: 0, width: width, height: 57)
        fruitsSlider.delegate = self
        fruitsSlider.thumbTintColor(.white)
        fruitsSlider.minimumTrackTintColor(SliderColor.orangeyRed)
        fruitsSlider.maximumTrackTintColor(SliderColor.maximumTrackTint)
        fruitsSlider.isContinuous = true
        fruitsSlider.values(min: 0, max: 100, current: 0)
        
        veggieSwitch.addTarget(self, action: #selector(changedSwitch(_:)), for: .valueChanged)
        fruitsSwitch.addTarget(self, action: #selector(changedSwitch(_:)), for: .valueChanged)
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
                cell.textLabel?.text = "알림설정"
                cell.accessoryView = veggieSwitch
                veggieSwitch.tag = 0
           } else {
                
                cell.textLabel?.text = "\(Int(veggieSettings.taskPercent))%"
                cell.accessoryView = veggieSlider
                veggieSlider.tag = 1
            }
        
        default:
        
           if indexPath.item == 0 {
                cell.accessoryView = fruitsSwitch
                fruitsSwitch.tag = 2
           } else {
                cell.accessoryView = fruitsSlider
                fruitsSlider.tag = 3
            }
        
        }
    }
    
}
