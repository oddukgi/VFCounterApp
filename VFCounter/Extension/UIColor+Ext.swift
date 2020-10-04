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
    static let middleGreen    = UIColor(hexString: "37937C")
    static let greyBlue       = UIColor(hexString: "78ACA3")
    static let iceBlue        = UIColor(hexString: "EFF8F8")
    static let dimmedGrey     = UIColor(hexString: "D0D3D9")
    static let lightGreyBlue  = UIColor(hexString: "B3B8B7")
 
   
    static let brownGrey      = UIColor(hexString: "959595")
    static let lightKhaki     = UIColor(hexString: "E1E6A9")

    static let pineGreen      = UIColor(hexString: "3A594D")
    static let jadeGreen      = UIColor(hexString: "2DAD64")
    static let weirdGreen     = UIColor(hexString: "4BD185")
    
    static let dimmedBlack    = UIColor(white: 0.0, alpha: 0.1)
    static let lightlightGrey = UIColor(hexString: "DADADA")
    static let orangeyRed     = UIColor(hexString: "FF5722")

    struct MilkChocolate {
        static let origin  = UIColor(hexString: "603519")
        static let alpha60 = UIColor(red: 96.0 / 255.0, green: 53.0 / 255.0, blue: 25.0 / 255.0, alpha: 0.6)
        static let button  = UIColor(hexString: "60371A")
    }
    
    static let switchWhite = UIColor(hexString: "E9E9EB")
    static let separator   = UIColor(white: 0.0, alpha: 0.22)
    static let lightBlue  = UIColor(hexString: "00BCD4")
}

struct SliderColor {
    static let greenishTeal      = UIColor(hexString: "27D158")
    static let orangeyRed        = UIColor(red: 1.0, green: 87.0 / 255.0, blue: 34.0 / 255.0, alpha: 1.0)
    static let maximumTrackTint  = UIColor(red: 205.0 / 255.0, green: 206.0 / 255.0, blue: 208.0 / 255.0, alpha: 1.0)

}

struct RingColor {
    static let ringGreen    = UIColor(hexString: "04D48C")
    static let ringYellow   = UIColor(hexString: "FECD01")
    static let trackGreen   = UIColor(red: 47.0 / 255.0, green: 181.0 / 255.0, blue: 73.0 / 255.0, alpha: 0.12)
    static let trackBeige   = UIColor(hexString: "FEF8D8")
    
}


enum ShadowColor {    
    static let black = UIColor(white: 0.0, alpha: 0.24)
}

struct ChartColor {
    static let veggieGreen = UIColor(hexString: "2ECC71")
    static let fruitYellow = UIColor(hexString: "F1C40F")  
}


struct SegmentColor {
    static let primary = ColorHex.weirdGreen
    static let secondary = ColorHex.weirdGreen.withAlphaComponent(0.9) // .74
    static let tertiery =  ColorHex.weirdGreen.withAlphaComponent(0.7) // .42
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
