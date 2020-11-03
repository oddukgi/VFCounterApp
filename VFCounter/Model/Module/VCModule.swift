//
//  ItemModule.swift
//  VFCounter
//
//  Created by Sunmi on 2020/10/28.
//  Copyright © 2020 creativeSun. All rights reserved.
//

import UIKit

enum PickItemModule {
    static func build(userVC: UserItemVC, model: ItemModel,
                      filter: SectionFilter = .main) -> PickItemVC {
        
        var pickItemVC = PickItemVC(delegate: userVC, model: model, sectionFilter: filter)
        let model = PickItemModel(config: model.valueConfig)
        pickItemVC.pickItemModel = model
        return pickItemVC
    }
}
