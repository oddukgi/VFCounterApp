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
        outerSlider.isUserInteractionEnabled = false
        insideSlider.isUserInteractionEnabled = false
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func updateValue(amount: Int, tag: Int) {
        
        switch tag {
        case 0:          
            outerSlider.endPointValue = CGFloat(amount)
            totVeggieLabel.text = "\(amount)g"
//          print("\(totalVeggies)g")
            
        default:         
            insideSlider.endPointValue = CGFloat(amount)
            totFruitLabel.text = "\(amount)g"
//          print("\(totalFruits)g")
       }

    }

}

//            if CGFloat(totalVeggies + amount) > outerSlider.maximumValue { return false }
//            if CGFloat(totalFruits + amount) > insideSlider.maximumValue { return false }
