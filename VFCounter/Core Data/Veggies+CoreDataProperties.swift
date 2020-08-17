//
//  Veggies+CoreDataProperties.swift
//  VFCounter
//
//  Created by Sunmi on 2020/08/17.
//  Copyright © 2020 creativeSun. All rights reserved.
//
//

import Foundation
import CoreData


extension Veggies {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Veggies> {
        return NSFetchRequest<Veggies>(entityName: "Veggies")
    }


}
