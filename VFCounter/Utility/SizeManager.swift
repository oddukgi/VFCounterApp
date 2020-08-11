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
        headerViewHeight = 0
        circularViewHeight = 0
        outerSliderSize = CGSize()
        insideSliderSize = CGSize()
        userItemSection = 0
        userItemHeight = 0
    }
    var getHeaderviewHeight: CGFloat {
        
        if DeviceTypes.isiPhone8Standard {
            headerViewHeight = 145
        } else {
            headerViewHeight = 150
        }
        return headerViewHeight
    }
    
    func circularViewHeight(view: UIView) -> CGFloat {
    
        let halfSize = (view.frame.height / 2)
        if DeviceTypes.isiPhone8Standard {
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
    
    
    func sliderSize() -> (CGSize, CGSize) {

        if DeviceTypes.isiPhone8Standard {
          outerSliderSize = CGSize(width: 170, height: 170)
          insideSliderSize = CGSize(width: 110, height: 110)
 
        } else {
          outerSliderSize = CGSize(width: 200, height: 200)
          insideSliderSize = CGSize(width: 140, height: 140)
        }

        return (outerSliderSize, insideSliderSize)
    }

    var sliderWidth: CGFloat {
        var width: CGFloat = 0
        if DeviceTypes.isiPhone8Standard || DeviceTypes.isiPhone8PlusStandard {
            width = 18
        } else {
            width = 20
        }
        
        return width
    }


    var sectionSpacingForUserItemCV: CGFloat {

        if DeviceTypes.isiPhone8Standard {
            userItemSection = 10
        } else if DeviceTypes.isiPhone8PlusStandard {
            userItemSection = 11
        } else if DeviceTypes.isiPhoneX {
            userItemSection = 12
        } else {
            userItemSection = 14
        }
     
        return userItemSection
    }

    var getUserItemHeight: CGFloat {

        if DeviceTypes.isiPhone8Standard {
            userItemHeight = 105
        } else {
            userItemHeight = 108
        }
        return userItemHeight
    }
    
    var vegiePickCVHeight: CGFloat {
        return  DeviceTypes.isiPhone8Standard ? 90 : 120
    }
    
    var paddingForRulerView: CGFloat {
        
        if DeviceTypes.isiPhone8Standard {
           return -170
        } else if DeviceTypes.isiPhone8PlusStandard {
            return -200
        } else if DeviceTypes.isiPhoneX {
            return -180
        }
        else if DeviceTypes.isiPhoneXsMaxAndXr {
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
        }
        else {
            return -150
        }
    }
    
    var trianglePos: CGFloat {
        
        var pos: CGFloat = 0.0
        if DeviceTypes.isiPhone8Standard {
            pos = 8.2
        } else if DeviceTypes.isiPhone8PlusStandard {
            pos = 6.9
            
        } else if DeviceTypes.isiPhoneXsMaxAndXr {
            pos = 8.5
        }
        return pos
    }
    

    fileprivate var headerViewHeight: CGFloat
    fileprivate var circularViewHeight: CGFloat
    fileprivate var outerSliderSize: CGSize
    fileprivate var insideSliderSize: CGSize
    fileprivate var userItemSection: CGFloat 
    fileprivate var userItemHeight: CGFloat

}
