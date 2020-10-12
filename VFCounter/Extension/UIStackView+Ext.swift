//
//  UIStackView+Ext.swift
//  VFCounter
//
//  Created by Sunmi on 2020/08/22.
//  Copyright © 2020 creativeSun. All rights reserved.
//

import UIKit

extension UIStackView {

    func addHorizontalSeperators(color: UIColor) {

        var i = self.arrangedSubviews.count
        while i >= 0 {
            let separator = createSeparator(color: color)
            insertArrangedSubview(separator, at: i)
            separator.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1).isActive = true
            i -= 1
        }
    }

    private func createSeparator(color: UIColor) -> UIView {
        let separator = UIView()
        separator.heightAnchor.constraint(equalToConstant: 1).isActive = true
        separator.backgroundColor = color
        return separator
    }

}
