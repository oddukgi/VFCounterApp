//
//  Veggies+CoreDataProperties.swift
//  
//
//  Created by Sunmi on 2020/10/10.
//
//

import Foundation
import CoreData


extension Veggies {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Veggies> {
        return NSFetchRequest<Veggies>(entityName: "Veggies")
    }


}
