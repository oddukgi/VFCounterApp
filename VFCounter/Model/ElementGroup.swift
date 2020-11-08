//
//  ElementGroup.swift
//  VFCounter
//
//  Created by Sunmi on 2020/11/01.
//  Copyright © 2020 creativeSun. All rights reserved.
//

import Foundation

struct SectionGroup: Hashable {
  
    var date: String?
    var type: String?
    
    init(date: String?, type: String?) {
        self.date = date
        self.type = type
    }
}

struct ItemGroup: Hashable {

    var date: String?
    var category: Category?
    
    init(date: String?, category: Category?) {
        self.date = date
        self.category = category
    }
}

enum Status: String {
    case add, edit, delete, refetch
    var status: String { return rawValue }
}

struct UpdateItem {
    
    var olddate: String = ""
    var date: String = ""
    var itemCount: Int = 0
    var status: Status?

}
