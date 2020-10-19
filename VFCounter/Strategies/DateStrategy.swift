//
//  DateProtocol.swift
//  VFCounter
//
//  Created by Sunmi on 2020/09/23.
//  Copyright © 2020 creativeSun. All rights reserved.
//

import Foundation

public protocol DateStrategy: class {

    var date: Date { get set }
    var mininumDate: Date? { get set }
    var maximumDate: Date? { get set }

    func updateLabel() -> (String?, [String]?, [String]?)
    func fetchedData()
    func setMinimumDate()
    func setMaximumDate()
    func previous()
    func next()
}
