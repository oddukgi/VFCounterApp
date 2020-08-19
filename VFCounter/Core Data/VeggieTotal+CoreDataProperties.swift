//
//  VeggieTotal+CoreDataProperties.swift
//  VFCounter
//
//  Created by Sunmi on 2020/08/18.
//  Copyright © 2020 creativeSun. All rights reserved.
//
//

import Foundation
import CoreData


extension VeggieTotal {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<VeggieTotal> {
        return NSFetchRequest<VeggieTotal>(entityName: "VeggieTotal")
    }

    @NSManaged public var date: Date?
    @NSManaged public var sum: Int16

}
