//
//  MonthlyListVC.swift
//  VFCounter
//
//  Created by Sunmi on 2020/09/22.
//  Copyright © 2020 creativeSun. All rights reserved.
//

import UIKit
import CoreStore

class PeriodListVC: UIViewController {
  
    weak var delegate: UpdateDateDelegate?
    var sectionControl: CustomSegmentedControl!
    var strategy: DateStrategy!
    private var model: PeriodListModel!
    var tableView: UITableView!
    var valueConfig: ValueConfig?
    var popupItem = PopupItem()
    
    var listmodel: PeriodListModel {
        return model
    }

    var date: Date? {
        didSet {
            if let newDate = date {
                strategy.date = newDate
                strategy.updatePeriod()
            }
        }
    }
    
    init(delegate: UpdateDateDelegate, strategy: DateStrategy, valueConfig: ValueConfig) {
        super.init(nibName: nil, bundle: nil)
        self.delegate = delegate
        self.strategy = strategy
        self.valueConfig = valueConfig
        model = PeriodListModel(strategy: strategy, kind: .list)

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        configureTableView()
        model.loadTableView()
    }
    
    func scrollToSection(date: String) {
    
        let section = model.findSections(date: date)
        tableView.scrollToTop(animated: true, section: section)
    }
    
    func createEntity(item: Items, config: ValueConfig) {
        model.createEntity(item: item, config: config)
    }
    lazy var stackView: UIStackView = {
          let stackView = UIStackView()
          stackView.spacing = 130
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

    let lblPeriod = VFTitleLabel(textAlignment: .center, font: .systemFont(ofSize: SizeManager().dateViewFontSize))

}

/////
extension PeriodListVC {

    @objc func changedIndexSegment(sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            model.setting.selectedIndex = sender.selectedSegmentIndex
        default:
            model.setting.selectedIndex = sender.selectedSegmentIndex
        }
    }

    func displayMessage(pItem: PopupItem, nKind: Int) {
        
        var text = ""
        
        switch nKind {
        case 0:
            text = "\(pItem.oldItem) 삭제완료"
        case 1:
            text = "\(pItem.oldItem) -> \(pItem.newItem)\n 업데이트"
        case 2:
            text = "\(pItem.oldDate) -> \(pItem.newDate) \n 업데이트"
        default:
            text = "\(pItem.oldItem) -> \(pItem.newItem), \(pItem.newDate) \n 업데이트"
        }
            
        self.presentAlertVC(title: "", message: text, buttonTitle: "OK")
    }
    
    func displayPopUpWithComparison() {
        if popupItem.oldDate == popupItem.newDate {
            
            if popupItem.oldItem != popupItem.newItem {
                displayMessage(pItem: popupItem, nKind: 1)
            }
            
        } else {
            if popupItem.oldItem == popupItem.newItem {
                displayMessage(pItem: popupItem, nKind: 2)
            } else {
                displayMessage(pItem: popupItem, nKind: 3)
            }
        }
    }
    
    func getMinMaxDate() -> [Date] {
        let datemap = strategy.getDateMap()
        var minDate: Date?
        var maxDate: Date?
        
        let firstDate = datemap.first
        var lastDate = datemap.last
    
        minDate = firstDate
        if lastDate == Date() {
            maxDate = lastDate?.dayBefore
        } else {
            maxDate = lastDate
        }
        return [minDate!, maxDate!]
    }
    
    func configureTableView() {

        tableView = UITableView(frame: view.bounds, style: .grouped)
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(stackView.snp.bottom).offset(8)
            make.leading.trailing.equalTo(view)
            make.bottom.equalTo(view)
        }
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = SizeManager().getUserItemHeight + 15
        tableView.register(ElementCell.self, forCellReuseIdentifier: ElementCell.reuseIdentifier)
        tableView.backgroundColor = ColorHex.iceBlue
        tableView.delegate = self
        model.setupTableView(tableView: tableView, periodListVC: self)
    }
    
    @objc func tappedBefore() {
        let value = self.strategy.previous()
        strategy.updatePeriod()
        if value {
            self.lblPeriod.text = self.strategy.period
            self.model.refreshHandler?(self.strategy)
        }
    }

    @objc func tappedNext() {

        let value = self.strategy.next()
        strategy.updatePeriod()
        if value {
       	 self.lblPeriod.text = self.strategy.period
         self.model.refreshHandler?(self.strategy)
        }
    }
}

// MARK: - UITableView delegate
extension PeriodListVC: UITableViewDelegate {

    // MARK: - UITableViewDelegate

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return self.model.sectionTitle(forSection: section) == nil ? CGFloat.leastNormalMagnitude : 35
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        let sumheaderView = SumHeaderView()
        let width = ScreenSize.width
        
        sumheaderView.frame = CGRect(x: 10, y: -2, width: width - 20, height: 35)
        headerView.addSubview(sumheaderView)
        
        guard listmodel.datemaps.count > 0 else { return nil }
        let date = model.datemaps[section]
        let sum = model.getSumItems(date: date)
        sumheaderView.updateHeader(date: date, sumV: sum.0, sunF: sum.1)

        return headerView
    }

}

extension PeriodListVC: ItemCellDelegate {
    
    func updateSelectedItem(item: Items) {
        guard let config = valueConfig else { return }
        guard !self.amountWarning(config: config, type: item.type) else { return }
       
        popupItem.oldItem = item.name
        popupItem.oldDate = item.date
        
        let arrDate = getMinMaxDate()
        let model = ItemModel(date: item.date, type: item.type, config: config, minDate: arrDate[0],
                              maxDate: arrDate[1])
        
        self.displayPickItemVC(model, item, currentVC: self)
    }
    
    func deleteItem(date: String, index: Int, type: String) {
        model.dm.deleteEntity(date: date, index: index, type: type)
        
    }
    
}

extension PeriodListVC: PickItemProtocol {
    func addItems(item: Items) { }
    
    func updateItems(item: Items, oldDate: Date) {
        popupItem.newItem = item.name
        popupItem.newDate = item.date
        
        let newDate = item.date.changeDateTime(format: .date)
        let strOld = oldDate.changeDateTime(format: .date)
        model.updateItem.olddate = strOld
        model.updateItem.date = item.date
        model.dm.modifyEntity(item: item, oldDate: oldDate, editDate: newDate)
        displayPopUpWithComparison()
    }

}
