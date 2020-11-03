//
//  SizeManager+Ext.swift
//  VFCounter
//
//  Created by Sunmi on 2020/10/22.
//  Copyright © 2020 creativeSun. All rights reserved.
//

import UIKit

extension SizeManager {
    
    var dateViewFontSize: CGFloat {
        var fontSize: CGFloat = 0.0
        
        if DeviceTypes.isiPhoneSE {
            fontSize = 15
        } else {
            fontSize = 17
        }
        
        return fontSize
    }
    
    func itemImgSize() -> CGSize {
        
        var imageSize = CGSize()
        
        if DeviceTypes.isiPhoneSE {
            imageSize = CGSize(width: 29, height: 29)
        } else {
            imageSize = CGSize(width: 39, height: 37)
        }
        
        return imageSize
    }
   
    func segmentSize() -> CGSize {
     
        var segmentSize = CGSize()
        
        if DeviceTypes.isiPhoneSE {
            segmentSize = CGSize(width: 140, height: 30)
        } else if DeviceTypes.isiPhone8Standard || DeviceTypes.isiPhoneX {
            segmentSize = CGSize(width: 170, height: 30)
        } else if DeviceTypes.isiPhone8PlusStandard {
            segmentSize = CGSize(width: 180, height: 30)
        } else {
            segmentSize = CGSize(width: 190, height: 30)
        }

        return segmentSize
        
    }
   
    func getSectionEdgeInsects() -> NSDirectionalEdgeInsets {
       var edgeIndests = NSDirectionalEdgeInsets()
       
       if DeviceTypes.isiPhoneSE {
           edgeIndests = NSDirectionalEdgeInsets(top: 8, leading: 9, bottom: 9, trailing: 9)
       } else {
           edgeIndests = NSDirectionalEdgeInsets(top: 8, leading: 10, bottom: 18, trailing: 10)
       }
       return edgeIndests
   }
    
    func getListEdgeInsects() -> NSDirectionalEdgeInsets {
       return NSDirectionalEdgeInsets(top: 3, leading: 5, bottom: 3, trailing: 5)
   }
    
    func getSectionInsectFlowLayout() -> UIEdgeInsets {
        var edgeInsects = UIEdgeInsets()
        if DeviceTypes.isiPhoneSE || DeviceTypes.isiPhone8Standard || DeviceTypes.isiPhoneX {
            edgeInsects = UIEdgeInsets(top: 8, left: 9, bottom: 9, right: 9)
        } else {
            edgeInsects = UIEdgeInsets(top: 8, left: 10, bottom: 12, right: 10)
        }
        return edgeInsects
        
    }
    
    // MARK: Calendar Size
    func calendarPopupSize() -> (CGSize) {

        var calendarSize: CGSize = CGSize()
        
        if DeviceTypes.isiPhoneSE {
            calendarSize = CGSize(width: 320, height: 450)
        } else if DeviceTypes.isiPhone8Standard || DeviceTypes.isiPhoneX {
            calendarSize = CGSize(width: ScreenSize.width - 39, height: 469)
        } else if DeviceTypes.isiPhone12ProMax {
           calendarSize = CGSize(width: ScreenSize.width - 62, height: 489)
        } else {
            calendarSize = CGSize(width: ScreenSize.width - 48, height: 489)
        }

        return (calendarSize)
    }
    var calendarItemSize: CGFloat {
        var itemSize: CGFloat = 0.0
        
        if DeviceTypes.isiPhoneSE {
            itemSize = 40
        } else if DeviceTypes.isiPhone8Standard || DeviceTypes.isiPhone12Pro
                    || DeviceTypes.isiPhoneX {
            itemSize = 42
        } else {
            itemSize = 46
        }
        return itemSize
    }
    
    var calendarItemPadding: CGFloat {
        
        let screenSize = calendarPopupSize().width
        let padding = (screenSize - (calendarItemSize * 7)) / 2
        return padding
    }
    
    var bigCalendarItemSize: CGFloat {
        
        var itemSize: CGFloat = 0
        if DeviceTypes.isiPhoneSE {
            itemSize = 40
        } else if DeviceTypes.isiPhone12Pro {
            itemSize = 49
        } else if DeviceTypes.isiPhone12ProMax {
            itemSize = 54
        } else {
            itemSize = 48
        }
            
        return itemSize
    }
    
    var bigCalendarPadding: CGFloat {
        let padding = (ScreenSize.width - (bigCalendarItemSize * 7)) / 2
        return padding
    }
}
