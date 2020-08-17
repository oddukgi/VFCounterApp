//
//  UISegmentControl+Ext.swift
//  VFCounter
//
//  Created by Sunmi on 2020/08/13.
//  Copyright © 2020 creativeSun. All rights reserved.
//

import UIKit

// Refer to: https://stackoverflow.com/questions/9029760/how-to-change-font-color-of-uisegmentedcontrol

extension UISegmentedControl {
    
    func initConfiguration(font: UIFont = UIFont.systemFont(ofSize: 12), color: UIColor = UIColor.gray){
        let defaultAttributes : [NSAttributedString.Key:Any] = [
            NSAttributedString.Key.font : font,
            NSAttributedString.Key.foregroundColor : color
        ]
        
        setTitleTextAttributes(defaultAttributes, for: .normal)
    }
    
    func selectedConfiguration(font: UIFont = UIFont.systemFont(ofSize: 12), color: UIColor = UIColor.systemBlue) {
        let selectedAttributes: [NSAttributedString.Key:Any] = [
            NSAttributedString.Key.font:font,
            NSAttributedString.Key.foregroundColor:color
        ]
        setTitleTextAttributes(selectedAttributes, for: .selected)
    }
}
