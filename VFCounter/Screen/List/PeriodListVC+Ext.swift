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

extension PeriodListVC: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return weekday.count

    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel.init(frame: CGRect.init(x: 20, y: 0, width: tableView.frame.size.width, height: 44))
        label.textColor = UIColor.black
        label.text = self.weekday[section]
        label.font = NanumSquareRound.bold.style(sizeOffset: 15)
        return label
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
