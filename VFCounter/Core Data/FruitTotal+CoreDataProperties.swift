//
//  FruitTotal+CoreDataProperties.swift
//  VFCounter
//
//  Created by Sunmi on 2020/08/18.
//  Copyright © 2020 creativeSun. All rights reserved.
//
//

import Foundation
import CoreData


extension FruitTotal {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FruitTotal> {
        return NSFetchRequest<FruitTotal>(entityName: "FruitTotal")
    }

    @NSManaged public var date: Date?
    @NSManaged public var sum: Int16

}
