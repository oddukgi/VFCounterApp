//
//  DayCell.swift
//  CalendarApp
//
// Modified by Sunmi on 2020/09/03.
// Copyright © 2020 creativeSun. All rights reserved.

import UIKit
import SnapKit
import JTAppleCalendar

class DayCell: JTACDayCell {

    // MARK: - Outlets
    lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.text = "1"
        label.textAlignment = .center
        return label
    }()

    lazy var selectionBackgroundView: UIView = {
       let view = UIView()
        view.isHidden = true
        return view
    }()

    var ringButton: RingItemButton!
    var isFirstLoaded = true

    // MARK: - Variables
    private var setting: CalendarSettings.DayCell = CalendarSettings.default.dayCell
    private let dataManager = DataManager()

    // MARK: - Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)

        if setting.isRingVisible {
            setOnSubviews()
        } else {
            setSelectBgView()
        }
        applySettings(CalendarSettings.default.dayCell)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func applySettings(_ setting: CalendarSettings.DayCell) {
        self.setting = setting
        self.dateLabel.font = setting.dateLabelFont
        self.selectionBackgroundView.backgroundColor = setting.selectedBackgroundColor
//        self.dateLabel.textColor = setting.dateLabelColor
    }

    func setOnSubviews() {

        ringButton = RingItemButton(frame: bounds)
        self.contentView.addSubViews(ringButton, self.dateLabel)
        self.backgroundView = ringButton
        self.dateLabel.snp.makeConstraints { maker in
            maker.edges.equalToSuperview()
        }

    }

    func setSelectBgView() {
        self.contentView.addSubViews(selectionBackgroundView, self.dateLabel)
        self.dateLabel.snp.makeConstraints { maker in
            maker.edges.equalToSuperview()
        }

        self.selectionBackgroundView.snp.makeConstraints { (maker) in
            maker.height.equalTo(90).priority(.low)
            maker.top.left.greaterThanOrEqualToSuperview()
            maker.right.bottom.lessThanOrEqualToSuperview()
            maker.center.equalToSuperview()
            maker.width.equalTo(self.selectionBackgroundView.snp.height)
        }

        self.selectionBackgroundView.layer.cornerRadius = .minimum(self.frame.width, self.frame.height) / 2
    }

    static func makeViewSettings(for state: CellState, minimumDate: Date?, maximumDate: Date?,
                                 rangeValue: CalendarRange?, flag: Bool = false) -> ViewSettings {

        var config = ViewSettings()

        config.state = state
        if state.dateBelongsTo != .thisMonth {
            config.isSelectedItem = true

            if let value = rangeValue {
                let calendar = Calendar.current
                var showRangeView: Bool = false

                if state.dateBelongsTo == .followingMonthWithinBoundary {
                    let endOfPreviousMonth = calendar.date(byAdding: .month, value: -2, to: state.date)!.endOfMonth(in: calendar)
                    let startOfCurrentMonth = state.date.startOfMonth(in: calendar)
                    let fromDateIsInPast = value.fromDate < endOfPreviousMonth
                    let toDateIsInFutureOrCurrent = value.toDate > startOfCurrentMonth
                    showRangeView = fromDateIsInPast && toDateIsInFutureOrCurrent
                } else if state.dateBelongsTo == .previousMonthWithinBoundary {
                    let startOfNextMonth = calendar.date(byAdding: .month, value: 2, to: state.date)!.startOfMonth(in: calendar)
                    let endOfCurrentMonth = state.date.endOfMonth(in: calendar)
                    let toDateIsInFuture = value.toDate > startOfNextMonth
                    let fromDateIsInPastOrCurrent = value.fromDate < endOfCurrentMonth
                    showRangeView = toDateIsInFuture && fromDateIsInPastOrCurrent
                }

                if showRangeView {

                    if state.day == .monday {
                        config.rangeView.roundedLeftHidden = false
                        config.rangeView.squaredRightHidden = false
                    } else if state.day == .sunday {
                        config.rangeView.squaredLeftHidden = false
                        config.rangeView.roundedRightHidden = false
                    } else {
                        config.rangeView.squaredLeftHidden = false
                        config.rangeView.squaredRightHidden = false
                    }
                }

            }

            return config
        }

        config.dateLabelText = state.text
        config.date = state.date

        if let minimumDate = minimumDate, state.date < minimumDate.startOfDay() {
            config.isDateEnabled = false

            return config
        } else if let maximumDate = maximumDate, state.date > maximumDate.endOfDay() {

            config.isDateEnabled = false

            return config
        }

        if state.isSelected {

            let position = state.selectedPosition()

            switch position {

            case .full:
                config.isSelectedItem = false

            case .left, .right, .middle:
                config.isSelectedItem = position == .middle

                if position == .right && state.day == .monday {
                    config.rangeView.roundedLeftHidden = false

                } else if position == .left && state.day == .sunday {
                    config.rangeView.roundedRightHidden = false

                } else if position == .left {
                    config.rangeView.squaredRightHidden = false

                } else if position == .right {
                    config.rangeView.squaredLeftHidden = false

                } else if state.day == .monday {
                    config.rangeView.squaredRightHidden = false
                    config.rangeView.roundedLeftHidden = false

                } else if state.day == .sunday {
                    config.rangeView.squaredLeftHidden = false
                    config.rangeView.roundedRightHidden = false

                } else {
                    config.rangeView.squaredLeftHidden = false
                    config.rangeView.squaredRightHidden = false
                    }

                default:
                    break
                }
            }

            return config
    }

    enum RangeViewTrimState {
        case trimLeftHalf
        case trimRightHalf
    }

    enum RangeViewRoundState {
        case leftCorners
        case rightCorners
    }

    struct RangeViewConfig: Hashable {

        var roundedLeftHidden: Bool = true
        var roundedRightHidden: Bool = true
        var squaredLeftHidden: Bool = true
        var squaredRightHidden: Bool = true

        var isHidden: Bool {
            return self.roundedLeftHidden && self.roundedRightHidden && self.squaredLeftHidden && self.squaredRightHidden
        }

    }

    struct ViewSettings {
        var dateLabelText: String?
        var date: Date?
        var state: CellState?
        var isSelectedItem: Bool = true
        var isDateEnabled: Bool = true
        var isRingVisible: Bool = true
        var rangeView: RangeViewConfig = RangeViewConfig()
    }

    fileprivate func selectedDate(_ config: DayCell.ViewSettings) {

        if !config.isDateEnabled {
            self.dateLabel.textColor = self.setting.dateLabelUnavailableColor
        } else if !config.isSelectedItem {

            var selectedClr: UIColor!
            if config.isRingVisible { selectedClr = self.setting.selectedLabelColor }
            if selectionBackgroundView != nil {
                selectedClr = self.setting.plainselectedLabelColor
            }
            if selectionBackgroundView.isHidden == true {
                selectedClr = self.setting.selectedLabelColor
            }
            self.dateLabel.textColor = selectedClr

        } else {

            self.dateLabel.textColor = self.setting.dateLabelColor
            let from = Date().startOfDay()
            if !config.isRingVisible {
                if config.state!.date == from {
                    self.dateLabel.textColor = self.setting.todayLabelColor
                }
            }
        }
    }

    func updateRing(date: Date) {

        let strDate = date.changeDateTime(format: .longDate)
        let dateArray = strDate.components(separatedBy: [" "])

        let maxVeggie = SettingManager.getTaskValue(keyName: "VeggieTaskRate") ?? 0
        let maxFruit = SettingManager.getTaskValue(keyName: "FruitTaskRate") ?? 0
        let values = dataManager.getSumItems(date: dateArray.first!)

        self.ringButton.ringProgressView.ring1.progress = Double(values.0) / Double(maxVeggie)
        self.ringButton.ringProgressView.ring2.progress = Double(values.1) / Double(maxFruit)

    }

    func configure(for config: ViewSettings) {

        self.isUserInteractionEnabled = config.dateLabelText != nil && config.isDateEnabled

        if let dateLabelText = config.dateLabelText {
            self.dateLabel.isHidden = false

            self.dateLabel.text = dateLabelText

            if config.isRingVisible {

                if config.state!.dateBelongsTo == .thisMonth && config.state!.date > Date() {
                    self.ringButton.isHidden = true
                } else {
                    self.ringButton.isHidden = false
                }
                self.ringButton.isSelected = !config.isSelectedItem
                updateRing(date: config.date!)

            } else {

                let theFuture = Date().addingTimeInterval(100)
                if config.state!.dateBelongsTo == .thisMonth && config.state!.date > theFuture {
                    self.selectionBackgroundView.isHidden = true
                } else {
                    self.selectionBackgroundView.isHidden = config.isSelectedItem
                }
            }
            selectedDate(config)

        } else {
            self.dateLabel.isHidden = true
            self.selectionBackgroundView.isHidden = true
            if config.isRingVisible {
                self.ringButton.isHidden = true
            }
        }

    }

}

extension CalendarSettings {

    struct DayCell {

        var dateLabelFont: UIFont = .systemFont(ofSize: 16.5)
        var dateLabelColor: UIColor = .black
        var todayLabelColor: UIColor = .red
        var dateLabelUnavailableColor: UIColor = .lightGray

        var plainselectedLabelColor: UIColor = .white
        var selectedBackgroundColor: UIColor = .systemBlue
        var selectedLabelColor: UIColor = .systemBlue

        var rangeViewCornerRadius: CGFloat = 6
        var onRangeBackgroundColor: UIColor = UIColor.systemBlue.withAlphaComponent(0.2)
        var onRangeLabelColor: UIColor = .black
        var insets: UIEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10)
        var isRingVisible = false

    }
}
