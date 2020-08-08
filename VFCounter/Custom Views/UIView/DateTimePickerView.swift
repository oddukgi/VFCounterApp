//
//  DateTimePickerView.swift
//  VFCounter
//
//  Created by Sunmi on 2020/08/05.
//  Copyright © 2020 creativeSun. All rights reserved.
//

import UIKit

class DateTimePickerView: UIView {

    let dateTimePickerView = UIDatePicker()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setLayout() {
        dateTimePickerView.timeZone = TimeZone.autoupdatingCurrent
        dateTimePickerView.date     = Date()
    
    }
}
