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
}

// MARK: - UITableView delegate
extension PeriodListVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 44))

        let label = UILabel()
        label.frame = CGRect.init(x: 5, y: 5, width: headerView.frame.width-10, height: headerView.frame.height-10)
        label.text = self.weekday[section]
        label.font = NanumSquareRound.bold.style(offset: 15)
        label.textAlignment = .left
        label.textColor = ColorHex.darkGreen
        headerView.addSubview(label)

        return headerView
    }
}
// MARK: - UITableView datasource
extension PeriodListVC: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return weekday.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(withIdentifier: ElementCell.reuseIdentifier, for: indexPath) as? ElementCell else {
            return UITableViewCell()
        }
        let newDate = weekday[indexPath.section].components(separatedBy: " ")[0]
        cell.updateDate(newDate)
        cell.delegate = self
        cell.layoutIfNeeded()

        return cell
    }

}
