//
//  DatePickerView.swift
//  VFCounter
//
//  Created by Sunmi on 2020/09/26.
//  Copyright © 2020 creativeSun. All rights reserved.
//

import UIKit

class DatePickerView: UIView {

    let containerView = UIView()
    let dtPickerView = UIDatePicker()
    private var now = Date()
    private var userDateTime: String = ""

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

    convenience init(dateTime: String) {
        self.init()
        self.userDateTime = dateTime
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure() {

        let dateFormatter = DateFormatter()
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
        dtPickerView.backgroundColor = .systemBackground
        dtPickerView.preferredDatePickerStyle = .wheels
        dtPickerView.datePickerMode = UIDatePicker.Mode.date

        dateFormatter.dateFormat = Date.Format.longDate.rawValue
        dtPickerView.maximumDate = now.addDaysToday(days: 0)
        dtPickerView.addTarget(self, action: #selector(changedDateTime), for: .valueChanged)
    }

    @objc func changedDateTime(sender: UIDatePicker) {

        let textTime = sender.date.changeDateTime(format: .dateTime)
        userDateTime = textTime
        dtPickerView.date = sender.date
    }

}
