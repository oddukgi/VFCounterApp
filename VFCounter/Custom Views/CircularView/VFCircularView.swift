//
//  VFCircularView.swift
//  VFCounter
//
//  Created by Sunmi on 2020/07/23.
//  Copyright © 2020 creativeSun. All rights reserved.
//

import UIKit
import HGCircularSlider

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
    private var totalVeggies = 0
    private var totalFruits = 0
    
    lazy var outerSlider: CircularSlider = {
        let slider = CircularSlider()
        slider.lineWidth = SizeManager().sliderWidth
        slider.backtrackLineWidth = SizeManager().sliderWidth
        slider.diskFillColor = UIColor.clear
        slider.diskColor = UIColor.clear
        slider.trackFillColor = RingColor.ringGreen
        slider.trackColor = RingColor.trackGreen
        slider.backgroundColor = .clear
        slider.thumbRadius = 8
        slider.endThumbStrokeHighlightedColor = UIColor.orange
        slider.endThumbTintColor              = .clear
        slider.endThumbStrokeColor            = .clear
        slider.endThumbStrokeHighlightedColor = .white
        slider.maximumValue   = 500.0
        slider.minimumValue   = 0.0
        
//        slider.layer.borderWidth = 1
        return slider
    }()
        
    lazy var insideSlider: CircularSlider = {
        let slider = CircularSlider()
        slider.lineWidth = SizeManager().sliderWidth
        slider.backtrackLineWidth = SizeManager().sliderWidth
        slider.diskFillColor = UIColor.clear
        slider.diskColor = UIColor.clear
        slider.trackFillColor = RingColor.ringYellow
        slider.trackColor = RingColor.trackBeige
        slider.backgroundColor = .clear
        slider.thumbRadius = 8
        slider.endThumbStrokeHighlightedColor = UIColor.black
        slider.endThumbTintColor              = .clear
        slider.endThumbStrokeColor            = .clear
        
        //        slider.endThumbStrokeHighlightedColor = .white
        slider.maximumValue   = 500.0
        slider.minimumValue   = 0.0
//        slider.layer.borderWidth = 1
        return slider
    }()
            
    override init(frame: CGRect) {
        super.init(frame: frame)
        setCircularView()
        setsubviewLayout()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func updateValue(amount: Int, tag: Int) -> Bool {
        
        switch tag {
        case 0:          
            totalVeggies += amount
            outerSlider.endPointValue = CGFloat(totalVeggies)
            totVeggieLabel.text = "\(totalVeggies)g"
//          print("\(totalVeggies)g")
            
        default:         
            totalFruits += amount
            insideSlider.endPointValue = CGFloat(totalFruits)
            totFruitLabel.text = "\(totalFruits)g"
//          print("\(totalFruits)g")
       }
        
        return true
    }

}

//            if CGFloat(totalVeggies + amount) > outerSlider.maximumValue { return false }
//            if CGFloat(totalFruits + amount) > insideSlider.maximumValue { return false }
