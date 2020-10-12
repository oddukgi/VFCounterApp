//
//  SwitchFruitCell.swift
//  VFCounter
//
//  Created by Sunmi on 2020/10/12.
//  Copyright © 2020 creativeSun. All rights reserved.
//

import UIKit

protocol SwitchFruitDelegate: class {
    func updateFruitSwitch(_ flag: Bool)
}

class SwitchFruitCell: UITableViewCell,SelfConfigCell {

    static var reuseIdentifier = "SwitchFruitCell"
    @IBOutlet weak var fruitsSwitch: UISwitch!
    weak var delegate: SwitchFruitDelegate?
   
    override func awakeFromNib() {
        super.awakeFromNib()
        loadedDefaultValue()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func loadedDefaultValue() {
        if let value = SettingManager.getAlarmValue(keyName: "FruitAlarm") {
            fruitsSwitch.isOn = value
        }
    }
    @IBAction func changedSwitchValue(_ sender: UISwitch) {
        SettingManager.setFruitsAlarm(fruitsFlag: sender.isOn)
        delegate?.updateFruitSwitch(sender.isOn)
    }
}
