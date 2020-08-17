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
      
    lazy var veggieCircle: Ring = {
        let view = Ring(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        view.mainColor = ColorHex.veggieGreen
        view.ringColor = ColorHex.veggieGreen
        return view
    }()
    
    lazy var fruitsCircle: Ring = {
        let view = Ring(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        view.mainColor = ColorHex.lemon
        view.ringColor = ColorHex.lemon
        return view
    }()

    lazy var lbveggie: UILabel = {
        let lbl = UILabel(frame: .zero)
        lbl.textAlignment = .center
        lbl.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        lbl.text = "야채"
        lbl.numberOfLines = 0
        return lbl
    }()
    
    lazy var lbFruits: UILabel = {
        let lbl = UILabel(frame: .zero)
        lbl.textAlignment = .center
        lbl.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        lbl.text = "과일"
        lbl.numberOfLines = 0
        return lbl
    }()
    
    var horizontalStackView = Array<UIStackView>()
    
    
    lazy var outerSlider: CircularSlider = {
        let slider = CircularSlider()
        slider.lineWidth = SizeManager().sliderWidth
        slider.diskFillColor = UIColor.clear
        slider.diskColor = UIColor.clear
        slider.trackFillColor = ColorHex.veggieGreen
        slider.trackColor = UIColor.clear
        slider.backgroundColor = .clear
        slider.thumbRadius = 8
        slider.endThumbStrokeHighlightedColor = UIColor.orange
        slider.endThumbTintColor              = .clear
        slider.endThumbStrokeColor            = .clear
        slider.endThumbStrokeHighlightedColor = .white
        slider.maximumValue   = 100.0
        slider.minimumValue   = 0.0
        
//        slider.layer.borderWidth = 1
        return slider
    }()
        
    lazy var insideSlider: CircularSlider = {
        let slider = CircularSlider()
        slider.lineWidth = SizeManager().sliderWidth
        slider.diskFillColor = UIColor.clear
        slider.diskColor = UIColor.clear
        slider.trackFillColor = ColorHex.lemon
        slider.trackColor = UIColor.clear
        slider.backgroundColor = .clear
        slider.thumbRadius = 8
        slider.endThumbStrokeHighlightedColor = UIColor.black
        slider.endThumbTintColor              = .clear
        slider.endThumbStrokeColor            = .clear
        //        slider.endThumbStrokeHighlightedColor = .white
        slider.maximumValue   = 100.0
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
    
    /*
     convenience init(message: String) {
         self.init(frame: .zero)
         messageLabel.text = message
     }
     
    */

}
