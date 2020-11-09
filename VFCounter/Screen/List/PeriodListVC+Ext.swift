//
//  ElementDataSource.swift
//  VFCounter
//
//  Created by Sunmi on 2020/09/22.
//  Copyright © 2020 creativeSun. All rights reserved.
//

import UIKit

extension PeriodListVC {

    @objc func changedIndexSegment(sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            listmodel.setting.selectedIndex = sender.selectedSegmentIndex
        default:
            listmodel.setting.selectedIndex = sender.selectedSegmentIndex
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
}

// MARK: - UITableView delegate
extension PeriodListVC: UITableViewDelegate {

    // MARK: - UITableViewDelegate

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return self.listmodel.sectionTitle(forSection: section) == nil ? CGFloat.leastNormalMagnitude : 35
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        let sumheaderView = SumHeaderView()
        let width = ScreenSize.width
        
        sumheaderView.frame = CGRect(x: 10, y: -2, width: width - 20, height: 35)
        headerView.addSubview(sumheaderView)
        
        guard listmodel.datemaps.count > 0 else { return nil }
        let date = listmodel.datemaps[section]
        let sum = listmodel.getSumItems(date: date)
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
        listmodel.dm.deleteEntity(date: date, index: index, type: type)
        
    }
}

extension PeriodListVC: PickItemProtocol {
    func addItems(item: Items) { }
    
    func updateItems(item: Items, oldDate: Date) {
        popupItem.newItem = item.name
        popupItem.newDate = item.date
        
        let newDate = item.date.changeDateTime(format: .date)
        let strOld = oldDate.changeDateTime(format: .date)
        listmodel.updateItem.olddate = strOld
        listmodel.updateItem.date = item.date
        listmodel.dm.modifyEntity(item: item, oldDate: oldDate, editDate: newDate)
        displayPopUpWithComparison()
    }

}
