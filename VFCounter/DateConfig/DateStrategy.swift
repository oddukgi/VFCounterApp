//
//  DateProtocol.swift
//  VFCounter
//
//  Created by Sunmi on 2020/09/23.
//  Copyright © 2020 creativeSun. All rights reserved.
//

import Foundation

struct DateValue {
    var minV: Date?
    var minF: Date?
    var maxV: Date?
    var maxF: Date?
}

public protocol DateStrategy: class {

    var date: Date { get set }
    var strDateMap: [String] { get }
    var period: String { get }
    var updateDateHandler: ((Date?) -> Void)? { get set }
    func fetchedData()

    func getDateMap() -> [Date]
    func setMinimumDate()
    func setMaximumDate()
    func previous()
    func next()
    func updateDateMap(date: String)
}

//    var mininumDate: Date? { get set }
//    var maximumDate: Date? { get set }
