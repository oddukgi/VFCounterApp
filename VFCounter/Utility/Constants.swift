//
//  utility.swift
//  VFCounter
//
//  Created by Sunmi on 2020/07/15.
//  Copyright © 2020 creativeSun. All rights reserved.
//

import UIKit

enum StackViewLayout {
    static let padding: CGFloat = 20.0
    static let stackViewHeight: CGFloat = 50.0
}

enum ScreenSize {
    static let width                    = UIScreen.main.bounds.size.width
    static let height                   = UIScreen.main.bounds.size.height
    static let maxLength                = max(ScreenSize.width, ScreenSize.height)
    static let minLength                = min(ScreenSize.width, ScreenSize.height)
}

enum DeviceTypes {
    static let idiom                    = UIDevice.current.userInterfaceIdiom
    static let nativeScale              = UIScreen.main.nativeScale
    static let scale                    = UIScreen.main.scale

    static let isiPhoneSE               = idiom == .phone && ScreenSize.maxLength == 568.0
    static let isiPhone8Standard        = idiom == .phone && ScreenSize.maxLength == 667.0 && nativeScale == scale
    static let isiPhone8Zoomed          = idiom == .phone && ScreenSize.maxLength == 667.0 && nativeScale > scale
    static let isiPhone8PlusStandard    = idiom == .phone && ScreenSize.maxLength == 736.0
    static let isiPhone8PlusZoomed      = idiom == .phone && ScreenSize.maxLength == 736.0 && nativeScale < scale
    static let isiPhoneX                = idiom == .phone && ScreenSize.maxLength == 812.0
    static let isiPhoneXsMaxAndXr       = idiom == .phone && ScreenSize.maxLength == 896.0
    static let isiPhone12               = idiom == .phone && ScreenSize.maxLength == 844.0
    static let isiPhone12Pro            = idiom == .phone && ScreenSize.maxLength == 844.0
    static let isiPhone12ProMax         = idiom == .phone && ScreenSize.maxLength == 926.0

    static let isiPad                   = idiom == .pad && ScreenSize.maxLength >= 1024.0

    static func isiPhoneXAspectRatio() -> Bool {
        return isiPhoneX || isiPhoneXsMaxAndXr
    }
}

enum Images {
    static let placeHolder              = UIImage(named: "smilingsun")
}

/*
 6.7” (428 x 926 points @3x)
 iPhone 12 Pro Max
 6.5” (414 x 896 points @3x)
 iPhone 11 Pro Max, iPhone XS Max
 6.1” (390 x 844 points @3x)
 iPhone 12 Pro, iPhone 12
 6.1” (414 x 896 points @2x)
 iPhone 11, iPhone XR
 5.8” (375 - 812 points @3x)
 iPhone 11 Pro, iPhone XS, iPhone X
 5.5” (414 x 736 points @3x)
 iPhone 8 Plus, iPhone 7 Plus, iPhone 6S Plus
 5.4” (375 x 812 points @3x)
 iPhone 12 mini
 4.7” (375 x 667 points @2x)
 iPhone SE (2nd Gen), iPhone 8, iPhone 7, iPhone 6S
 4” (320 x 568 @2x)
 iPhone SE (1st Gen), iPod Touch (7th Gen)
 */
