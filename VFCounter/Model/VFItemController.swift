//
//  VFItemController.swift
//  VFCounter
//
//  Created by Sunmi on 2020/07/24.
//  Copyright © 2020 creativeSun. All rights reserved.
//

import UIKit

class VFItemController {

    struct Items: Hashable {
        var name: String
        var date: String
        var image: UIImage?
        var amount: Int
        var entityDT: Date?

        func copy(with zone: NSZone? = nil) -> Any {
            let copy = Items(name: name, date: date, image: image,
                             amount: amount, entityDT: entityDT)
            return copy
        }
    }
}
