//
//  DataFilter.swift
//  VFCounter
//
//  Created by Sunmi on 2020/09/14.
//  Copyright © 2020 creativeSun. All rights reserved.
//

import Foundation

enum DataFilter {
    
    case data, list

    var filterName: String {
        switch self {
        case .data:
            return "데이터"
        default:
            return "내역"
        }
    }
}

