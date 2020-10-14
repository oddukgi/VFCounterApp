//
//  VFTitleLabel.swift
//  VFCounter
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

    convenience init(textAlignment: NSTextAlignment, font: UIFont) {
        self.init(frame: .zero)
        self.textAlignment = textAlignment
        self.font = font
    }

    private func configure() {
        textColor                    = .label
        adjustsFontSizeToFitWidth    = true
        minimumScaleFactor           = 0.9
        lineBreakMode                = .byTruncatingTail
        translatesAutoresizingMaskIntoConstraints = false
    }

}
