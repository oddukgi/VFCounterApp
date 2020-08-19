//
//  SettingController.swift
//  VFCounter
//
//  Created by Sunmi on 2020/08/05.
//  Copyright © 2020 creativeSun. All rights reserved.
//

import UIKit

class SettingController {
    
    struct Settings: Hashable {
        let name: String
        let image: UIImage?
        let identifier = UUID()
        
        func hash(into hasher: inout Hasher){
           hasher.combine(identifier)
        }
    }
    
    var defaults: [Settings] {
        return settings
    }
    
    var appInfo: [Settings] {
        return info
    }

    private let settings = [ Settings(name: "알림설정", image: UIImage(named: "alarm")),
                             Settings(name: "언어설정", image: UIImage(named: "globe")) ]
    
    private let info = [
                         Settings(name: "앱버전", image: nil),
                         Settings(name: "문의하기", image: nil),
                        ]

}


