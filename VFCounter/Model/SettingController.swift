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
    
    var collections: [Settings] {
        return settings
    }

    private let settings = [ Settings(name: "알림설정", image: UIImage(named: "alarm")),
                             Settings(name: "언어설정", image: UIImage(named: "globe")) ]

}


