//
//  DateView.swift
//  VFCounter
//
//  Created by Sunmi on 2020/07/21.
//  Copyright © 2020 creativeSun. All rights reserved.
//

import UIKit
import SnapKit

class DateView: UIView {

    var btnLeftArrow: VFButton!
    var btnRightArrow: VFButton!
 
    var horizontalView: [UIStackView] = []
    let dateLabel = VFTitleLabel(textAlignment: .center,
                                 font: NanumSquareRound.bold.style(offset: 17))

    private var date = Date()
    private var startDate: Date?
    private var endDate: Date?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setLayout()
        initialize()
        createDismissKeyboardTapGesture()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func initialize() {

        dateLabel.text = date.changeDateTime(format: .longDate)
        dateLabel.textColor = UIColor.black

        btnLeftArrow.addTarget(self, action: #selector(changedDateTouched), for: .touchUpInside)
        btnLeftArrow.tag = 0
        btnRightArrow.addTarget(self, action: #selector(changedDateTouched), for: .touchUpInside)
        btnRightArrow.tag = 1
        startDate = date.getFirstMonthDate()
        endDate = date.endOfDay()
    }

    fileprivate func changeDateToResource(to date: Date) {
        let newDate = date.changeDateTime(format: .longDate)
        dateLabel.text = newDate
        NotificationCenter.default.post(name: .updateFetchingData, object: nil, userInfo: ["createdDate": newDate])
    }

    func createDismissKeyboardTapGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIView.endEditing))
        addGestureRecognizer(tap)
    }

    @objc func changedDateTouched(_ sender: VFButton) {

        if sender.tag == 0 {
            guard date > startDate! else { return }
            date = date.dayBefore.endOfDay()

        } else {

            let theFuture = date.endOfDay()
            if theFuture >= endDate! { return }
            date = date.dayAfter.endOfDay()
        }

        changeDateToResource(to: date)
    }

    func updateDate(userdate: String) {
        date = userdate.changeDateTime(format: .date)
        changeDateToResource(to: date)
    }
}
