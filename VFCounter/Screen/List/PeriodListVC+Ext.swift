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
            selectedIndex = sender.selectedSegmentIndex
        default:
            selectedIndex = sender.selectedSegmentIndex
        }
    }
    
    func scrollToItem(date: Date, model: ItemModel, nKind: Int) {

        let newDate = date.changeDateTime(format: .longDate)
        var section = 0
        weekday.forEach { (item) in
            if item.contains(newDate) {
                section = weekday.firstIndex(of: newDate) ?? 0
            }
        }
    
        let indexPath = IndexPath(row: 0, section: section)
        self.displayMessage(model: model, nKind: nKind, indexPath: indexPath)
    
    }
    
    func displayMessage(model: ItemModel, nKind: Int, indexPath: IndexPath) {
        
        var text = ""
        
            if indexPath.section > 3 {
                self.tableView.scrollToRow(at: indexPath, at: .middle, animated: true)
            }
        
            switch nKind {
            case 0:
                text = "\(model.oldItem) 삭제완료"
            case 1:
                text = "\(model.oldItem) -> \(model.newItem)\n 업데이트"
            case 2:
                text = "\(model.oldItem): \(model.oldDate) -> \(model.newDate) \n 업데이트"
            default:
                text = "\(model.oldItem) -> \(model.newItem), \(model.newDate) \n 업데이트"
            }
            
        DispatchQueue.main.async {
            self.presentAlertVC(title: "", message: text, buttonTitle: "OK")
        }
    }
}

// MARK: - UITableView delegate
extension PeriodListVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        let dm = DataManager()
        let sumheaderView = SumHeaderView()
        let width = ScreenSize.width
       
        sumheaderView.frame = CGRect(x: 10, y: -2, width: width - 20, height: 44)
        headerView.addSubview(sumheaderView)
        let sumMap = dm.getSumItems(date: weekday[section].extractDate)
        sumheaderView.updateHeader(date: weekday[section].extractDate,
                                   sumV: sumMap.0, sunF: sumMap.1)
        return headerView
    }

}

// MARK: - UITableView datasource
extension PeriodListVC: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return weekday.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return periodData.arrTBCell[section].subcategory.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(withIdentifier: ElementCell.reuseIdentifier, for: indexPath) as? ElementCell else { return UITableViewCell() }

        let section = indexPath.section
        var value: [DataType] = []
        let categoryCount = periodData.arrTBCell[section].subcategory.count
        
        if  categoryCount == 2 {
            value = periodData.arrTBCell[section].data[indexPath.row]
            
        } else {
            (0..<2).forEach { index in
                if periodData.arrTBCell[section].data[index].count > 0 {
                    value = periodData.arrTBCell[section].data[index]
                }
            }
        }
        
        cell.data = value
        cell.delegate = self
        cell.layoutIfNeeded()

        return cell
    }
}

// MARK: - Protocol Extension
extension PeriodListVC: ElementCellProtocol {

    func updateNewItem(date: Date, model: ItemModel, deletedSection: Bool) {
        if deletedSection { updateEmptyItem(date: model.oldDate) }
        changeDefaultDate(date: date)
        updatePeriod()
        updateResource()
        
        self.initializeData()
        
        if deletedSection { updateEmptyItem(date: model.oldDate) }
        
        if model.oldItem == model.newItem {
            scrollToItem(date: date, model: model, nKind: 2)
        } else {
            scrollToItem(date: date, model: model, nKind: 3)
        }
    }
    func updateItem(date: Date, model: ItemModel, deletedSection: Bool) {
        if deletedSection { updateEmptyItem(date: model.oldDate) }
        tableView.reloadData()
        
        scrollToItem(date: date, model: model, nKind: 1)
    }
    
    func updateEmptyItem(date: String) {
        
        for (index, item) in weekday.enumerated() {
            if item.hasPrefix(date) {
                weekday.remove(at: index)
            }
        }
        tableView.reloadData()
    }

    func updateDeleteItem(date: Date, model: ItemModel) {
        updatePeriod()
        updateResource()
        DispatchQueue.main.async {
            self.initializeData()
        }
        tableView.reloadData()
        
        scrollToItem(date: date, model: model, nKind: 0)
        NotificationCenter.default.post(name: .updateFetchingData, object: nil, userInfo: ["createdDate": date])
    }
    
    func displayPickItemVC(pickItemVC: PickItemVC) {
        DispatchQueue.main.async {
            let navController = UINavigationController(rootViewController: pickItemVC)
            self.present(navController, animated: true)
        }
    }

    func presentSelectedAlertVC(indexPath: IndexPath, selectedDate: String,
                                elementCell: ElementCell) {

        let alert = UIAlertController(title: "", message: "아이템을 삭제하겠습니까?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "아니오", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "네", style: .destructive, handler: { _ in
            elementCell.deleteTableViewItem(indexPath: indexPath, selectedDate: selectedDate)
        }))

        self.present(alert, animated: true, completion: nil)
    }
    
    func getSelectedDate(index: Int, tableViewCell: ElementCell) -> String {
        let data = tableViewCell.data[index]
        return data.date ?? ""
    }

}

extension PeriodListVC: CustomTableViewDelegate {
    
    func tableViewDidTapBelowCells(tableView: UITableView, section: Int) {
        tableSection = section
    }
    
}
