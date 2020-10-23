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
        } else if DeviceTypes.isiPhone8Standard {
            segmentSize = CGSize(width: 170, height: 30)
        } else if DeviceTypes.isiPhone8PlusStandard {
            segmentSize = CGSize(width: 180, height: 30)
        } else {
            segmentSize = CGSize(width: 190, height: 30)
        }

        return segmentSize
        
    }
    
    // NSDirectionalEdgeInsets(top: 8, leading: 10, bottom: 18, trailing: 10)
    
    func getSectionEdgeInsects() -> NSDirectionalEdgeInsets {
        var edgeIndests = NSDirectionalEdgeInsets()
        
        if DeviceTypes.isiPhoneSE {
            edgeIndests = NSDirectionalEdgeInsets(top: 8, leading: 10, bottom: 10, trailing: 10)
        } else {
            edgeIndests = NSDirectionalEdgeInsets(top: 8, leading: 10, bottom: 18, trailing: 10)
        }
        return edgeIndests
        
    }
    
    //calendar cell size
    
    var calendarItemSize: CGFloat {
        var itemSize: CGFloat = 0.0
        
        if DeviceTypes.isiPhoneSE || DeviceTypes.isiPhone8Standard {
            itemSize = 42
        } else if DeviceTypes.isiPhone8Standard {
            itemSize = 45
        } else {
            itemSize = 46
        }
        
        return itemSize
    }
    
    var calendarItemPadding: CGFloat {
        var padding: CGFloat = 0.0
        
        if DeviceTypes.isiPhoneSE {
            padding = 13
        } else if DeviceTypes.isiPhone8Standard {
            padding = 20
        } else {
            padding = 16
        }
        
        return padding
    }
    
}
