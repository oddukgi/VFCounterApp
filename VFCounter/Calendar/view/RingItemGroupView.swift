//
//  RingItemGrouopView.swift
//  CalendarApp
//
//  Created by Sunmi on 2020/09/09.
//  Copyright © 2020 creativeSun. All rights reserved.
//

import UIKit
import MKRingProgressView

class RingItemGroupView: UIView {

    let ring1 = RingProgressView()
    let ring2 = RingProgressView()
    
    let iconRing = UIView()

    var addThumbImage: Bool = false
    
    @IBInspectable var ring1StartColor: UIColor = .green {
        didSet {
            ring1.startColor = ring1StartColor
        }
        
    }
    
    @IBInspectable var ring1EndColor: UIColor = .green {
        didSet {
            ring1.endColor = ring1EndColor
        }
    }

    @IBInspectable var ring2StartColor: UIColor = .green {
        didSet {
            ring2.startColor = ring2StartColor
        }
        
    }
    @IBInspectable var ring2EndColor: UIColor = .green {
        didSet {
            ring2.endColor = ring2EndColor
        }
        
    }

    @IBInspectable var ringWidth: CGFloat = 10 {
        didSet {
            ring1.ringWidth = ringWidth
            ring2.ringWidth = ringWidth
            setNeedsLayout()
        }
    }
    
    @IBInspectable var ringSpacing: CGFloat = 2{
        didSet {
            setNeedsLayout()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        addSubViews(ring1, ring2)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        ring1.frame = bounds
        ring2.frame = bounds.insetBy(dx: ringWidth + ringSpacing, dy: ringWidth + ringSpacing)

    }
}


