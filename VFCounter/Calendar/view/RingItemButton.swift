//
//  RingItemButton.swift
//  CalendarApp
//
//  Created by Sunmi on 2020/09/09.
//  Copyright © 2020 creativeSun. All rights reserved.
//

import UIKit

class RingItemButton: UIButton {

    let ringProgressView = RingItemGroupView()
    let selectionIndicatorView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))

    var contentMargin: CGFloat = 2 {
        didSet {
            setNeedsLayout()
        }
    }

    var isRingHidden: Bool = false {
         didSet {
            ringProgressView.ring1.isHidden = self.isRingHidden
            ringProgressView.ring2.isHidden = self.isRingHidden
        }
     }

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        configureRing()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func configure() {
        addSubViews(selectionIndicatorView, ringProgressView)
        selectionIndicatorView.isUserInteractionEnabled = false
        selectionIndicatorView.backgroundColor = .clear
        selectionIndicatorView.layer.masksToBounds = false
        selectionIndicatorView.layer.shadowColor = UIColor.systemBlue.cgColor
        selectionIndicatorView.layer.shadowOpacity = 1.0
        selectionIndicatorView.layer.shadowRadius = 1.0
        selectionIndicatorView.layer.shadowOffset = CGSize(width: 0, height: 0)
        selectionIndicatorView.isHidden = true
        ringProgressView.isUserInteractionEnabled = false
    }

    func configureRing() {
        ringProgressView.ringWidth = 3.5
        ringProgressView.ringSpacing = 1
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
        selectionIndicatorView.frame = ringProgressView.frame

        selectionIndicatorView.layer.shadowPath = CGPath(__byStroking: UIBezierPath(ovalIn: selectionIndicatorView.bounds.insetBy(dx: -1, dy: -1)).cgPath, transform: nil, lineWidth: 1.0, lineCap: .round, lineJoin: .round, miterLimit: 0)
    }

    override var isHighlighted: Bool {
        didSet {
            ringProgressView.alpha = isHighlighted ? 0.3 : 1.0
        }
    }

    override var isSelected: Bool {
        didSet {
            selectionIndicatorView.isHidden = !isSelected
        }
    }
}
