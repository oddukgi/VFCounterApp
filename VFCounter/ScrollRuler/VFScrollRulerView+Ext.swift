//
//  VFScrollRulerView+Ext.swift
//  VFCounter
//
//  Created by Sunmi on 2020/08/03.
//  Copyright © 2020 creativeSun. All rights reserved.
//

import UIKit
import SnapKit

protocol VFScrollRulerViewDelegate: NSObjectProtocol {
    func yValueChanged(rulerView: VFScrollRulerView, value: Float)
}

class VFScrollRulerView: UIView {
    
    weak var delegate: VFScrollRulerViewDelegate?
    
    var scrollByHand = true
    var triangleColor: UIColor? = nil
    var bgColor: UIColor? = nil
    var stepNum = 0
    
    private var redLine: UIImageView?
    private var fileRealValue: Int = 0
    
    var rulerUnit: String = ""
    var minValue: Float = 0.0
    var maxValue: Float = 0.0
    var step: Float = 0.0
    var betweenNum: Int = 0
    let collectionHeight = 70
    let rulerGap         = 12
    
    var parentVC: UIViewController?
    
    let valueTextField = UITextField()
    let lblUnit = UILabel()
    var collectionView: UICollectionView!
    let triangleView = VFTriangleView()
  
    
    static let rulerViewHeight = 130

    init(frame: CGRect, minValue: Float, maxValue: Float, step: Float, unit: String, num: Int, vc: UIViewController) {
        super.init(frame: frame)
        self.minValue = minValue
        self.maxValue = maxValue
        self.betweenNum = num
        self.step = step
        let gap = Int((maxValue - minValue)/step)
        self.stepNum = gap/betweenNum
        self.rulerUnit = unit
        self.bgColor = .white
        self.parentVC = vc
        
        setLayout()
        setStyle()
        configureCollectionView()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var triangleClr: UIColor = .blue {
        didSet {
            triangleColor = triangleClr
        }
    }
    
    var bgClr: UIColor = .black {
        didSet {
            bgColor = triangleClr
        }
    }
       
}

extension VFScrollRulerView {
    
    func setLayout() {
        
        let triangleWidth = 16
        self.addSubview(valueTextField)
        self.addSubview(self.triangleView)
        self.addSubview(self.lblUnit)
 
//        valueTextField.frame = CGRect(x: self.bounds.size.width/2-60, y: 10, width: 80, height: 40)
        valueTextField.snp.makeConstraints { make in
            make.centerX.equalTo(self.snp.centerX).offset(-60)
            make.top.equalTo(self.snp.top).offset(10)
            make.width.equalTo(80)
            make.height.equalTo(40)
        }
        
        let newWidth = CGFloat(triangleWidth)/2
        triangleView.snp.makeConstraints { make in
            make.centerX.equalTo(self.snp.centerX).offset(-0.5 - newWidth)
            make.top.equalTo(valueTextField.snp.bottom).offset(valueTextField.frame.maxY)
            make.width.equalTo(triangleWidth)
            make.height.equalTo(triangleWidth)
            
        }
 
        
//        triangleView.frame  = CGRect(x: self.bounds.size.width/2-0.5 - CGFloat(triangleWidth)/2, y: valueTextField.frame.maxY, width: CGFloat(triangleWidth), height: CGFloat(triangleWidth))
        lblUnit.frame       = CGRect(x: valueTextField.frame.maxX+10, y: valueTextField.frame.minY, width: 40, height: 40)
    
 
        lblUnit.text = rulerUnit
    }
    func setStyle() {
    
        valueTextField.isUserInteractionEnabled = true
        valueTextField.defaultTextAttributes = [NSAttributedString.Key.font :
            NanumSquareRound.regular.style(sizeOffset: 19)]
        valueTextField.textAlignment = .right
        valueTextField.delegate = self
        valueTextField.keyboardType = .numberPad
        valueTextField.returnKeyType = .done

        lblUnit.textColor = .white
        lblUnit.font      = NanumSquareRound.regular.style(sizeOffset: 11)
        
        triangleView.backgroundColor = .clear
        triangleView.triangleColor = triangleClr
    }
    
    func configureCollectionView() {
    
        let flowLayout              = UICollectionViewFlowLayout()
        flowLayout.scrollDirection  = UICollectionView.ScrollDirection.horizontal
        flowLayout.sectionInset     = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
        
        collectionView = UICollectionView(frame: CGRect(x: 0, y: self.valueTextField.frame.maxY + 100, width: bounds.size.width,
                                                        height: CGFloat(collectionHeight)), collectionViewLayout: flowLayout)
        self.addSubview(collectionView)
//        collectionView.backgroundColor    = UIColor.blue
        collectionView.bounces            = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.delegate   = self
        collectionView.dataSource = self
        
        collectionView.register(HeaderCell.self, forCellWithReuseIdentifier: HeaderCell.reuseIdentifier)
        collectionView.register(FooterCell.self, forCellWithReuseIdentifier: FooterCell.reuseIdentifier)
        collectionView.register(CustomCell.self, forCellWithReuseIdentifier: CustomCell.reuseIdentifier)
    }
    
    func setRealValueAnimated(realValue: Int, animated: Bool) {
        
        fileRealValue = realValue
        let value = Int(fileRealValue) * Int(step + minValue)
        valueTextField.text = String(value)
        collectionView.setContentOffset(CGPoint(x: realValue * rulerGap, y: 0), animated: animated)
    }
    
    func setDefaultValueAnimated(defaultValue: Int, animated: Bool) {
        
        fileRealValue = defaultValue
        valueTextField.text = String(defaultValue)
        
        let newValue  = defaultValue - Int(minValue / step)
        collectionView.setContentOffset(CGPoint(x: newValue * rulerGap, y: 0), animated: animated)
    }
    
    // MARK: @objc action
    @objc func didChangedCVValue() {
        let textFieldValue = Int(valueTextField.text!)
        
        let value = textFieldValue! - Int(minValue)
        if  value >= 0 {
            self.setRealValueAnimated(realValue: value/Int(step), animated: true)
        }
    }
    
    @objc func editDone() {
        let currentText: NSString = valueTextField.text! as NSString
        
        if isTextFieldEmpty(text: currentText as String) {
            return
        }
        valueTextField.resignFirstResponder()
        
        let value = currentText.floatValue

        if value > maxValue {
            valueTextField.text = String(format: "%d", Int(maxValue))
            perform(#selector(self.didChangedCVValue),with: nil, afterDelay: 0)
        } else if value <= minValue || currentText.length == 0 {
            valueTextField.text = String(format: "%d", Int(minValue))
            perform(#selector(self.didChangedCVValue),with: nil, afterDelay: 0)
        } else {
            NSObject.cancelPreviousPerformRequests(withTarget: self)
                self.perform(#selector(self.didChangedCVValue), with: nil, afterDelay: 1)
        }
    }
    
    func isTextFieldEmpty(text: String) -> Bool {
        let scan: Scanner = Scanner(string: text)
        return (scan.scanFloat(representation: .decimal) != nil)  && scan.isAtEnd
    }
}
