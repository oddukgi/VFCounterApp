//
//  UIColor+Ext.swift
//  DrinkCounter
//
//  Created by Sunmi on 2020/07/14.
//  Copyright © 2020 creativeSun. All rights reserved.
//

import UIKit



enum GradientColor {

    static let firstColor  = UIColor(hexString: "78ACA3")
    static let middleColor = UIColor(hexString: "B7D4D0").withAlphaComponent(0.3)
    static let lastColor   = UIColor(hexString: "EFF8F8")
}

struct ColorHex {
 
    static let pale           = UIColor(hexString: "FFF2D2")
    static let dullOrange     = UIColor(hexString: "D68432")
    static let lightGreen     = UIColor(hexString: "1F6151").withAlphaComponent(0.3)
    static let darkGreen      = UIColor(hexString: "1F6151")
    static let greyBlue       = UIColor(hexString: "78ACA3")
    static let iceBlue        = UIColor(hexString: "EFF8F8")
    static let dimmedGrey     = UIColor(hexString: "D0D3D9")
 
    static let vegieGreen     = UIColor(hexString: "2FB549")
    static let lemon          = UIColor(hexString: "DFCC39")
    static let brownGrey      = UIColor(hexString: "959595")
    static let lightKhaki     = UIColor(hexString: "E1E6A9")
    
    static let milkChocolate  = UIColor(hexString: "603519")
    static let pineGreen      = UIColor(hexString: "3a594d")
    static let dimmedBlack    = UIColor(white: 0.0, alpha: 0.1)
    static let lightlightGrey = UIColor(hexString: "DADADA")
    static let orangeyRed     = UIColor(hexString: "FF5722")
    
    
}

struct SliderColor {
    static let greenishTeal      = UIColor(hexString: "27D158")
    static let orangeyRed        = UIColor(red: 1.0, green: 87.0 / 255.0, blue: 34.0 / 255.0, alpha: 1.0)
    static let maximumTrackTint  = UIColor(red: 205.0 / 255.0, green: 206.0 / 255.0, blue: 208.0 / 255.0, alpha: 1.0)

}

struct RulerColor {
    static let lineColor = UIColor(hexString: "2DAD64")
    static let bgColor = UIColor(hexString: "1E1E1E")
    static let triangleColor = UIColor(hexString: "FF5722")
}


enum ShadowColor {    
    static let black = UIColor(white: 0.0, alpha: 0.24)
    
}

extension UIColor {
    
   convenience init(hexString: String) {
       let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
       var int = UInt64()
       Scanner(string: hex).scanHexInt64(&int)
       let a, r, g, b: UInt64
       switch hex.count {
       case 3: // RGB (12-bit)
           (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
       case 6: // RGB (24-bit)
           (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
       case 8: // ARGB (32-bit)
           (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
       default:
           (a, r, g, b) = (255, 0, 0, 0)
       }
       self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
   }
}
