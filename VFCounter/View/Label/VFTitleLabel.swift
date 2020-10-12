//
//  VFTitleLabel.swift
//  DrinkCounter
//
//  Created by Sunmi on 2020/06/03.
//  Copyright © 2020 CreativeSuns. All rights reserved.
//

import UIKit

class VFTitleLabel: UILabel {

    /// designated initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // default value : 2 param.
    // no need to call all param. 
    convenience init(textAlignment: NSTextAlignment, fontSize: CGFloat) {
        self.init(frame: .zero)
        self.textAlignment = textAlignment
        self.font = UIFont.systemFont(ofSize: fontSize, weight: .semibold)

    }

    private func configure() {
        textColor                    = .label
        adjustsFontSizeToFitWidth    = true
        minimumScaleFactor           = 0.9
        lineBreakMode                = .byTruncatingTail
        translatesAutoresizingMaskIntoConstraints = false
    }

}
