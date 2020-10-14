//
//  AlarmSettingVC+Ext.swift
//  VFCounter
//
//  Created by Sunmi on 2020/08/05.
//  Copyright © 2020 creativeSun. All rights reserved.
//

import UIKit

extension AlarmSettingVC {

    func configure<T: UITableViewCell>(_ tableType: T.Type, for indexPath: IndexPath,
                                       reuseIdentifer: String) -> T {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifer, for: indexPath) as? T
        else {
            fatalError("Unable to dequeue \(tableType)")
        }

        return cell
    }

}

extension AlarmSettingVC: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let sectionKind = Section(rawValue: section)
        return sectionKind?.description()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        var tableViewCell = UITableViewCell()
        if indexPath.section == 0 {

            switch indexPath.item {
            case 0:
                guard let cell = self.configure(SwitchVeggieCell.self, for: indexPath, reuseIdentifer: SwitchVeggieCell.reuseIdentifier) as? SwitchVeggieCell else { return UITableViewCell()  }
                cell.delegate = self
                tableViewCell = cell

            default:
                guard let cell =  self.configure(MaxAmountVeggieCell.self, for: indexPath, reuseIdentifer: MaxAmountVeggieCell.reuseIdentifier) as? MaxAmountVeggieCell else { return UITableViewCell() }
                cell.delegate = self
                tableViewCell = cell

            }
        } else {
            switch indexPath.item {
            case 0:
                guard let cell = self.configure(SwitchFruitCell.self, for: indexPath, reuseIdentifer: SwitchFruitCell.reuseIdentifier) as? SwitchFruitCell else { return UITableViewCell()  }
                cell.delegate = self
                tableViewCell = cell
            default:
                guard let cell =  self.configure(MaxAmountFruitCell.self, for: indexPath, reuseIdentifer: MaxAmountFruitCell.reuseIdentifier) as? MaxAmountFruitCell else { return UITableViewCell() }
                cell.delegate = self
                tableViewCell = cell
            }
        }

        return tableViewCell
    }
}

extension AlarmSettingVC: MaxAmoutVeggieCellDelegate {

    func displayAlertMessageV(value: Float) {
        let message = "\(value)는 1 ~ 500 사이의 값이 아닙니다."
        self.presentAlertVC(title: "범위 초과", message: message, buttonTitle: "OK")
    }

    func textField(editingDidBeginIn cell: MaxAmountVeggieCell) {
        if let indexPath = tableView?.indexPath(for: cell) {
            print("textfield selected in cell at \(indexPath)")
        }
    }

    func textField(editingChangedInTextField newText: String, in cell: MaxAmountVeggieCell) {
        if let indexPath = tableView?.indexPath(for: cell) {
//            print("updated text in textfield in cell as \(indexPath), value = \"\(newText)\"")

        }
    }
}

extension AlarmSettingVC: MaxAmoutFruitCellDelegate {

    func displayAlertMessageF(value: Float) {
        let message = "\(value)는 1 ~ 500 사이의 값이 아닙니다."
        self.presentAlertVC(title: "범위 초과", message: message, buttonTitle: "OK")
    }

    func textField(editingDidBeginIn cell: MaxAmountFruitCell) {
        if let indexPath = tableView?.indexPath(for: cell) {
//            print("textfield selected in cell at \(indexPath)")
        }
    }

    func textField(editingChangedInTextField newText: String, in cell: MaxAmountFruitCell) {
        if let indexPath = tableView?.indexPath(for: cell) {
//            print("updated text in textfield in cell as \(indexPath), value = \"\(newText)\"")

        }
    }
}

// MARK: - SwitchControl Delegate

extension AlarmSettingVC: SwitchVeggieDelegate {
    func updateVeggieSwitch(_ flag: Bool) {
        // Enable/ Disable slider
        guard let veggiecell = tableView.cellForRow(at: IndexPath(item: 1, section: 0))
                as? MaxAmountVeggieCell else { return }

        veggiecell.maxAmountTF.isEnabled = flag
        veggiecell.veggieSlider.isEnabled = flag
    }

}

extension AlarmSettingVC: SwitchFruitDelegate {
    func updateFruitSwitch(_ flag: Bool) {
        // Enable/ Disable slider
        guard let fruitCell = tableView.cellForRow(at: IndexPath(item: 1, section: 1))
                as? MaxAmountFruitCell else { return }

        fruitCell.maxAmountTF.isEnabled = flag
        fruitCell.fruitSlider.isEnabled = flag
    }
}
