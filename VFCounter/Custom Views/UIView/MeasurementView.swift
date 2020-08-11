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
    func setAmount(amount: Int)
    func showDatePickerVC()
}

class MeasurementView: UIView {

    lazy var labelStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill

       return stackView
    }()
    
    lazy var gramTF: VFTextField = {
        let textField = VFTextField(frame: CGRect(x: 0, y: 0, width: 95, height: 30))
//        textField.cornerRadius(8)
        textField.borderWidth(1)
        textField.borderColor(ColorHex.MilkChocolate.alpha60)
        textField.textColor(ColorHex.MilkChocolate.origin)
        textField.keyboardType = .numbersAndPunctuation
        textField.delegate = self
        textField.font = NanumSquareRound.bold.style(sizeOffset: 15)
        textField.isUserInteractionEnabled  = true
        textField.textAlignment = NSTextAlignment.center
        textField.returnKeyType = UIReturnKeyType.done
        
        return textField
    }()
    
    
    lazy var lblUnit: VFBodyLabel = {
        let label = VFBodyLabel(textAlignment: .center, fontSize: 0, fontColor: ColorHex.MilkChocolate.origin)
        label.font = NanumSquareRound.regular.style(sizeOffset: 15)
        return label
    }()
    
    lazy var btnStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
       return stackView
    }()
    
    lazy var btnPlus: VFButton = {
        let button = VFButton(frame: CGRect(x: 0, y: 0, width: 26, height: 26))
        button.makeCircle(borderColor: ColorHex.MilkChocolate.button, borderWidth: 1.0,name: "sliderPlus")
        return button
    }()
    
    lazy var btnMinus: VFButton = {
        let button = VFButton(frame: CGRect(x: 0, y: 0, width: 26, height: 26))
        button.makeCircle(borderColor: ColorHex.MilkChocolate.button, borderWidth: 1.0,name: "sliderMinus")
        return button
    }()
    
    let slider = CustomSlider(step: 10)
    
    lazy var btnDateTime: VFButton = {
        let button = VFButton(frame: CGRect(x: 0, y: 0, width: 160, height: 55))
        button.layer.cornerRadius = 5
        button.backgroundColor    = ColorHex.dimmedBlack
        button.setFont(clr: ColorHex.MilkChocolate.origin, font: NanumSquareRound.bold.style(sizeOffset: 14))
        return button
    }()

    
    private var sliderWidth: CGFloat = 0
    private var step: Float = 10
    var delegate: MeasurementViewDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setSlider()
        setLayout()
        createAction()
    }
    
    convenience init(delegate: MeasurementViewDelegate) {
        self.init()
        self.delegate = delegate
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    func setSlider() {
    
        let width = ScreenSize.width
        let btnWidt: CGFloat = 25
        let padding: CGFloat = (btnWidt * 2.0) + CGFloat(25)
        
        sliderWidth = width - padding
        slider.values(min: 0, max: 1500, current: 100)
        slider.delegate = self
        slider.thumbTintColor(.white)
        slider.minimumTrackTintColor(ColorHex.MilkChocolate.origin)
        slider.maximumTrackTintColor(SliderColor.maximumTrackTint)
        slider.isContinuous = true
    }

    func setLayout() {
        
        addSubViews(labelStackView, btnStackView, slider, btnDateTime)

        gramTF.placeholderText("100")
        lblUnit.text = "g"
        
        labelStackView.addArrangedSubview(gramTF)
        labelStackView.addArrangedSubview(lblUnit)
    
        labelStackView.snp.makeConstraints { make in
            make.top.equalTo(self).offset(20)
            make.centerX.equalTo(self)
            make.width.equalTo(120)
            make.height.equalTo(30)
        }
        
        let spacing = sliderWidth - 30

        btnStackView.addArrangedSubview(btnMinus)
        btnStackView.addArrangedSubview(btnPlus)
        btnStackView.spacing = spacing

        let yPos = labelStackView.frame.maxY
        let padding = yPos + 70
        btnStackView.snp.makeConstraints { make in
           make.top.equalTo(self).offset(padding)
           make.centerX.equalTo(self)
        }

        slider.snp.makeConstraints { make in
            make.top.equalTo(self).offset(padding - 10)
            make.centerX.equalTo(self.snp.centerX)
            make.width.equalTo(spacing  - 25)
            make.height.equalTo(42)
        }
        
        btnDateTime.snp.makeConstraints { make in
            make.top.equalTo(slider.snp.bottom).offset(17)
            make.centerX.equalTo(self)
           
        }
        
        let dateConverter = DateConverter(date: Date())

        if btnDateTime.titleLabel?.text == nil {

            let selectedDate = dateConverter.stringDT
            btnDateTime.setTitle(selectedDate, for: .normal)
        }

    }

    
    func createAction() {
        btnMinus.addTarget(self, action: #selector(makeDownAmount), for: .touchUpInside)
        btnPlus.addTarget(self, action: #selector(makeUpAmount), for: .touchUpInside)
        btnDateTime.addTarget(self, action: #selector(didChangeDate), for: .touchUpInside)
    }
    
    
    @objc func makeDownAmount() {
        
        let value = slider.value
        slider.value = value - 10
        updateTextField()
    }
    
    @objc func makeUpAmount() {
        let value = slider.value
        slider.value = value + 10
        updateTextField()
    }
    
    @objc func didChangeDate(sender: UIButton) {
        // delegate로 PickItemVC의 메소드 호출
        delegate?.showDatePickerVC()
        
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
            print("Slider Value: \(roundedValue)")
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
        let amount = Int(value)
        delegate?.setAmount(amount: amount)
        updateTextField()
    }

}

