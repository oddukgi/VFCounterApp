//
//  UILabel+Ext.swift
//  VFCounter
//
//  Created by Sunmi on 2020/07/27.
//  Copyright © 2020 creativeSun. All rights reserved.
//

import UIKit

extension UILabel {
   
    func setSubTextColor(basefont: UIFont, subfont: UIFont, text: String, baseColor: UIColor, specificColor: UIColor, location: Int,
                                    length: Int) {

        let attributedString = NSMutableAttributedString(string: text, attributes: [
            .font: basefont,
            .foregroundColor: baseColor
        ])

        attributedString.addAttributes([
            .font: subfont,
            .foregroundColor: specificColor
        ], range: NSRange(location: location, length: length))

        self.attributedText = attributedString
    }
}


