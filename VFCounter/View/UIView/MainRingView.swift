//
//  MainRingView.swift
//  VFCounter
//
//  Created by Sunmi on 2020/09/24.
//  Copyright © 2020 creativeSun. All rights reserved.
//

import UIKit

class MainRingView: UIView {

    var ringProgressView: RingItemGroupView!
 
    var contentMargin: CGFloat = 2 {
        didSet {
            setNeedsLayout()
        }
    }
    
    var isRingHidden: Bool = false {
         didSet{
            ringProgressView.ring1.isHidden = self.isRingHidden
            ringProgressView.ring2.isHidden = self.isRingHidden
        }
     }
    
    
    private var max1: Double = 0.0
    private var max2: Double = 0.0
    
    var maxVeggies: Double {
        set {
            max1 = newValue
        }
        get {
            return max1
        }
    }
    
    var maxFruits: Double {
        
        set {
            max2 = newValue
        }
        
        get {
            return max2
        }
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
  
    }

    func configure() {
        
        ringProgressView = RingItemGroupView(frame: .zero)
        addSubview(ringProgressView)
       
        ringProgressView.isUserInteractionEnabled = false
        ringProgressView.ringWidth = SizeManager().sliderWidth
        ringProgressView.ringSpacing = 2
        ringProgressView.ring1StartColor = RingColor.ringGreen
        ringProgressView.ring1EndColor = RingColor.trackGreen
        ringProgressView.ring2StartColor = RingColor.ringYellow
        ringProgressView.ring2EndColor = RingColor.trackBeige
        
        ringProgressView.ring1.hidesRingForZeroProgress = true
        ringProgressView.ring2.hidesRingForZeroProgress = true
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        let size = min(bounds.width, bounds.height) - contentMargin * 2
        ringProgressView.frame = CGRect(x: (bounds.width - size)/2, y: (bounds.height - size)/2, width: size, height: size)
//        print("Size: \(size), x Pos: \((bounds.width - size)/2)")
    }
    
    func updateRingValue(veggieSum: Int, fruitSum: Int) {
        ringProgressView.ring1.progress = Double(veggieSum) / 500.0
        ringProgressView.ring2.progress = Double(fruitSum) / 500.0
    }
}
