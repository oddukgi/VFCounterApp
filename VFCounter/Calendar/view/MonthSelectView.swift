//
//  MonthSelectView.swift
//  CalendarApp
//
//  Created by Sunmi on 2020/09/02.
//  Copyright © 2020 creativeSun. All rights reserved.
//

import UIKit

protocol MonthSelectViewProtocol: class {
    func pressedArrow(tag: Int)
}

class MonthSelectView<Value: CalendarValue>: UIView {

    let containerView = UIView()
    lazy var stackView: UIStackView = {
          let stackView = UIStackView()
          stackView.spacing = 105
          stackView.axis = .horizontal
          stackView.distribution = .fill
          return stackView
    }()

    lazy var arrowButtons: [UIButton] = {
        var buttons = [UIButton]()
        var img = ["chartL", "chartR"]
        (0 ..< 2).forEach { index in

            let button = UIButton()
            button.setImage(UIImage(named: img[index]), for: .normal)
            button.contentMode = .scaleAspectFit
            buttons.append(button)
        }
        return buttons
    }()

    lazy var lblMonth: UILabel = {
        let label = UILabel(frame: .zero)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label

    }()

    lazy var lblAmount: UILabel = {
        let label = UILabel(frame: .zero)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = ColorHex.MilkChocolate.origin
        label.font = NanumSquareRound.regular.style(offset: 11)
        return label

    }()

    // MARK: - Variable

    private var setting: CalendarSettings.MonthSelectView

    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = self.setting.locale
        formatter.dateFormat = self.setting.format
        return formatter
    }()

    var currentValue: Value? {
        didSet {
            updateMonth()
        }
    }

    weak var delegate: MonthSelectViewProtocol?

    init(settings: CalendarSettings.MonthSelectView) {
        self.setting = settings
        super.init(frame: .zero)
        configureUI()
        configureSubviews()
        updateMonth()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Configuration
    private func configureUI() {
        self.backgroundColor = .clear
    }

    private func configureSubviews() {
        self.addSubViews(stackView, lblMonth, lblAmount)

        arrowButtons.forEach {
            stackView.addArrangedSubview($0)
        }

        stackView.snp.makeConstraints {
            $0.top.equalTo(self).offset(7)
            $0.centerX.equalTo(self.snp.centerX)
            $0.height.equalTo(32)
        }

        lblMonth.snp.makeConstraints {
            $0.leading.equalTo(arrowButtons[0].snp.trailing)
            $0.centerY.equalTo(stackView.snp.centerY)
            $0.width.equalTo(105)
        }

        lblAmount.snp.makeConstraints {
            $0.top.equalTo(lblMonth.snp.bottom).offset(15)
            $0.centerX.equalTo(self)
            $0.width.equalTo(150)
        }

        lblAmount.font = setting.amountFont
        arrowButtons[0].addTarget(self, action: #selector(previous(_:)), for: .touchUpInside)
        arrowButtons[1].addTarget(self, action: #selector(next(_:)), for: .touchUpInside)
        
        self.snp.makeConstraints { maker in
            maker.height.equalTo(self.setting.height)
        }
    }

    func updateMonth() {
        if let value = self.currentValue as? Date {
            setting.currentDate = value
            lblMonth.text = dateFormatter.string(from: value)
            lblMonth.textColor = setting.textColor
            NotificationCenter.default.post(name: .updateMonth, object: nil, userInfo: ["usermonth": value])

        }
    }

    func updateDate(date: Date) {
        lblAmount.text = date.changeDateTime(format: .longDate)
    }

    func updateAmount(veggieSum: Int, fruitSum: Int) {
        lblAmount.text = "야채: \(veggieSum)g   과일: \(fruitSum)g"
    }

    @objc func previous(_ sender: UIButton) {
        delegate?.pressedArrow(tag: 0)
    }

    @objc func next(_ sender: UIButton) {
        delegate?.pressedArrow(tag: 1)
    }
}

extension CalendarSettings {

    struct MonthSelectView {
        var textColor: UIColor = .black
        var format: String = "YYYY MM"
        var locale = Locale(identifier: "ko_KR")
        var currentDate = Date()
        var monthFont: UIFont = .systemFont(ofSize: 14, weight: .bold)
        var amountFont: UIFont = .systemFont(ofSize: 13, weight: .medium)
        let height: CGFloat = 40
    }
}
