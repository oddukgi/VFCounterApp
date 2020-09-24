//
//  VFCircularView.swift
//  VFCounter
//
//  Created by Sunmi on 2020/07/23.
//  Copyright © 2020 creativeSun. All rights reserved.
//

import UIKit

class VFCircularView: UIView {
    
    // TODO: create circular view & calculate the value of each item
      
    // circle
    lazy var veggieCircle: Ring = {
        let view = Ring(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        view.mainColor = RingColor.ringGreen
        view.ringColor = RingColor.ringGreen
        return view
    }()
    
    lazy var fruitsCircle: Ring = {
        let view = Ring(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        view.mainColor = RingColor.ringYellow
        view.ringColor = RingColor.ringYellow
        return view
    }()
    
    

    lazy var lbveggie: UILabel = {
        let lbl = UILabel(frame: .zero)
        lbl.textAlignment = .center
        lbl.textColor = ColorHex.brownGrey
        lbl.font = UIFont.systemFont(ofSize: 13)
        lbl.text = "야채"
        lbl.numberOfLines = 0
        return lbl
    }()
    
    lazy var lbFruits: UILabel = {
        let lbl = UILabel(frame: .zero)
        lbl.textAlignment = .center
        lbl.textColor = ColorHex.brownGrey
        lbl.font = UIFont.systemFont(ofSize: 13)
        lbl.text = "과일"
        lbl.numberOfLines = 0
        return lbl
    }()
    
    // value
    lazy var totVeggieLabel: UILabel = {
        let lbl = UILabel(frame: .zero)
        lbl.textAlignment = .center
        lbl.font = UIFont.systemFont(ofSize: 13)
        lbl.text = " g"
        lbl.numberOfLines = 0
        return lbl
    }()
    
    lazy var totFruitLabel: UILabel = {
        let lbl = UILabel(frame: .zero)
        lbl.textAlignment = .center
        lbl.font = UIFont.systemFont(ofSize: 13)
        lbl.text = " g"
        lbl.numberOfLines = 0
        return lbl
    }()
    
    
    var horizontalStackView = Array<UIStackView>()
    var ringView: MainRingView!
            
    override init(frame: CGRect) {
        super.init(frame: frame)
        setCircularView()
        setsubviewLayout()      
      
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func updateValue(veggieSum: Int, fruitSum: Int) {
        
        ringView.ringProgressView.ring1.progress = Double(veggieSum) / 500.0
        ringView.ringProgressView.ring2.progress = Double(fruitSum) / 500.0
        totVeggieLabel.text = "\(veggieSum)g"
        totFruitLabel.text = "\(fruitSum)g"
    }

}

//            if CGFloat(totalVeggies + amount) > outerSlider.maximumValue { return false }
//            if CGFloat(totalFruits + amount) > insideSlider.maximumValue { return false }
