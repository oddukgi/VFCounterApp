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
            listmodel?.setting.selectedIndex = sender.selectedSegmentIndex
        default:
            listmodel?.setting.selectedIndex = sender.selectedSegmentIndex
        }
    }


    func displayMessage(model: ItemDate, nKind: Int) {
        
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

    // MARK: - UITableViewDelegate

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return self.listmodel?.sectionTitle(forSection: section) == nil ? CGFloat.leastNormalMagnitude : 35
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        let sumheaderView = SumHeaderView()
        let width = ScreenSize.width
        
        sumheaderView.frame = CGRect(x: 10, y: -2, width: width - 20, height: 35)
        headerView.addSubview(sumheaderView)
        
        guard let model = listmodel, model.datemaps.count > 0 else { return nil }
        let date = model.datemaps[section]
        let sum = model.getSumItems(date: date)
        sumheaderView.updateHeader(date: date, sumV: sum.0, sunF: sum.1)

        return headerView
    }

}
