//
//  AlarmSettingVC+Ext.swift
//  VFCounter
//
//  Created by Sunmi on 2020/08/05.
//  Copyright © 2020 creativeSun. All rights reserved.
//

import UIKit


extension AlarmSettingVC {
    
    func calcurateSlider(slider: CustomSlider, amount: Float, step: Float, cell: UITableViewCell) {
    
        if slider.minimumValue <= amount && slider.maximumValue >= amount {
            let roundedValue = round(amount / step) * step
            slider.value = roundedValue
            cell.textLabel?.text = String(Int(roundedValue)) + " g"
            
        } else {
            cell.textLabel?.text = "0"
            slider.value = 0
        }
    }
}

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
        cell.selectionStyle = .none
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
            calcurateSlider(slider: veggieSlider, amount: value, step: 10.0, cell: cell!)
            SettingManager.setVeggieTaskRate(percent: value)
            NotificationCenter.default.post(name: .updateTaskPercent, object: nil, userInfo: ["veggieAmount": Int(veggieSlider.value)])

        default:        
            fruitsSettings.taskPercent = value
            let cell = tableView.cellForRow(at: IndexPath(row: 1, section: 1))
            print(fruitsSettings.taskPercent)
            calcurateSlider(slider: fruitsSlider, amount: value, step: 10.0, cell: cell!)
            SettingManager.setFruitsTaskRate(percent: value)
            NotificationCenter.default.post(name: .updateTaskPercent, object: nil, userInfo: ["fruitAmount": Int(fruitsSlider.value)])
        }
    }
       

}
