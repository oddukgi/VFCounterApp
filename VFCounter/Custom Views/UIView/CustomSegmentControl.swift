//
//  CustomSegmentControl.swift
//  VFCounter
//
//  Created by Sunmi on 2020/08/13.
//  Copyright © 2020 creativeSun. All rights reserved.
//

import UIKit

// rounded corner radius
// refer to https://stackoverflow.com/questions/58315497/selectedtintcolor-of-segment-control-is-not-rounded-corner-on-ios-13

class CustomSegmentControl: UISegmentedControl {
    
    
    @IBInspectable var backgroudClr: UIColor = UIColor.white {
         didSet {
              backgroundColor = backgroudClr
         }
     }

     @IBInspectable var tintClr: UIColor = UIColor.black {
          didSet {
             tintColor = tintClr
         }
     }

     @IBInspectable var selectedSegmentTintClr: UIColor = UIColor.black {
         didSet {
            selectedSegmentTintColor = selectedSegmentTintClr
         }
     }
    

    override func layoutSubviews() {
        super.layoutSubviews()
        
//        if #available(iOS 13.0, *) {
//            selectedSegmentTintColor = ColorHex.jadeGreen
//        } else {
//            tintColor = .clear
//        }

         layer.masksToBounds = true
        //corner radius
        
//        print(bounds.height)
        let maskedCorners: CACornerMask = [.layerMinXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        //background
        clipsToBounds = true
        layer.cornerRadius = bounds.height / 2
        layer.maskedCorners = maskedCorners

        let foregroundIndex = numberOfSegments
        if subviews.indices.contains(foregroundIndex),
            let foregroundImageView = subviews[foregroundIndex] as? UIImageView {
            foregroundImageView.image = UIImage()
            foregroundImageView.clipsToBounds = true
            foregroundImageView.layer.masksToBounds = true
            foregroundImageView.backgroundColor = selectedSegmentTintColor
            
            foregroundImageView.layer.cornerRadius = (bounds.height / 2) + 7
            foregroundImageView.layer.maskedCorners = maskedCorners
        }
        
    }


}

