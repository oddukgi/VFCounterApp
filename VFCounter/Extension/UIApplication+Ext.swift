//
//  UIApplication+Ext.swift
//  VFCounter
//
//  Created by Sunmi on 2020/08/18.
//  Copyright © 2020 creativeSun. All rights reserved.
//

import UIKit


extension UIApplication {
    
    static var appVersion: String? {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
    }
}
