//
//  TableViewModel.swift
//  VFCounter
//
//  Created by Sunmi on 2020/10/17.
//  Copyright © 2020 creativeSun. All rights reserved.
//

import Foundation

struct TableViewCellModel {
    var date: String
    var subcategory: [String]
    var data: [[DataType]]
}

struct PeriodData {
    var arrTBCell: [TableViewCellModel] = []
    init() { }
}

struct ItemModel {
    var oldItem: String = ""
    var newItem: String = ""
    var oldDate: String = ""
    var newDate: String = ""
    init() { }
}
