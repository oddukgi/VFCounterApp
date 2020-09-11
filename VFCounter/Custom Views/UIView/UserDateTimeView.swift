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
    var entityDT: Date?
    private var flag: Bool = false
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
    
    convenience init(dateTime: String, entityTime: Date?) {
        self.init()
        self.userDateTime = dateTime
        self.entityDT = entityTime
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
        
        print(sender.date)
        dtPickerView.date = sender.date
    }
    
    func compareDate() {

        if self.entityDT != nil {
            dtPickerView.date = entityDT!
            
        } else {
           dtPickerView.date = now
        }
      
    }
}

/*
 
 let getDate = String(userDateTime.split(separator: " ").first!)
        var time = ""
        
 time = getDate + String(userDateTime.dropFirst(10))
  let newDT = time.replacingOccurrences(of: ".", with: "-")
  dtPickerView.date = newDT.changeDateTime(format: .dateTime)
 */
