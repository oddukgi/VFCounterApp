//
//  Fruits+CoreDataProperties.swift
//  
//
//  Created by Sunmi on 2020/10/10.
//
//

import Foundation
import CoreData


extension Fruits {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Fruits> {
        return NSFetchRequest<Fruits>(entityName: "Fruits")
    }


}
