//
//  DateProtocol.swift
//  VFCounter
//
//  Created by Sunmi on 2020/09/23.
//  Copyright © 2020 creativeSun. All rights reserved.
//

import Foundation


public protocol DateStrategy: class {

    var date: Date { get }
    var mininumDate: Date? { get set }
    var maximumDate: Date? { get set }


    func updateLabel() -> (String?, [String]?, [String]?)
    func fetchedData() 
    func setDateRange()
    func previous()
    func next()
    
}

protocol ItemCellDelegate: class {
    func updateSelectedItem(item: VFItemController.Items, index: Int)
    func deleteSelectedItem(item: Int, section: Int)
}
