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
    
    func findsection(for date: String) -> Int {
        var section = 0
        weekday.forEach { (item) in
            if item.contains(date) {
                section = weekday.firstIndex(of: date) ?? 0
            }
        }
        
        return section
    }
    
    func scrollToItem(date: Date, model: ItemModel, nKind: Int) {

        let newDate = date.changeDateTime(format: .longDate)
        var section = 0
        weekday.forEach { (item) in
            if item.contains(newDate) {
                section = weekday.firstIndex(of: newDate) ?? 0
            }
        }
        
        if section > 1 {
            self.tableView.scrollToTop(animated: true, section: section)
        }
        self.displayMessage(model: model, nKind: nKind)
    }
    
    func displayMessage(model: ItemModel, nKind: Int) {
        
        var text = ""
        
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
            
        self.presentAlertVC(title: "", message: text, buttonTitle: "OK")
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
        
        let numberOfRow = periodData.arrTBCell[section].subcategory.count
        return numberOfRow
        
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(withIdentifier: ElementCell.reuseIdentifier, for: indexPath) as? ElementCell else { return UITableViewCell() }

        let section = indexPath.section
        var value: [DataType] = []
        let categoryCount = periodData.arrTBCell[section].subcategory.count
        
        if  categoryCount == 2 {
            value = periodData.arrTBCell[section].data[indexPath.row]
            
        } else {
            
            let numberOfRow = periodData.arrTBCell[section].subcategory.count
            for i in 0..<numberOfRow {
                var data = periodData.arrTBCell[section].data[i]
                
                if data.count > 0 {
                    value = data
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
        DispatchQueue.main.async {
            self.initializeData()
        }
        self.tableView.reloadData()
        
        if deletedSection { updateEmptyItem(date: model.oldDate) }
    
        if model.oldItem == model.newItem {
            scrollToItem(date: date, model: model, nKind: 2)
        } else {
            scrollToItem(date: date, model: model, nKind: 3)
        }
    }
    func updateItem(date: Date, model: ItemModel, deletedSection: Bool) {
        if deletedSection { updateEmptyItem(date: model.oldDate) }
        self.tableView.reloadData()
        scrollToItem(date: date, model: model, nKind: 1)
    }
    
    func updateEmptyItem(date: String) {
        
        for (index, item) in weekday.enumerated() {
            if item.hasPrefix(date) {
                weekday.remove(at: index)
            }
        }
    
    }

    fileprivate func updateTableView(indexPath: IndexPath,
                                     _ deletedSection: Bool, _ model: ItemModel,
                                     _ elementCell: ElementCell) {
    
        var item = indexPath.item
        let section = indexPath.section
        
        print(item, section)
        if deletedSection {
            updateEmptyItem(date: model.oldDate)
            if item == 1 { item = item - 1 }
//            periodData.arrTBCell[section].subcategory.remove(at: item)
            self.tableView.deleteSections(IndexSet(integer: section), with: .none)
        } else {
            
            let newDate = model.oldDate.extractDate
            let dm = DataManager()
            let count = dm.getEntityCount(date: newDate, section: item)
            if count == 0 {
                periodData.arrTBCell[section].subcategory.remove(at: item)
                self.tableView.deleteRows(at: [IndexPath(item: item, section: section)], with: .top)
            } else {
                updatePeriod()
                updateResource()
                DispatchQueue.main.async {
                    self.initializeData()
                }
                self.tableView.reloadData()
       
            }
        }
    }
    
    func updateDeleteItem(model: ItemModel, deletedSection: Bool, elementCell: ElementCell) {
        // if data count is zero, called emptyItem methods
        let section = findsection(for: model.oldDate)
        var items = periodData.arrTBCell[section].data
        var item = 0
        let count = tableView.numberOfRows(inSection: section)
        
       for i in 0..<count {
           for (j, data) in items[i].enumerated() {
               if data.createdDate == model.entityDT {
                item = i
                items[i].remove(at: j)
               }
           }
       }

        let newIndexPath = IndexPath(item: item, section: section)
        updateTableView(indexPath: newIndexPath, deletedSection, model, elementCell)
        self.displayMessage(model: model, nKind: 0)
        NotificationCenter.default.post(name: .updateFetchingData, object: nil, userInfo: ["createdDate": model.entityDT])
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
