//
//  UserDateTimeView.swift
//  VFCounter
//
//  Created by Sunmi on 2020/08/31.
//  Copyright © 2020 creativeSun. All rights reserved.
//

import UIKit

class UserDateTimeView: UIView {

    let containerView = UIView()
    let dtPickerView = UIDatePicker()
    private var now = Date()
    var dateTime: String = ""
    var dateConverter: DateConverter!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {
        self.addSubViews(containerView, dtPickerView)
        containerView.snp.makeConstraints { make in
            make.top.equalTo(self)
            make.leading.equalTo(self)
            make.trailing.equalTo(self)
            make.bottom.equalTo(self)
        }
       
        dtPickerView.snp.makeConstraints { make in
            make.edges.size.equalTo(containerView)
        }
        
//        dtPickerView.layer.borderWidth = 1    
        dtPickerView.timeZone = TimeZone.current
        dtPickerView.locale =  Locale(identifier: "ko_KR")
        dtPickerView.maximumDate = now.addDaysToday(days: 0)
        dtPickerView.addTarget(self, action: #selector(changedDateTime), for: .valueChanged)
        
        dateConverter = DateConverter(date: dtPickerView.date)
        let textTime = dateConverter.changeDate(format: "yyyy.MM.dd h:mm:ss a", option: 2)
        dateTime = textTime
    }

    @objc func changedDateTime(sender: UIDatePicker) {
        dateConverter = DateConverter(date: sender.date)
        let textTime = dateConverter.changeDate(format: "yyyy.MM.dd h:mm:ss a", option: 2)
        dateTime = textTime
    }
}
