//
//  CalendarController.swift
//  CalendarApp
//
//  Modified by Sunmi on 2020/09/04.
//  Copyright © 2020 RetailDriver LLC. All rights reserved.
//  Copyright © 2020 creativeSun. All rights reserved.

import UIKit
import JTAppleCalendar
import SnapKit
import CoreStore

class CalendarController<Value: CalendarValue>: UIViewController, JTACMonthViewDelegate,
JTACMonthViewDataSource {

    // MARK: - Outlets

    private lazy var calendarView: JTACMonthView = {
        let monthView = JTACMonthView()
        monthView.backgroundColor = self.appearance.backgroundColor
        monthView.ibCalendarDelegate = self
        monthView.ibCalendarDataSource = self
        monthView.minimumLineSpacing  = 2
        monthView.minimumInteritemSpacing = 0
        monthView.cellSize = SizeManager().calendarItemSize
        monthView.allowsMultipleSelection = false
        monthView.allowsRangedSelection = false
        monthView.contentInsetAdjustmentBehavior = .always
        monthView.scrollDirection = .horizontal
        return monthView

    }()
    private lazy var weekdayView: WeekdayView = {
        return WeekdayView(settings: self.setting.weekView)
    }()

    private lazy var currentValueView: MonthSelectView<Value> = {
        let view = MonthSelectView<Value>(settings: self.setting.monthSelectView)
        view.delegate = self
        self.calendarView.visibleDates { (segment) in
            UIView.performWithoutAnimation {
                self.calendarView.reloadItems(at: (segment.outdates + segment.indates).map({ $0.indexPath }))
            }
        }
        return view

    }()

    /**
     Shortcuts array
     
     You can use prepered shortcuts depending on the current mode.
     
     - For `.single` mode: `.today`, `.tomorrow`, `.yesterday`
     - For `.range` mode: `.today`, `.lastWeek`, `.lastMonth`
     
     Or you can create your own shortcuts:
     
     ```
     var customShortcut = FastisShortcut(name: "Today") {
         let now = Date()
         return FastisRange(from: now.startOfDay(), to: now.endOfDay())
     }
     ```
     */

    var shortcuts: [CalendarShortcut<Value>] = []

    /**
     Allow to choose `nil` date
     
     If you set `true` done button will be wlways enabled
     */
    var allowToChooseNilDate: Bool = false

    /**
     The block to execute after the dismissal finishes
     */
    var dismissHandler: (() -> Void)?

    /**
    The block to execute after "Done" button will be tapped
    */
    var doneHandler: ((Value?) -> Void)?
    
    var updateMonthHandler: ((Date?) -> Void)?
    
    var sendCurrentDateHandler: ((Date?) -> Void)?
    
    private var listmodel: MainListModel!

    /**
     And initial value which will be selected bu default
     */
    var initialValue: Value?

    /**
     Minimal selection date. Dates less then current will be markes as unavailable
     */
    var minimumDate: Date? {
        set {
            self.privateMinimumDate = newValue?.startOfMonth()
        }
        get {
            return self.privateMinimumDate
        }
    }

    /**
    Maximum selection date. Dates greather then current will be markes as unavailable
    */
    var maximumDate: Date? {
        set {
            self.privateMaximumDate = newValue?.endOfMonth()
        }
        get {
            return self.privateMaximumDate
        }
    }

    var isRingVisible: Bool {

        set {
            CalendarSettings.default.dayCell.isRingVisible = newValue
            self.privateisRingVisible = newValue
        }

        get {
            return self.privateisRingVisible
        }
    }
    
    var isPopupVisible: Bool {
        set {
            CalendarSettings.default.dayCell.isPopupVisible = newValue
            self.privateisPopupVisible = newValue
        }

        get {
            return self.privateisPopupVisible
        }
    }
    
    init(setting: CalendarSettings = .default) {
        self.setting = setting
        self.appearance = setting.controller
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        configureUI()
        configureSubviews()
        configureConstraints()
        configureInitialState()
        calendarView.visibleDates { visibleDates in
            if Value.mode == .single {
                self.value = visibleDates.monthDates.first!.date as? Value
            }
        }

    }
    
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        listmodel.removeobserver()
//    }

    /**
       Present FastisController above current top view controller
       
       - Parameters:
          - viewController: view controller which will present FastisController
          - flag: Pass true to animate the presentation; otherwise, pass false.
          - completion: The block to execute after the presentation finishes. This block has no return value and takes no parameters. You may specify nil for this parameter.
       
       */
    func present(above viewController: UIViewController, contentView: UIView) {

        viewController.addChild(self)
        self.didMove(toParent: self)
        
        let width = contentView.frame.width
        let height = contentView.frame.height
        self.view.frame = contentView.bounds
        
        contentView.addSubview(self.view)
    }
    
    func refreshCalendar(date: Date) {
        self.value = date as? Value
        self.selectValue(self.value, in: self.calendarView)
    }

    // MARK: - Configure
    private func configureUI() {
        view.backgroundColor = self.appearance.backgroundColor
    }

    private func configureSubviews() {
        calendarView.register(DayCell.self, forCellWithReuseIdentifier: self.dayCellReuseIdentifier)
        view.addSubViews(self.currentValueView, self.weekdayView, self.calendarView)
//        view.layer.borderWidth = 1   
    }
 
    private func configureConstraints() {

        var screenWidth: CGFloat = 0.0

        var cellSize = (privateisPopupVisible) ? SizeManager().calendarItemSize : SizeManager().bigCalendarItemSize
        calendarView.cellSize = cellSize
        
        currentValueView.snp.makeConstraints { (maker) in
            maker.top.equalTo(view).offset(6)
            maker.left.right.equalToSuperview().inset(8)
        }

        var padding = (privateisPopupVisible) ? SizeManager().calendarItemPadding : SizeManager().bigCalendarPadding
        
        weekdayView.snp.makeConstraints { (maker) in
            maker.top.equalTo(currentValueView.snp.bottom).offset(35)
            maker.left.right.equalToSuperview().inset(padding)
        }
       
        calendarView.snp.makeConstraints { (maker) in
            maker.top.equalTo(weekdayView.snp.bottom).offset(9)
            maker.left.right.equalToSuperview().inset(padding)
            maker.bottom.equalToSuperview()
        }
        
    }

    private func configureInitialState() {
        self.value = self.initialValue
        
        if let date = self.value as? Date {
            calendarView.selectDates([date])
            calendarView.scrollToHeaderForDate(date)
            
        } else {
            let nowDate = Date()
            let targetDate = self.privateMaximumDate ?? nowDate

            if targetDate < nowDate {
                calendarView.selectDates([targetDate])
                calendarView.scrollToHeaderForDate(targetDate)
            } else {
                calendarView.selectDates([nowDate])
                calendarView.scrollToHeaderForDate(nowDate)
            }
        }
        
        calendarView.scrollingMode = .stopAtEachSection
    }

    private func configureCell(_ cell: JTACDayCell, forItemAt date: Date, cellState: CellState,
                               indexPath: IndexPath, updateItem: Bool = false) {

        publishList(date)
        guard let cell = cell as? DayCell else { return }
        if var cachedSettings = self.viewSettings[indexPath] {
            cachedSettings.isRingVisible = privateisRingVisible
            cell.configure(for: cachedSettings, listmodel: listmodel)
        } else {
            var newSettings = DayCell.makeViewSettings(for: cellState, minimumDate: self.privateMinimumDate, maximumDate: self.privateMaximumDate, rangeValue: self.value as? CalendarRange)
            self.viewSettings[indexPath] = newSettings
            cell.applySettings(self.setting.dayCell)
            newSettings.isRingVisible = isRingVisible
            cell.configure(for: newSettings, listmodel: listmodel)

        }
    }

    private func selectValue(_ value: Value?, in calendar: JTACMonthView) {
        if let date = value as? Date {
            calendar.selectDates([date])
        }
    }

    private func handleDateTap(in calendar: JTACMonthView, date: Date) {
        if Value.mode == .single {
            value = date as? Value
            selectValue(date as? Value, in: calendar)
        }
    }

    func publishList(_ date: Date) {
        let strDate = date.changeDateTime(format: .date)
        listmodel = MainListModel(date: strDate)
    }
    
    private func updateAmount(_ cell: JTACDayCell) {

        guard let cell = cell as? DayCell else { return }

        let veggieMaxRate = SettingManager.getMaxValue(keyName: "VeggieAmount") ?? 0
        let fruitMaxRate = SettingManager.getMaxValue(keyName: "FruitAmount") ?? 0

        let veggie = Float(cell.ringButton.ringProgressView.ring1.progress.clean) ?? 0
        let fruit = Float(cell.ringButton.ringProgressView.ring2.progress.clean) ?? 0

        if veggie <= 0  || fruit <= 0 { return }
        let veggieSum = veggie * veggieMaxRate
        let fruitSum = fruit * fruitMaxRate
        currentValueView.updateAmount(veggieSum: Int(veggieSum.rounded(.towardZero)), fruitSum: Int(fruitSum.rounded(.towardZero)))
        
    }

    private func updateDate(date: Date) {
        currentValueView.updateDate(date: date)
    }
    
    func configureCalendar(_ calendar: JTACMonthView) -> ConfigurationParameters {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy MM dd"
        dateFormatter.timeZone = currentCalendar.timeZone
        dateFormatter.locale = currentCalendar.locale
        var startDate = dateFormatter.date(from: "2000 01 01")!
        var endDate = dateFormatter.date(from: "2030 12 01")!

        if let maxinumDate = privateMaximumDate {
            let endOfNextMonth = maxinumDate
            endDate = endOfNextMonth
        }
        if let minimumDate = privateMinimumDate {
            let startOfPreviousMonth = minimumDate
            startDate = startOfPreviousMonth
        }

        let parameters = ConfigurationParameters(startDate: startDate,
                                                 endDate: endDate,
                                                 numberOfRows: 6,
                                                 calendar: self.currentCalendar,
                                                 generateInDates: .forAllMonths,
                                                 generateOutDates: .off,
                                                 firstDayOfWeek: .monday,
                                                 hasStrictBoundaries: true)
        return parameters

    }

    // MARK: JTAppleCalendarDelegate & JTAppleCalendarDataSource
    func calendar(_ calendar: JTACMonthView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTACDayCell {
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: self.dayCellReuseIdentifier, for: indexPath)
        configureCell(cell, forItemAt: date, cellState: cellState, indexPath: indexPath)
        return cell
    }

    func calendar(_ calendar: JTACMonthView, willDisplay cell: JTACDayCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
        configureCell(cell, forItemAt: date, cellState: cellState, indexPath: indexPath)
    }

    func calendar(_ calendar: JTACMonthView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {

        if Value.mode == .single {
            self.value = visibleDates.monthDates.first!.date as? Value
        }
    }

    func calendar(_ calendar: JTACMonthView, didSelectDate date: Date, cell: JTACDayCell?, cellState: CellState, indexPath: IndexPath) {
       
       if cellState.selectionType == .some(.userInitiated) {
           self.handleDateTap(in: calendar, date: date)
       } else if let cell = cell {
           self.configureCell(cell, forItemAt: date, cellState: cellState, indexPath: indexPath)

        if privateisRingVisible == true {
            self.updateAmount(cell)
        } else {
            self.updateDate(date: date)

            if date <= Date() {
                self.doneHandler?(self.value)
            }
        }

       }
    }

    public func calendar(_ calendar: JTACMonthView, didDeselectDate date: Date, cell: JTACDayCell?, cellState: CellState, indexPath: IndexPath) {

        if let cell = cell {
            self.configureCell(cell, forItemAt: date, cellState: cellState, indexPath: indexPath)
        }
    }
//
    func calendar(_ calendar: JTACMonthView, shouldSelectDate date: Date, cell: JTACDayCell?, cellState: CellState, indexPath: IndexPath) -> Bool {
        self.viewSettings.removeAll()
        return true
    }

    func calendar(_ calendar: JTACMonthView, shouldDeselectDate date: Date, cell: JTACDayCell?, cellState: CellState, indexPath: IndexPath) -> Bool {
        self.viewSettings.removeAll()
        return true
    }

     // MARK: - Variables
     private let setting: CalendarSettings
     private var appearance: CalendarSettings.Controller = CalendarSettings.default.controller

     private let dayCellReuseIdentifier = "DayCellReuseIdentifier"
     private var viewSettings: [IndexPath: DayCell.ViewSettings] = [:]
     private var currentCalendar: Calendar = .autoupdatingCurrent
     private var privateMinimumDate: Date?
     private var privateMaximumDate: Date?

     private var value: Value? {
         didSet {
             self.currentValueView.currentValue = self.value
            sendCurrentDateHandler?(self.value as? Date)
         }
     }

    private var privateisRingVisible: Bool = true
    private var privateisPopupVisible: Bool = true

}

extension CalendarController where Value == CalendarRange {

    /// Initiate FastisController
    /// - Parameters:
    ///   - mode: Choose `.range` or `.single` mode
    ///   - config: Custom configuration parameters. Default value is equal to `FastisConfig.default`
    convenience init(mode: CalendarRange, setting: CalendarSettings = .default) {
        self.init(setting: setting)
    }
}

extension CalendarController where Value == Date {

    /// Initiate FastisController
    /// - Parameters:
    ///   - mode: Choose .range or .single mode
    ///   - config: Custom configuration parameters. Default value is equal to `CalendarSettings.default`
    convenience init(mode: CalendarModeSingle, setting: CalendarSettings = .default) {
        self.init(setting: setting)
        calendarView.reloadData()
    }

}

extension CalendarSettings {
    struct Controller {
        var titleTextAttributes: [NSAttributedString.Key: Any] = [:]
        var backgroundColor: UIColor = .white
    }
}

extension CalendarController: MonthSelectViewProtocol {

    func pressedArrow(tag: Int) {
        switch tag {
        case 0:
            calendarView.scrollToSegment(.previous)
        default:
            calendarView.scrollToSegment(.next)
        }
    }

}
