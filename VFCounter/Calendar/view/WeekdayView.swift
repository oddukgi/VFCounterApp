//
//  WeekdayView.swift
//  CalendarApp
//
// Modified by Sunmi on 2020/09/02.
// Copyright © 2020 RetailDriver LLC. All rights reserved.
// Copyright © 2020 creativeSun. All rights reserved.



import UIKit
import SnapKit

class WeekdayView: UIView {

    // MARK: - Outlets
    
    lazy var stackView: UIStackView = {
       let stackView = UIStackView()
        stackView.backgroundColor = .clear
        stackView.spacing = 0
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .center
        return stackView
    }()


    // MARK: - Variables
    private let settings: CalendarSettings.WeekView
    
    // MARK: - Lifecycle
    init(settings: CalendarSettings.WeekView) {
        self.settings = settings
        super.init(frame: .zero)
        self.configureUI()
        self.configureSubviews()
        self.configureConstaints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        self.backgroundColor = self.settings.backgroundColor
        self.layer.cornerRadius = self.settings.cornerRadius
    }
    
    private func configureSubviews() {
        var weekDays = self.settings.calendar.shortWeekdaySymbols
        weekDays.append(weekDays.remove(at: 0))
        for weekdayItem in weekDays {
            self.stackView.addArrangedSubview(self.makeWeekLabel(for: weekdayItem))
        }
        self.addSubview(self.stackView)
    }
    
   func makeWeekLabel(for text: String) -> UILabel {
        let label = UILabel()
        label.text =  text
        label.font = self.settings.textFont
        label.textColor = self.settings.textColor
        label.textAlignment = .center
        return label
    }
    
    private func configureConstaints() {
        self.stackView.snp.makeConstraints { maker in
            maker.top.bottom.equalToSuperview()
            maker.left.right.equalToSuperview().inset(4)
            
        }
        self.snp.makeConstraints { maker in
            maker.height.equalTo(self.settings.height)
        }
    }
}
      

extension CalendarSettings {
    struct WeekView {
        var calendar: Calendar = .current
        var backgroundColor: UIColor = .quaternarySystemFill
        var textColor: UIColor = .darkGray
        var textFont: UIFont = .systemFont(ofSize: 10, weight: .bold)
        var height: CGFloat = 28
        var cornerRadius: CGFloat = 8
    }
}
