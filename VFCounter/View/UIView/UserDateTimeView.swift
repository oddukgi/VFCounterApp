//
//  UserDateTimeView.swift
//  VFCounter
//
//  Created by Sunmi on 2020/08/31.
//  Copyright © 2020 creativeSun. All rights reserved.
//

import UIKit

// protocol
// update date
protocol UserDateTimeDelegate: class {
    func updateMaxAmount(date: Date)
}

class UserDateTimeView: UIView {

    let containerView = UIView()
    let dtPickerView = UIDatePicker()
    var entityDT: Date?

    private var now = Date()
    private var userDateTime: String = ""
    private var flag: Bool = false
    weak var delegate: UserDateTimeDelegate?
    var dateTime: String {

        get {
            return userDateTime
        }

        set (newDT) {
            userDateTime = newDT
        }
    }
    
    var userDate: Date? {
        didSet {
            if let date = userDate, delegate != nil {
                delegate?.updateMaxAmount(date: date)
            }
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

        dtPickerView.timeZone = TimeZone.current
        dtPickerView.locale =  Locale(identifier: "ko_KR")
        dtPickerView.backgroundColor = .systemBackground
        dtPickerView.preferredDatePickerStyle = .wheels
        dtPickerView.maximumDate = now.addDaysToday(days: 0)
        dtPickerView.addTarget(self, action: #selector(changedDateTime), for: .valueChanged)
    }

    @objc func changedDateTime(sender: UIDatePicker) {

        let textTime = sender.date.changeDateTime(format: .dateTime)
        userDateTime = textTime
        dtPickerView.date = sender.date
        userDate = dtPickerView.date
    }

    func compareDate() {

        if self.entityDT != nil {
            dtPickerView.date = entityDT!

        } else {
            dtPickerView.date = userDateTime.changeDateTime(format: .dateTime)
        }
    }
}
