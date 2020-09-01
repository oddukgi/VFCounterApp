//
//  MeasurementView.swift
//  VFCounter
//
//  Created by Sunmi on 2020/08/10.
//  Copyright © 2020 creativeSun. All rights reserved.
//

import UIKit
import SnapKit


protocol MeasurementViewDelegate: class {

}

class MeasurementView: UIView {

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
        textField.delegate = self
        return textField
    }()
    
    lazy var lblUnit: VFBodyLabel = {
        let label = VFBodyLabel(textAlignment: .center, fontSize: 0, fontColor: ColorHex.MilkChocolate.origin)
        label.font = NanumSquareRound.bold.style(sizeOffset: 15)
        return label
    }()

    
    let slider = CustomSlider(step: 10)
    let userDTView = UserDateTimeView()
    
    private var sliderWidth: CGFloat = 0
    private var step: Float = 10
    weak var delegate: MeasurementViewDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setSlider()
        setLayout()
        createDismissKeyboardTapGesture()
    }
    
    convenience init(delegate: MeasurementViewDelegate) {
        self.init()
        self.delegate = delegate
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
        slider.values(min: 0, max: 500, current: 10)
        slider.delegate = self
        slider.thumbTintColor(.white)
        slider.minimumTrackTintColor(ColorHex.MilkChocolate.origin)
        slider.maximumTrackTintColor(SliderColor.maximumTrackTint)
        slider.isContinuous = true
    }

    func setLayout() {
        
        addSubViews(labelStackView, slider, userDTView)

        gramTF.placeholderText("100")
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
        
        userDTView.snp.makeConstraints { make in
            make.top.equalTo(slider.snp.bottom).offset(20)
            make.leading.equalTo(self).offset(20)
            make.trailing.equalTo(self).offset(-20)
            make.bottom.equalTo(self).offset(-30)
        }
        
//        userDTView.layer.borderWidth = 1
        gramTF.text = "\(Int(slider.value))"

    }
    
    func updateTextField() {
        let amount = Int(slider.value)
        gramTF.text = String(amount)
    }
    
    
    func judgetTextHasNumber(texts:String) -> Bool{
        let scan:Scanner = Scanner.init(string: texts)
       // return scan.scanFloat(&value) && scan.isAtEnd
        return (scan.scanFloat(representation: .decimal) != nil)  && scan.isAtEnd
    }
    
    func checkAmountTF() {
        let currentText:NSString = gramTF.text! as NSString
        if !self.judgetTextHasNumber(texts: currentText as String){
          
            return
        }
        gramTF.resignFirstResponder()
       
        let amount = currentText.floatValue
        if slider.minimumValue <= amount && slider.maximumValue >= amount {

        let roundedValue = round(amount / step) * step
            slider.value = roundedValue
            gramTF.text = String(Int(roundedValue))
            
        } else {
            gramTF.text = "0"
            slider.value = 0
   
        }
    }
}

extension MeasurementView: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.checkAmountTF()
        return true
    }
}

extension MeasurementView: SliderUpdateDelegate {
    
    func sliderTouch(value: Float, tag: Int) {
        print("Slider Touched: \(value)")
    }
    
    func sliderValueChanged(value: Float, tag: Int) {
        updateTextField()
    }

}

