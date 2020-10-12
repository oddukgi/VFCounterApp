//
//  UIDatePicker+Ext.swift
//  VFCounter
//
//  Created by Sunmi on 2020/09/02.
//  Copyright © 2020 creativeSun. All rights reserved.
//

import UIKit

extension UIDatePicker {

    func setDate(from string: String, format: String, animated: Bool = true) {

        let formater = DateFormatter()
        formater.dateFormat = format
        let date = formater.date(from: string) ?? Date()
        setDate(date, animated: animated)
    }

}
