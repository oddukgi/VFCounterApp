//
//  ValueFormatter.swift
//  VFCounter
//
//  Created by Sunmi on 2020/10/02.
//  Copyright © 2020 creativeSun. All rights reserved.
//

import Foundation
import Charts

public class ValueFormatter: NSObject, IValueFormatter, IAxisValueFormatter {

    /// Suffix to be appended after the values
    public var suffix = "g"
    public var appendix: String?

    public init(appendix: String? = nil) {
        self.appendix = appendix
    }

    fileprivate func format(value: Double) -> String {
        var newValue = value

        var r = String(format: "%.0f", newValue) + suffix
        if let appendix = appendix {
            r + appendix
        }

        return r
    }

    public func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return format(value: value)
    }

    public func stringForValue(_ value: Double, entry: ChartDataEntry,
                               dataSetIndex: Int, viewPortHandler: ViewPortHandler?) -> String {
        return format(value: value)
    }
}
