//
//  MeasurementView.swift
//  VFCounter
//
//  Created by Sunmi on 2020/08/10.
//  Copyright © 2020 creativeSun. All rights reserved.
//

import UIKit
import SnapKit

class MeasurementView: UIView {

    var tags = 0
    lazy var labelStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.spacing = 8

       return stackView
    }()

    lazy var gramTF: VFTextField = {
        let textField = VFTextField(frame: CGRect(x: 0, y: 0, width: 80, height: 30))
        textField.borderWidth(1)
        textField.borderColor(ColorHex.MilkChocolate.alpha60)
        textField.textColor(ColorHex.MilkChocolate.origin)
        textField.keyboardType = .numbersAndPunctuation
        textField.delegate = self
        textField.font = NanumSquareRound.bold.style(sizeOffset: 15)
        textField.isUserInteractionEnabled  = true
        textField.textAlignment = NSTextAlignment.center
        textField.returnKeyType = UIReturnKeyType.done
        textField.layer.cornerRadius = 8
        return textField
    }()

    lazy var lblUnit: VFBodyLabel = {
        let label = VFBodyLabel(textAlignment: .center, fontSize: 0, fontColor: ColorHex.MilkChocolate.origin)
        label.font = NanumSquareRound.bold.style(sizeOffset: 15)
        return label
    }()

    let slider = CustomSlider(step: 10)
    private var sliderWidth: CGFloat = 0
    private var step: Float = 10
    private let maxLength = 3

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    convenience init(tag: Int) {
        self.init(frame: .zero)
        self.tags = tag
        setSlider()
        setLayout()
        createDismissKeyboardTapGesture()
    }

    func createDismissKeyboardTapGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIView.endEditing))
        addGestureRecognizer(tap)
    }

    func setSlider() {

        let width = ScreenSize.width
        let btnWidt: CGFloat = 25
        let padding: CGFloat = (btnWidt * 2.0) + CGFloat(25)

        sliderWidth = width - padding

        let veggieRate = SettingManager.getTaskValue(keyName: "VeggieTaskRate") ?? 0
        let fruitRate = SettingManager.getTaskValue(keyName: "FruitTaskRate") ?? 0

        if tags == 0 {
            slider.values(min: 1, max: veggieRate, current: 10)
        } else {
            slider.values(min: 1, max: fruitRate, current: 10)

        }

        slider.delegate = self
        slider.thumbTintColor(.white)
        slider.minimumTrackTintColor(ColorHex.MilkChocolate.origin)
        slider.maximumTrackTintColor(SliderColor.maximumTrackTint)
        slider.isContinuous = true
    }

    func changeMaximumRange() {

    }

    func setLayout() {

        addSubViews(labelStackView, slider)

        gramTF.placeholderText("10")
        lblUnit.text = "g"

        labelStackView.addArrangedSubview(gramTF)
        labelStackView.addArrangedSubview(lblUnit)

        labelStackView.snp.makeConstraints { make in
              make.top.equalTo(self).offset(20)
              make.leading.equalTo(self).offset(36)
              make.width.equalTo(105)
              make.height.equalTo(30)
          }

        slider.snp.makeConstraints { make in
            make.top.equalTo(self).offset(20)
            make.leading.equalTo(labelStackView.snp.trailing).offset(18)
            make.width.equalTo(180)
            make.height.equalTo(30)

        }
        gramTF.text = "\(Int(slider.value))"

    }

    func judgetTextHasNumber(texts: String) -> Bool {
        let scan: Scanner = Scanner.init(string: texts)
       // return scan.scanFloat(&value) && scan.isAtEnd
        return (scan.scanFloat(representation: .decimal) != nil)  && scan.isAtEnd
    }

    func checkAmountTF(text: String) {
        gramTF.resignFirstResponder()

        let amount = Float(text) ?? 0
        if slider.minimumValue <= amount && slider.maximumValue >= amount {

        let roundedValue = round(amount / step) * step
            slider.value = roundedValue
            gramTF.text = String(Int(roundedValue))

        } else {
            gramTF.text = "10"
            slider.value = 10

        }
    }
}

extension MeasurementView: UITextFieldDelegate {

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == self.gramTF {

            let currentString: NSString = textField.text! as NSString
            let newString: NSString = currentString.replacingCharacters(in: range, with: string) as NSString
            let convertedString = string.containsNumber()

            return (newString.length <= maxLength && string == convertedString)
        }

        return false
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.checkAmountTF(text: textField.text ?? "")
        return true
    }
}

extension MeasurementView: SliderUpdateDelegate {

    func sliderTouch(value: Float, tag: Int) {
        print("Slider Touched: \(value)")
    }

    func sliderValueChanged(value: Float, tag: Int) {

        let amount = Int(slider.value)
        gramTF.text = String(amount)
    }

}
