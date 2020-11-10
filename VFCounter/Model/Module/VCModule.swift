//
//  ItemModule.swift
//  VFCounter
//
//  Created by Sunmi on 2020/10/28.
//  Copyright © 2020 creativeSun. All rights reserved.
//

import UIKit

enum PickItemModule {
    static func build(currentVC: UIViewController, model: ItemModel,
                      filter: SectionFilter = .main) -> PickItemVC {

        let delegate = currentVC as! PickItemProtocol
       
        var pickItemVC = PickItemVC(delegate: delegate, model: model, sectionFilter: filter)

        return pickItemVC
    }
}
