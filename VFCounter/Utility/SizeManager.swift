//
//  SizeManager.swift
//  VFCounter
//
//  Created by Sunmi on 2020/08/01.
//  Copyright © 2020 creativeSun. All rights reserved.
//

import UIKit

//#define kSize CGSize(13.0, 34.0)

class SizeManager {

    init() {
    
        outerSliderSize = CGSize()
        insideSliderSize = CGSize()
        userItemSection = 0
        userItemHeight = 0
        itemTopPadding = 0
        groupTopPadding = 0

    }
    var getHeaderviewHeight: CGFloat {
        
        var height: CGFloat = 0
        if DeviceTypes.isiPhoneSE || DeviceTypes.isiPhone8Standard {
            height = 80
        } else {
            height = 100
        }
        
        return height
    }

    var circularViewHeight: CGFloat {

        var halfSize: CGFloat = ScreenSize.height / 2
        var height: CGFloat = 0
    
        if DeviceTypes.isiPhoneSE || DeviceTypes.isiPhone8Standard {
            height = halfSize - 120
        } else if DeviceTypes.isiPhone8PlusStandard {
            height = halfSize - 140
        } else if DeviceTypes.isiPhoneX {
            height = halfSize - 160
        } else {
            height = halfSize - 180
        }

        return height
    }

    func sliderSize() -> (CGSize) {
       
        if DeviceTypes.isiPhoneSE {
            outerSliderSize = CGSize(width: 140, height: 140)
        } else if DeviceTypes.isiPhone8Standard {
            outerSliderSize = CGSize(width: 170, height: 170)
        } else if DeviceTypes.isiPhone8PlusStandard || DeviceTypes.isiPhoneX {
            outerSliderSize = CGSize(width: 190, height: 190)
        } else if DeviceTypes.isiPhoneXsMaxAndXr || DeviceTypes.isiPhone12Pro {
           outerSliderSize = CGSize(width: 210, height: 210)
        } else if DeviceTypes.isiPhone12ProMax {  //92
            outerSliderSize = CGSize(width: 230, height: 230)
        }

        return (outerSliderSize)
    }

    var sliderWidth: CGFloat {
        var width: CGFloat = 0
        
        if DeviceTypes.isiPhoneSE {
            width = 13
        } else if DeviceTypes.isiPhone8Standard || DeviceTypes.isiPhoneX {
            width = 15
        } else if DeviceTypes.isiPhone8PlusStandard {
            width = 17
        } else {
            width = 18
        }

        return width
    }

    var getUserItemHeight: CGFloat {
        if DeviceTypes.isiPhoneSE {
            userItemHeight = 90
        } else if DeviceTypes.isiPhone8Standard || DeviceTypes.isiPhoneX || DeviceTypes.isiPhone8PlusStandard {
            userItemHeight = 98
        } else if DeviceTypes.isiPhoneXsMaxAndXr {
            userItemHeight = 105
        } else {
            userItemHeight = 105
        }
        return userItemHeight
    }
    
    var veggiePickCVHeight: CGFloat {
        return  DeviceTypes.isiPhone8Standard ? 190 : 130
    }

    var pickItemVCPadding: CGFloat {

        if DeviceTypes.isiPhone8Standard {
            return -80
        } else if DeviceTypes.isiPhone8PlusStandard {
            return -110
        } else if DeviceTypes.isiPhoneXsMaxAndXr {
            return -200
        } else {
            return -150
        }
    }

    /// chartview height by device screen size
    //let height = view.bounds.height - 250
    var chartHeight: CGFloat {

        var height: CGFloat = 0.0
        if DeviceTypes.isiPhoneSE || DeviceTypes.isiPhone8Standard {
            height = ScreenSize.height - 280  //387
        } else if DeviceTypes.isiPhone8PlusStandard {
            height = ScreenSize.height - 290
        } else if DeviceTypes.isiPhoneX {
            height = ScreenSize.height - 340
        } else if DeviceTypes.isiPhoneXsMaxAndXr {
            height = ScreenSize.height - 370
       } else if DeviceTypes.isiPhone12Pro {
            height = ScreenSize.height - 350
        } else if DeviceTypes.isiPhone12ProMax {  //92
            height = ScreenSize.height - 360
        }

        return height
    }
   
    var ringViewPadding: CGFloat {
        var height: CGFloat = 0.0

        if DeviceTypes.isiPhoneSE {
            height = 8
        } else if DeviceTypes.isiPhone8Standard || DeviceTypes.isiPhone8PlusStandard {
            height = 12
        } else if DeviceTypes.isiPhoneX {
            height = 16
        } else if DeviceTypes.isiPhoneXsMaxAndXr {
            height = 25
        } else if DeviceTypes.isiPhone12Pro {
            height = 20
        } else {
            height = 28
        }

        return height
    }
    
    var dateViewHeight: CGFloat {
        
        var width: CGFloat = 0.0
        
        if DeviceTypes.isiPhoneSE {
            width = 90
        } else {
            width = 120
        }
        
        return width
    }
    
    func chartAddBtnSize() -> (CGSize) {

        var btnSize: CGSize = CGSize()
        
        if DeviceTypes.isiPhoneSE {
            btnSize = CGSize(width: 33, height: 33)
        } else {
            btnSize = CGSize(width: 40, height: 40)
        }

        return (btnSize)
    }
    
    var dateViewTopPadding: CGFloat {
        var padding: CGFloat = 0.0
        
        if DeviceTypes.isiPhoneSE {
            padding = 20
        } else {
            padding = 39
        }
        
        return padding
    }
    
    var bottomLegendPadding: CGFloat {
        var padding: CGFloat = 0.0
        
        if DeviceTypes.isiPhoneSE {
            padding = 50
        } else {
            padding = 60
        }
        
        return padding
    }

    fileprivate var outerSliderSize: CGSize
    fileprivate var insideSliderSize: CGSize
    fileprivate var userItemSection: CGFloat
    fileprivate var userItemHeight: CGFloat
    fileprivate var itemTopPadding: CGFloat
    fileprivate var groupTopPadding: CGFloat
}
