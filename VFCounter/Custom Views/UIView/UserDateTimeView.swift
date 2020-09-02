//
//  UserDateTimeView.swift
//  VFCounter
//
//  Created by Sunmi on 2020/08/31.
//  Copyright © 2020 creativeSun. All rights reserved.
//

import UIKit

class UserDateTimeView: UIView {

    private var now = Date()
    private var userDateTime: String = ""
    
    let containerView = UIView()
    let dtPickerView = UIDatePicker()

    var dateTime: String {
        
        get {
            return userDateTime
        }
        
        set (newDT) {
            userDateTime = newDT
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        
    }
    
    convenience init(dateTime: String) {
        self.init()
        self.userDateTime = dateTime
        compareDate()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {
        self.addSubViews(containerView, dtPickerView)
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
       
        dtPickerView.snp.makeConstraints { make in
            make.edges.size.equalTo(containerView)
        }
        
//        dtPickerView.layer.borderWidth = 1    
        dtPickerView.timeZone = TimeZone.current
        dtPickerView.locale =  Locale(identifier: "ko_KR")
        dtPickerView.maximumDate = now.addDaysToday(days: 0)
        dtPickerView.addTarget(self, action: #selector(changedDateTime), for: .valueChanged)
    }

    @objc func changedDateTime(sender: UIDatePicker) {
        
        let textTime = sender.date.changeDateTime(format: .dateTime)
        userDateTime = textTime
    }
    
    func compareDate() {
        
        let pickerViewDT = dtPickerView.date.changeDateTime(format: .dateTime)
        let date = pickerViewDT.components(separatedBy: " ").first!
        let selectedDate = String(userDateTime.split(separator: " ").first!)
        let time = now.changeDateTime(format: .pickerTime)
        let newDT = selectedDate.replacingOccurrences(of: ".", with: "-")
    
        if date != selectedDate {
            let userDT = newDT + time
            dtPickerView.setDate(from: userDT, format: "yyyy-MM-dd HH:mm:ss")
        } else {
            dtPickerView.date = now
        }
        
    }
}
