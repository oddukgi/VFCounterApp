//
//  MaxAmountFruitCell.swift
//  VFCounter
//
//  Created by Sunmi on 2020/10/12.
//  Copyright © 2020 creativeSun. All rights reserved.
//

import UIKit

protocol MaxAmoutFruitCellDelegate: class {
    func displayAlertMessageF(value: Float)
    func textField(editingDidBeginIn cell: MaxAmountFruitCell)
    func textField(editingChangedInTextField newText: String, in cell: MaxAmountFruitCell)
}

class MaxAmountFruitCell: UITableViewCell, SelfConfigCell {

    static let reuseIdentifier = "MaxAmountFruitCell"
    weak var delegate: MaxAmoutFruitCellDelegate?

    @IBOutlet weak var maxAmountTF: UITextField!
    @IBOutlet weak var fruitSlider: UISlider!

    private let maxLength = 3

    override func awakeFromNib() {
        super.awakeFromNib()
        loadedDefaultValue()
        setupViews()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setupViews() {
        selectionStyle = .none
        let gesture = UITapGestureRecognizer(target: self, action: #selector(didSelectCell(_:)))
        addGestureRecognizer(gesture)
    }

    func loadedDefaultValue() {
        if let value = SettingManager.getAlarmValue(keyName: "FruitAlarm") {
            value ? (fruitSlider.isEnabled = true) : (fruitSlider.isEnabled = false)
        }
        if let sliderValue = SettingManager.getTaskValue(keyName: "FruitTaskRate") {
            fruitSlider.value = sliderValue
            maxAmountTF.text = String(format: "%.0f", sliderValue)
        }
    }

    fileprivate func updateResource(_ amount: Float, step: Float = 10, flag: Bool = false) {
        let roundedValue = round(amount / step) * step
        fruitSlider.value = roundedValue
        maxAmountTF.text = String(Int(roundedValue))
        SettingManager.setFruitsTaskRate(percent: amount)
        NotificationCenter.default.post(name: .updateTaskPercent, object: nil, userInfo: ["fruitAmount": Int(roundedValue)])

        if flag == true {
            delegate?.textField(editingChangedInTextField: String(roundedValue), in: self)
        }
    }

    func calcurateSlider(amount: Float, step: Float) {

        if fruitSlider.minimumValue <= amount && fruitSlider.maximumValue >= amount {
            updateResource(amount)
        } else {
            maxAmountTF.text = "10"
            fruitSlider.value = 10
        }
    }

    @objc func didSelectCell() {
        maxAmountTF.becomeFirstResponder()

    }

    @IBAction func valueChangedSlider(_ sender: UISlider) {
        calcurateSlider(amount: sender.value, step: 10.0)
    }

    // MARK: - TextField Action

    @IBAction func editingDidBegin(_ sender: UITextField) {
        delegate?.textField(editingDidBeginIn: self)

    }

    @objc func didSelectCell(_ sender: UITapGestureRecognizer) {
        maxAmountTF?.becomeFirstResponder()
    }
}

extension MaxAmountFruitCell: UITextFieldDelegate {

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
            if amount == 0 { amount = 1 }
            guard fruitSlider.minimumValue <= amount && fruitSlider.maximumValue >= amount
            else {
                delegate?.displayAlertMessageF(value: amount)
                return false
            }
            updateResource(amount, flag: true)

        }

        return true
    }
}
