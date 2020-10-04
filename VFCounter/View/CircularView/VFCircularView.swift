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
        let view = Ring(frame: CGRect(x: 0, y: 0, width: 15, height: 15))
        view.mainColor = RingColor.ringGreen
        view.ringColor = RingColor.ringGreen
        return view
    }()
    
    lazy var fruitsCircle: Ring = {
        let view = Ring(frame: CGRect(x: 0, y: 0, width: 15, height: 15))
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
    private var privateMaxVeggie = 0
    private var privateMaxFruit = 0
            
    override init(frame: CGRect) {
        super.init(frame: frame)
        setCircularView()
        setsubviewLayout()      
      
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func updateValue(veggieSum: Int, fruitSum: Int) {
        
        let maxVeggie = Int(ringView.maxVeggies)
        let maxFruit = Int(ringView.maxFruits)
        ringView.ringProgressView.ring1.progress = Double(veggieSum) / Double(maxVeggie)
        ringView.ringProgressView.ring2.progress = Double(fruitSum) / Double(maxFruit)
        
        totVeggieLabel.text = "\(veggieSum)g / \(maxVeggie)g"
        totFruitLabel.text =  "\(fruitSum)g / \(maxFruit)g"
    }
    
    
    func updateMaxValue(tag: Int) {
        let maxVeggie = Int(ringView.maxVeggies)
        let maxFruit = Int(ringView.maxFruits)
        
        var totVeggie = totVeggieLabel.text ?? ""
        var totFruits = totFruitLabel.text ?? ""
        
        if tag == 0 {
            var arrayV = totVeggie.components(separatedBy: "/")
            arrayV[1] = " \(maxVeggie)g"
            totVeggieLabel.text = arrayV.joined(separator: "/")
        } else {
            
            var arrayF = totFruits.components(separatedBy: "/")
            arrayF[1] = " \(maxFruit)g"
            totFruitLabel.text = arrayF.joined(separator: "/")
        }
        
      
    }

}

//            if CGFloat(totalVeggies + amount) > outerSlider.maximumValue { return false }
//            if CGFloat(totalFruits + amount) > insideSlider.maximumValue { return false }
