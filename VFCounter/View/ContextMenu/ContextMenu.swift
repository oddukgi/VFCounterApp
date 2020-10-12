//
//  ContextMenu.swift
//  VFCounter
//
//  Created by Sunmi on 2020/10/10.
//  Copyright © 2020 creativeSun. All rights reserved.
//

import UIKit

enum ContextMenu {
    
    
    static func makeMenuItem() -> [UIMenuItem] {
        
        let modify = UIMenuItem(title: "편집", action: Selector(""))
        let deletes = UIMenuItem(title: "삭제", action: Selector(""))
        
        return [modify, deletes]
    }
}
