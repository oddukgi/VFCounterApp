//
//  AlarmSettingVC+Ext.swift
//  VFCounter
//
//  Created by Sunmi on 2020/08/05.
//  Copyright © 2020 creativeSun. All rights reserved.
//

import UIKit


extension AlarmSettingVC: UITableViewDataSource {

    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let sectionKind = Section(rawValue: section)
        return sectionKind?.description()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifer, for: indexPath)
        connectCell(cell, for: indexPath)
        return cell
    }
}

extension AlarmSettingVC: SliderUpdateDelegate {
    
    
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
       

}
