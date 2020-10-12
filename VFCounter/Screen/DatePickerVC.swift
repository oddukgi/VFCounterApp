//
//  DatePickerVC.swift
//  VFCounter
//
//  Created by Sunmi on 2020/09/26.
//  Copyright © 2020 creativeSun. All rights reserved.
//

import UIKit

protocol DatePickerProtocol: class {
    func updateDate(date: Date)
}
class DatePickerVC: UIViewController {

    let containerView = VFContainerView()
    let calendarView = UIView()
    let calendarController = CalendarController(mode: .single)
    var date: Date?
    let controller = Controller()
    weak var delegate: DatePickerProtocol?

    var currentValue: CalendarValue? {
        didSet {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy.MM.dd"
            formatter.locale = Locale(identifier: "ko_KR")

        }
    }
    // MARK: - Resource
    private lazy var closeBtn: VFButton = {
        let button = VFButton()
        button.setImage(UIImage(named: "delete"), for: .normal)
        button.addTarget(self, action: #selector(cancel), for: .touchUpInside)
        return button
    }()

    private lazy var applyBtn: VFButton = {
        let button = VFButton()
        button.setTitle("Apply", for: .normal)
        button.backgroundColor    = ColorHex.middleGreen
        button.setFont(clr: .white, font: NanumSquareRound.extrabold.style(sizeOffset: 15))
        button.layer.cornerRadius = 20
//        button.setRadiusWithShadow(18)
        button.addTarget(self, action: #selector(applyDate), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureCalendar()
        configureUI()
        connectDateAction()
        moveCalendar()
    }

    convenience init(date: Date) {
        self.init()
        self.date = date
    }

    private func configureUI() {
        view.backgroundColor = UIColor.black.withAlphaComponent(0.75)
        view.addSubViews(containerView, calendarView, closeBtn, applyBtn)

        containerView.snp.makeConstraints { (maker) in
            maker.center.equalTo(view.snp.center)
            maker.size.equalTo(CGSize(width: 350, height: 490))
        }

        calendarView.snp.makeConstraints { (maker) in
            maker.top.equalTo(containerView).offset(30)
            maker.leading.equalTo(containerView).offset(5)
            maker.trailing.equalTo(containerView).offset(-5)
            maker.bottom.equalTo(containerView).offset(-30)

        }

//        calendarView.layer.borderWidth = 1
//        calendarView.layer.borderColor = UIColor.red.cgColor
        closeBtn.snp.makeConstraints { (maker) in
            maker.top.equalTo(containerView).offset(10)
            maker.trailing.equalTo(containerView).offset(-10)
            maker.size.equalTo(CGSize(width: 24, height: 24))
        }

        applyBtn.snp.makeConstraints { (maker) in
            maker.centerX.equalTo(containerView)
            maker.bottom.equalTo(containerView).offset(-10)
            maker.size.equalTo(CGSize(width: 70, height: 40))
        }

        calendarController.present(above: self, contentView: calendarView)
    }

    private func configureCalendar() {
        calendarController.initialValue = self.currentValue as? Date
        calendarController.minimumDate = date?.getFirstMonthDate()
        calendarController.maximumDate = Date()
        calendarController.isRingVisible = false
    }

    @objc private func cancel() {

        if let date = currentValue as? Date {
            delegate?.updateDate(date: date)
        }
        dismiss(animated: true)
    }

    @objc private func applyDate() {
        self.cancel()
    }

    func connectDateAction() {
        calendarController.doneHandler = { newDate in
            self.currentValue = newDate
        }
    }

    func moveCalendar() {
        calendarController.moveToSpecificDate(date: date!)
    }

//        calendarController.scrollToDate(searchedDate, triggerScrollToDateDelegate: true, animateScroll: true, preferredScrollPosition: nil, extraAddedOffset: 0.0) {
//           self.calendarView.selectDates([searchedDate], triggerSelectionDelegate: true)
//        }

}

extension DatePickerVC {
    public struct Controller {
        public var cancelButtonTitle: String = "Cancel"
        public var doneButtonTitle: String = "Done"
        public var titleTextAttributes: [NSAttributedString.Key: Any] = [:]
        public var backgroundColor: UIColor = .white
        public var barButtonItemsColor: UIColor = .systemBlue
        public var customCancelButton: UIBarButtonItem?
        public var customDoneButton: UIBarButtonItem?
    }
}
