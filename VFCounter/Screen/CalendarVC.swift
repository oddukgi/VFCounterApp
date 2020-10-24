//
//  CalendarVC.swift
//  VFCounter
//
//  Created by Sunmi on 2020/09/26.
//  Copyright © 2020 creativeSun. All rights reserved.
//

import UIKit

class CalendarVC: UIViewController {

    let containerView = VFContainerView()
    let calendarView = UIView()
    let calendarController = CalendarController(mode: .single)
    let controller = Controller()
    var date: Date?
    weak var delegate: CalendarVCDelegate?

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
        button.setFont(clr: .white, font: NanumSquareRound.extrabold.style(offset: 15))
        button.layer.cornerRadius = 8
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

        let calendarSize = SizeManager().calendarPopupSize()
        containerView.snp.makeConstraints { (maker) in
            maker.center.equalTo(view.snp.center)
            maker.size.equalTo(calendarSize)
        }
        
        containerView.layoutSubviews()

        let newHeight = calendarSize.height - 80
        calendarView.snp.makeConstraints { make in
            make.top.equalTo(containerView).offset(44)
            make.left.right.equalTo(containerView)
            make.height.equalTo(newHeight)
        }
        calendarView.layoutIfNeeded()

        closeBtn.snp.makeConstraints { (maker) in
            maker.top.equalTo(containerView).offset(12)
            maker.trailing.equalTo(containerView).offset(-20)
            maker.size.equalTo(CGSize(width: 20, height: 20))
        }

        applyBtn.snp.makeConstraints { (maker) in
            maker.centerX.equalTo(containerView)
            maker.bottom.equalTo(containerView).offset(-2)
            maker.size.equalTo(CGSize(width: 65, height: 35))
        }
 
        calendarController.present(above: self, contentView: calendarView)
    }

    private func configureCalendar() {
        calendarController.initialValue = self.currentValue as? Date
        calendarController.minimumDate = date?.getFirstMonthDate()
        calendarController.maximumDate = Date()
        calendarController.isRingVisible = false
        calendarController.isPopupVisible = true
    }

    @objc private func cancel() {

        if let date = currentValue as? Date {
            delegate?.updateDate(date: date, isUpdateCalendar: false)
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
    
}

extension CalendarVC {
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
