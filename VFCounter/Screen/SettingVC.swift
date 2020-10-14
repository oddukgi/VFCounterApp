//
//  SettingVC.swift
//  VFCounter
//
//  Created by Sunmi on 2020/08/05.
//  Copyright © 2020 creativeSun. All rights reserved.
//

import UIKit
import MessageUI

class SettingVC: UIViewController {

    enum Section: String, CaseIterable {

        case defaultSection, aboutSection

        var title: String {
            switch self {
            case .defaultSection:
               return "기본설정"
            case .aboutSection:
               return "About"
            }
         }
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
        tableView.reloadData() 
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
        dataSource = UITableViewDiffableDataSource<Section, SettingController.Settings>(tableView: tableView) {(tableView: UITableView, indexPath: IndexPath, items: SettingController.Settings) -> UITableViewCell? in

            // get a cell
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SettingItemCell.reuseIdentifier, for: indexPath) as? SettingItemCell
            else {
                    fatalError("Cannot create new cell")
                }

            self.setItemStyle(cell, indexPath: indexPath, settings: items)
            return cell
        }
    }
    
//    let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 44))
//
//    let label = UILabel()
//    label.frame = CGRect.init(x: 5, y: 5, width: headerView.frame.width-10, height: headerView.frame.height-10)
//    label.text = self.weekday[section]
//    label.font = NanumSquareRound.bold.style(offset: 15)
//    label.textColor = ColorHex.darkGreen

    func setItemStyle(_ cell: UITableViewCell, indexPath: IndexPath, settings: SettingController.Settings) {

        let section = indexPath.section
        let item    = indexPath.item
        
        cell.selectionStyle = .none
        switch section {
        case 0:
            item == 0 ? (cell.accessoryType = .disclosureIndicator) : (cell.accessoryType = .none)
            cell.imageView?.image = settings.image?.resized(toWidth: 20)
            cell.textLabel?.text = settings.name
            cell.textLabel?.font = NanumSquareRound.bold.style(offset: 16)

        default:
            if item == 0 {
                let font = NanumSquareRound.bold.style(offset: 16.5)
                let label = VFBodyLabel()
                label.font = font
                label.textColor = .black
                label.text = UIApplication.appVersion!
                label.sizeToFit()
                
                cell.accessoryView = label
                cell.textLabel?.text = settings.name
                cell.textLabel?.font = NanumSquareRound.bold.style(offset: 16)

            } else {
                cell.accessoryType = .none
                cell.textLabel?.text = settings.name
                cell.textLabel?.font = NanumSquareRound.bold.style(offset: 16)

            }
        }
    }
    func updateData() {
        currentDataSource = NSDiffableDataSourceSnapshot <Section, SettingController.Settings>()

        let sections = Section.allCases

         sections.forEach { item in
            currentDataSource.appendSections([item])
          }

        settingController.defaults.forEach {
            currentDataSource.appendItems([$0], toSection: Section.defaultSection)
        }

        settingController.appInfo.forEach {
            currentDataSource.appendItems([$0], toSection: Section.aboutSection)
        }

        dataSource.apply(currentDataSource, animatingDifferences: false)
    }

    func navigateVC(to item: Int) {

        let subviewController = [ AlarmSettingVC()]
        navigationController?.pushViewController(subviewController[item], animated: true)
    }

    // send feedback for developer

    func configureMailForm(emailAddress: String, systemVersion: String, appVersion: String) -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self
        mailComposerVC.setToRecipients([emailAddress])
        mailComposerVC.setSubject("VFCounter Feedback")

        let body = String(format: NSLocalizedString("\n Thanks for your feedback!\n Write down bugs or request here. :)\n\n\n=====\niOS Version: %@\nApp Version: %@\n=====", comment: ""), systemVersion, appVersion)
        mailComposerVC.setMessageBody(body, isHTML: false)
        return mailComposerVC
    }

    func sendEmailToDeveloper() {
        let userSystemVersion = UIDevice.current.systemVersion
        let appVersion = UIApplication.appVersion!

        let mailcomposerVC = self.configureMailForm(emailAddress: "sm.kang666@gmail.com", systemVersion: userSystemVersion, appVersion: appVersion)

        if MFMailComposeViewController.canSendMail() {
            self.present(mailcomposerVC, animated: true, completion: nil)
        }
    }

}

extension SettingVC: UITableViewDelegate {

//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 50
//    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 50))

        let label = UILabel()
        label.frame = CGRect.init(x: 5, y: 5, width: headerView.frame.width-10, height: headerView.frame.height-10)
        label.text = Section.allCases[section].title
        label.font = NanumSquareRound.bold.style(offset: 15)
        label.textColor = ColorHex.darkGreen

        headerView.addSubview(label)

        return headerView
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let section = indexPath.section
        switch section {

        case 0:
        if indexPath.item == 0 {
            navigateVC(to: indexPath.item)
        }

        default:
          if indexPath.item == 1 {
             sendEmailToDeveloper()
          }
        }
    }
}

extension SettingVC: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
}
