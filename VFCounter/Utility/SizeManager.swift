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
        circularViewHeight = 0
        outerSliderSize = CGSize()
        insideSliderSize = CGSize()
        userItemSection = 0
        userItemHeight = 0
        itemTopPadding = 0
        groupTopPadding = 0

    }
    var getHeaderviewHeight: CGFloat {
        return 110
    }

    func circularViewHeight(view: UIView) -> CGFloat {

        let halfSize = (view.frame.height / 2)
        
        if DeviceTypes.isiPhone8Standard || DeviceTypes.isiPhoneSE {
            circularViewHeight = halfSize - 160
        } else if DeviceTypes.isiPhone8PlusStandard {
            circularViewHeight = halfSize - 150
        } else if DeviceTypes.isiPhoneX {
            circularViewHeight = halfSize - 170
        } else {
            circularViewHeight = halfSize - 180
        }

        return circularViewHeight
    }

    func sliderSize() -> (CGSize) {
       
        if DeviceTypes.isiPhoneSE {
            outerSliderSize = CGSize(width: 140, height: 140)
        } else if DeviceTypes.isiPhone8Standard {
            outerSliderSize = CGSize(width: 170, height: 170)
        } else if DeviceTypes.isiPhone8PlusStandard {
            outerSliderSize = CGSize(width: 180, height: 180)
        } else if DeviceTypes.isiPhoneX {
            outerSliderSize = CGSize(width: 190, height: 190)
        } else if DeviceTypes.isiPhoneXsMaxAndXr {
           outerSliderSize = CGSize(width: 210, height: 210)
        } else if DeviceTypes.isiPhone12Pro {
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
        } else if DeviceTypes.isiPhone8Standard || DeviceTypes.isiPhone8PlusStandard {
            width = 15
        } else {
            width = 18
        }

        return width
    }

    var itemTopPaddingCV: CGFloat {
        if DeviceTypes.isiPhone8Standard {
            itemTopPadding = 5
        } else {
            itemTopPadding = 5
        }

        return itemTopPadding
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
    
    var getUserItemHeightM: CGFloat {
    
        if  DeviceTypes.isiPhone8Standard,
            DeviceTypes.isiPhone8PlusStandard,
            DeviceTypes.isiPhoneX {
            userItemHeight = 98
        } else {
            userItemHeight = 105
        }
        
        return userItemHeight
    }
    var veggiePickCVHeight: CGFloat {
        return  DeviceTypes.isiPhone8Standard ? 190 : 130
    }

    var paddingForRulerView: CGFloat {

        if DeviceTypes.isiPhone8Standard {
           return -170
        } else if DeviceTypes.isiPhone8PlusStandard {
            return -200
        } else if DeviceTypes.isiPhoneX {
            return -180
        } else if DeviceTypes.isiPhoneXsMaxAndXr {
            return -230
        } else {
            return -230
        }
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
        if DeviceTypes.isiPhone8Standard {
            height = ScreenSize.height - 180
        } else if DeviceTypes.isiPhone8Standard || DeviceTypes.isiPhoneSE {
            height = ScreenSize.height - 280  //387
        } else if DeviceTypes.isiPhone8PlusStandard {
            height = ScreenSize.height - 300
        } else if DeviceTypes.isiPhoneX {
            height = ScreenSize.height - 360
        } else if DeviceTypes.isiPhoneXsMaxAndXr {
            height = ScreenSize.height - 370
       } else if DeviceTypes.isiPhone12Pro {
            height = ScreenSize.height - 350
        } else if DeviceTypes.isiPhone12ProMax {  //92
            height = ScreenSize.height - 360
        }

        return height
    }
    var calendarWidth: CGFloat {

        var screenWidth: CGFloat = 0.0
        if DeviceTypes.isiPhoneSE {
            screenWidth = ScreenSize.width - 10
        } else if DeviceTypes.isiPhone8Standard || DeviceTypes.isiPhoneX {
            screenWidth = ScreenSize.width - 39 //336
        } else if DeviceTypes.isiPhoneXsMaxAndXr || DeviceTypes.isiPhone8PlusStandard {
            screenWidth = ScreenSize.width - 78
        } else if DeviceTypes.isiPhone12Pro {
            screenWidth = ScreenSize.width - 54
        } else if DeviceTypes.isiPhone12ProMax {  //92
            screenWidth = ScreenSize.width - 92
        }

        return screenWidth
    }
    
    var calendarHeight: CGFloat {

        var height: CGFloat = 0.0
        
        if DeviceTypes.isiPhoneSE {
            height = ScreenSize.height - 350
        } else if DeviceTypes.isiPhone8Standard || DeviceTypes.isiPhone8PlusStandard {
            height = ScreenSize.height - 400
        } else if DeviceTypes.isiPhoneX {
            height = ScreenSize.height - 480
        } else if DeviceTypes.isiPhoneXsMaxAndXr {
            height = ScreenSize.height - 500
        } else if DeviceTypes.isiPhone12Pro {
            height = ScreenSize.height - 522
        } else if DeviceTypes.isiPhone12ProMax {
            height = ScreenSize.height - 540
        } else {
            height = ScreenSize.height - 360
        }

        return height
    }

    var ringViewPadding: CGFloat {
        var height: CGFloat = 0.0

        if DeviceTypes.isiPhoneSE {
            height = 8
        } else if DeviceTypes.isiPhone8Standard ||  DeviceTypes.isiPhone8PlusStandard {
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
    
// MARK: Calendar Size
    func calendarPopupSize() -> (CGSize) {

        var calendarSize: CGSize = CGSize()
        
        if DeviceTypes.isiPhoneSE {
            calendarSize = CGSize(width: 320, height: 420)
        } else {
            calendarSize = CGSize(width: 340, height: 420)
        }

        return (calendarSize)
    }
    
    var miniCalendarWidth: CGFloat {

        var screenWidth: CGFloat = 0.0
        
        if DeviceTypes.isiPhoneSE {
            screenWidth = ScreenSize.width - 28
        } else if DeviceTypes.isiPhone8Standard || DeviceTypes.isiPhoneX {
            screenWidth = ScreenSize.width - 39
        } else {
            screenWidth = ScreenSize.width - 78
        }

        return screenWidth
    }
    
    var miniCalendarHeight: CGFloat {
        
        var height: CGFloat = 0.0
        
        if DeviceTypes.isiPhoneSE {
            height = 250
        } else {
            height = 280
        }
        return height
    }
    
    var miniCalendarPadding: CGFloat {
        var padding: CGFloat = 0.0
        
        if DeviceTypes.isiPhoneSE {
            padding = 5
        } else {
            padding = 5
        }
        
        return padding
    }
    
    var legendPadding: CGFloat {
        var padding: CGFloat = 0.0
        
        if DeviceTypes.isiPhoneSE {
            padding = 60
        } else {
            padding = 110
        }
        
        return padding
    }

    fileprivate var circularViewHeight: CGFloat
    fileprivate var outerSliderSize: CGSize
    fileprivate var insideSliderSize: CGSize
    fileprivate var userItemSection: CGFloat
    fileprivate var userItemHeight: CGFloat
    fileprivate var itemTopPadding: CGFloat
    fileprivate var groupTopPadding: CGFloat
}
