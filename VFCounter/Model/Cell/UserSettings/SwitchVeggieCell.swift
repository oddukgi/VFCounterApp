//
//  SwitchVeggieCell.swift
//  VFCounter
//
//  Created by Sunmi on 2020/10/12.
//  Copyright © 2020 creativeSun. All rights reserved.
//

import UIKit

protocol SwitchVeggieDelegate: class {
    func updateVeggieSwitch(_ flag: Bool)
}

class SwitchVeggieCell: UITableViewCell, SelfConfigCell {

    static var reuseIdentifier = "SwitchVeggieCell"
    weak var delegate: SwitchVeggieDelegate?
    
    @IBOutlet weak var veggieSwitch: UISwitch!
    override func awakeFromNib() {
        super.awakeFromNib()
        loadedDefaultValue()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func loadedDefaultValue() {
        if let value = SettingManager.getAlarmValue(keyName: "VeggieAlarm") {
            veggieSwitch.isOn = value
        }
    }

    // MARK: - Save value in UserDefaults
    @IBAction func changedSwitchValue(_ sender: UISwitch) {
        SettingManager.setVeggieAlarm(veggieFlag: sender.isOn)
        delegate?.updateVeggieSwitch(sender.isOn)
    }
}
