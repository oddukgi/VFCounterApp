//
//  DataType+CoreDataProperties.swift
//  
//
//  Created by Sunmi on 2020/10/19.
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
    @NSManaged public var date: String?
    @NSManaged public var image: Data?
    @NSManaged public var maxfruit: Int16
    @NSManaged public var maxveggie: Int16
    @NSManaged public var name: String?

}
