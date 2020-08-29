//
//  UIFont+Ext.swift
//  VFCounter
//
//  Created by Sunmi on 2020/07/27.
//  Copyright © 2020 creativeSun. All rights reserved.
//

import UIKit

enum NanumSquareRound: String {
    
    case regular = "NanumSquareRoundR"
    case bold = "NanumSquareRoundB"
    case extrabold = "NanumSquareRoundEB"
    case light = "NanumSquareRoundL"

    func style(sizeOffset: CGFloat = 0) -> UIFont {
      let size = sizeOffset
      return UIFont(name: rawValue, size: size)!
    }

}

//SeN-CM, SeN-CBL, SeN-CEB, SeN-CB,SeN-CL
enum Seoulnamsan: String {
    
    case light      = "SeN-CL"
    case medium     = "SeN-CM"
    case bold       = "SeN-CB"
    case boldlight  = "SeN-CBL"
    case extrabold  = "SeN-CEB"
    
    func style(offset: CGFloat = 0) -> UIFont {
        let size = offset
        return UIFont(name: rawValue, size: size)!
    }
}
