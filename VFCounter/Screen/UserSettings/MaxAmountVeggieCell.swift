//
//  MaxAmountTableCell.swift
//  VFCounter
//
//  Created by Sunmi on 2020/10/10.
//  Copyright © 2020 creativeSun. All rights reserved.
//

import UIKit

protocol MaxAmoutVeggieCellDelegate: class {
    func displayAlertMessageV(value: Float)
    func textField(editingDidBeginIn cell: MaxAmountVeggieCell)
    func textField(editingChangedInTextField newText: String, in cell: MaxAmountVeggieCell)
}

class MaxAmountVeggieCell: UITableViewCell, SelfConfigCell {

    static let reuseIdentifier = "MaxAmountVeggieCell"
    weak var delegate: MaxAmoutVeggieCellDelegate?

    @IBOutlet weak var maxAmountTF: UITextField!
    @IBOutlet weak var veggieSlider: UISlider!

    let maxLength = 3

    override func awakeFromNib() {
        super.awakeFromNib()
        loadedDefaultValue()
        setupViews()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

    func setupViews() {
        selectionStyle = .none

        let gesture = UITapGestureRecognizer(target: self, action: #selector(didSelectCell(_:)))
        addGestureRecognizer(gesture)
    }

    func loadedDefaultValue() {
        if let value = SettingManager.getAlarmValue(keyName: "VeggieAlarm") {
            value ? (veggieSlider.isEnabled = true) : (veggieSlider.isEnabled = false)
        }

        if let sliderValue = SettingManager.getTaskValue(keyName: "VeggieTaskRate") {
            veggieSlider.value = sliderValue
            maxAmountTF.text = String(format: "%.0f", sliderValue)
        }
    }

    fileprivate func updateResource(_ amount: Float, step: Float = 10, flag: Bool = false) {
        let roundedValue = round(amount / step) * step
        veggieSlider.value = roundedValue
        maxAmountTF.text = String(Int(roundedValue))

        SettingManager.setVeggieTaskRate(percent: amount)
        NotificationCenter.default.post(name: .updateTaskPercent, object: nil, userInfo: ["veggieAmount": Int(roundedValue)])

        if flag == true {
            delegate?.textField(editingChangedInTextField: String(roundedValue), in: self)
        }
    }

    func calcurateSlider(amount: Float, step: Float) {

        if veggieSlider.minimumValue <= amount && veggieSlider.maximumValue >= amount {
            updateResource(amount)

        } else {
            maxAmountTF.text = "10"
            veggieSlider.value = 10
        }
    }

    @objc func didSelectCell() {
        maxAmountTF.becomeFirstResponder()
    }

    // MARK: - TextField Action
   @IBAction func valueChangedSlider(_ sender: UISlider) {
        calcurateSlider(amount: sender.value, step: 10.0)
    }

    @IBAction func editingDidBegin(_ sender: UITextField) {
        delegate?.textField(editingDidBeginIn: self)

    }

    @objc func didSelectCell(_ sender: UITapGestureRecognizer) {
        maxAmountTF?.becomeFirstResponder()
    }
}

// textfield limit length
//https://stackoverflow.com/a/31363255/13275605
// accept number in TextField
//https://stackoverflow.com/a/32962840/13275605

extension MaxAmountVeggieCell: UITextFieldDelegate {

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == self.maxAmountTF {

            let currentString: NSString = textField.text! as NSString
            let newString: NSString = currentString.replacingCharacters(in: range, with: string) as NSString

            let convertedString = string.containsNumber()
            return (newString.length <= maxLength && string == convertedString)
        }

        return false
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {

        if let text = textField.text {

            maxAmountTF.resignFirstResponder()
            var amount = Float(text) ?? 0

            guard veggieSlider.minimumValue <= amount && veggieSlider.maximumValue >= amount
            else {
                delegate?.displayAlertMessageV(value: amount)
                return false

            }
            updateResource(amount, flag: true)
        }

        return true
    }
}

/*
 @objc func editingDidBegin() {
     delegate?.textField(editingDidBeginIn: self)
     
 }
 @objc func textFieldValueChanged(_ sender: UITextField) {
     if let text = sender.text {
         guard let value = Int(text), value > 500 else { return }
         let newValue = Float(value)
         calcurateSlider(amount: newValue, step: 10)
         delegate?.textField(editingChangedInTextField: text, in: self)

     }
 }
 */
