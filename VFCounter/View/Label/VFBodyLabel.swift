//
//  VFBodyLabel.swift
//  DrinkCounter
//
//  Created by Sunmi on 2020/06/03.
//  Copyright © 2020 CreativeSuns. All rights reserved.
//

import UIKit

class VFBodyLabel: UILabel {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    convenience init(textAlignment: NSTextAlignment, fontSize: CGFloat, fontColor: UIColor) {
        self.init(frame: .zero)
        self.textAlignment = textAlignment
        font               = UIFont.systemFont(ofSize: fontSize, weight: .regular)
        textColor          = fontColor

    }

    // MARK: - Accessibility : change font size when device's content size change
    private func configure() {
        textColor                                 = .secondaryLabel
        font                                      = UIFont.preferredFont(forTextStyle: .body)
        adjustsFontSizeToFitWidth                 = true
        adjustsFontForContentSizeCategory         = true
        minimumScaleFactor                        = 0.75
        lineBreakMode                             = .byWordWrapping
        translatesAutoresizingMaskIntoConstraints = false
    }
}

/*:
 `adjustsFontForContentSizeCategory`
 
 A Boolean that indicates whether the object automatically updates
 its font when the device's content size category changes.
 */
