//
//  DataType+CoreDataProperties.swift
//  VFCounter
//
//  Created by Sunmi on 2020/09/01.
//  Copyright © 2020 creativeSun. All rights reserved.
//
//

import Foundation
import CoreData


extension DataType {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DataType> {
        return NSFetchRequest<DataType>(entityName: "DataType")
    }

    @NSManaged public var amount: Int16
    @NSManaged public var createdDate: Date?
    @NSManaged public var image: Data?
    @NSManaged public var name: String?
    @NSManaged public var date: String?

}
