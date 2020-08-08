//
//  SettingVC.swift
//  VFCounter
//
//  Created by Sunmi on 2020/08/05.
//  Copyright © 2020 creativeSun. All rights reserved.
//

import UIKit
import SnapKit

class SettingVC: UIViewController {

    enum Section: CaseIterable {
        case main
    }
    let tableView = UITableView(frame: .zero, style: .insetGrouped)
    var dataSource: UITableViewDiffableDataSource<Section, SettingController.Settings>! = nil
    var currentDataSource: NSDiffableDataSourceSnapshot<Section, SettingController.Settings>! = nil
    let settingController = SettingController()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "설정"
        configureTableView()
        configureDataSource()
        updateData()
    }
    
}


/// set tableview

extension SettingVC {
    
    func configureTableView() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        tableView.delegate = self
        tableView.register(SettingItemCell.self, forCellReuseIdentifier: SettingItemCell.reuseIdentifier)
        tableView.backgroundColor = ColorHex.iceBlue
    }
    
    func configureDataSource() {
        dataSource = UITableViewDiffableDataSource<Section, SettingController.Settings>(tableView: tableView) {
            (tableView: UITableView,indexPath: IndexPath, items: SettingController.Settings) -> UITableViewCell? in
           
            // get a cell
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SettingItemCell.reuseIdentifier, for: indexPath) as? SettingItemCell
            else {
                    fatalError("Cannot create new cell")
                }

            // insert data to cell
            cell.imageView?.image = items.image
            cell.textLabel?.text = items.name
            
            if items.name == "알림설정" {
                cell.accessoryType = .disclosureIndicator
            } else {
                cell.accessoryType = .none
            }
            
            return cell
        }
    }
    
    func updateData() {
        currentDataSource = NSDiffableDataSourceSnapshot <Section, SettingController.Settings>()
        
        currentDataSource.appendSections([.main])
        settingController.collections.forEach {
            currentDataSource.appendItems([$0])
        }
        
        dataSource.apply(currentDataSource, animatingDifferences: false)
    }
    
    func navigateVC(to item : Int) {
        
        let subviewController = [ AlarmSettingVC()]
        navigationController?.pushViewController(subviewController[item], animated: true)
    }
}

extension SettingVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        navigateVC(to: indexPath.item)
        
    }
    
    

}
