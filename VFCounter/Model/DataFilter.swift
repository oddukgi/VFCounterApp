//
//  DataFilter.swift
//  VFCounter
//
//  Created by Sunmi on 2020/09/14.
//  Copyright © 2020 creativeSun. All rights reserved.
//

import UIKit

protocol DateProtocol {
    var newDate: String { get set }
}

enum SectionFilter: String {

    case main, chart
    var kind: String {
        return rawValue
    }
}
