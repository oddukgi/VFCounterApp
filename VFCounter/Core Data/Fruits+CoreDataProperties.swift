//
//  Fruits+CoreDataProperties.swift
//  VFCounter
//
//  Created by Sunmi on 2020/08/25.
//  Copyright © 2020 creativeSun. All rights reserved.
//
//

import Foundation
import CoreData


extension Fruits {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Fruits> {
        return NSFetchRequest<Fruits>(entityName: "Fruits")
    }


}
