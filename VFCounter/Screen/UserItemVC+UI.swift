//
//  UserItemVC+UI.swift
//  VFCounter
//
//  Created by Sunmi on 2020/07/24.
//  Copyright © 2020 creativeSun. All rights reserved.
//

import UIKit
import SnapKit
import CoreStore

extension UserItemVC {

// MARK: create collectionView layout

    fileprivate func updateCircularView(veggieValue: Int, fruitValue: Int) {
        circularView.ringView.maxVeggies = Double(veggieValue)
        circularView.ringView.maxFruits = Double(fruitValue)
    }

    func alreadyLoadingApp() {

        let veggieRate = SettingManager.getTaskValue(keyName: "VeggieTaskRate") ?? 0
        SettingManager.setVeggieTaskRate(percent: veggieRate)
        itemSetting.valueConfig.maxVeggies = Int(veggieRate)

        let fruitRate = SettingManager.getTaskValue(keyName: "FruitTaskRate") ?? 0
        SettingManager.setFruitsTaskRate(percent: fruitRate)
        itemSetting.valueConfig.maxFruits = Int(fruitRate)

        updateCircularView(veggieValue: Int(veggieRate), fruitValue: Int(fruitRate))
    }

    func firstLoadingApp() {

        SettingManager.setVeggieTaskRate(percent: Float(defaultRate))
        SettingManager.setFruitsTaskRate(percent: Float(defaultRate))
        itemSetting.valueConfig.maxVeggies = defaultRate
        itemSetting.valueConfig.maxFruits = defaultRate
        updateCircularView(veggieValue: defaultRate, fruitValue: defaultRate)

        SettingManager.setVeggieAlarm(veggieFlag: true)
        SettingManager.setFruitsAlarm(fruitsFlag: true)
    }

    func getAppLoadingStatus() -> Bool {

         let flag = SettingManager.getInitialLaunching(keyName: "InitialLaunching")

         if flag == true {
            return true
        } else {
            SettingManager.setInitialLaunching(flag: true)
            return false
        }
    }
    
    func configureHierarchy() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout:
                                            UIHelper.createHorizontalLayout(titleElemendKind: itemSetting.titleElementKind, isPaddingForSection: true))
        collectionView.backgroundColor = ColorHex.iceBlue
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(circularView.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }
        
        collectionView.register(ItemCell.self, forCellWithReuseIdentifier: ItemCell.reuseIdentifier)
        collectionView.register(TitleSupplementaryView.self, forSupplementaryViewOfKind: itemSetting.titleElementKind,
                                         withReuseIdentifier: TitleSupplementaryView.reuseIdentifier)
        collectionView.delegate = self
    }

    // MARK: - ContextMenu Action
    // this is just here to be able to set a custom tooltip menu item
    @objc private func modifyTapped(_ sender: UIMenuController) { }
    @objc private func deleteTapped(_ sender: UIMenuController) { }

}

extension UserItemVC: UICollectionViewDelegate {

    @available(iOS 13.0, *)
      public func collectionView(_ collectionView: UICollectionView,
                                 contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {

        var itemCount = 0
        let section = indexPath.section
        
        itemCount = mainListModel.dm?.getEntityCount(date: itemSetting.stringDate) ?? 0
    
        guard indexPath.item < itemCount else {
            return nil
        }

        guard let cell = collectionView.cellForItem(at: indexPath) as? ItemCell else { return nil }

          var actions = [UIAction]()
          if itemCount > 0 {
              let editAction = UIAction( title: "수정",
                                         image: UIImage(named: "edit")) { [weak self] _ in
                
                guard let self = self else { return }
                cell.modifyEntity(parentVC: self, indexPath: indexPath)
              }

              let deleteAction = UIAction( title: "삭제",
                                           image: UIImage(named: "delete")) { [weak self] _ in
                
                guard let self = self else { return }
                cell.deleteEntity(parentVC: self, indexPath: indexPath)
              }

              actions = [editAction, deleteAction]
          }

          let actionProvider: UIContextMenuActionProvider = { _ in
              return UIMenu(title: "", children: actions)
          }

          return UIContextMenuConfiguration(
              identifier: "editItem" as NSCopying,
              previewProvider: nil,
              actionProvider: actionProvider)
      }

      public func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {

          // don't show menu for add item cell
        var itemCount = 0
        
        let section = indexPath.section
        itemCount = mainListModel.dm?.getEntityCount(date: itemSetting.stringDate) ?? 0
    
        guard indexPath.item < itemCount else {
            return false
        }

        let editItems = UIMenuItem(title: "수정", action: #selector(modifyTapped(_:)))
        let deleteItems = UIMenuItem(title: "삭제", action: #selector(deleteTapped(_:)))
        UIMenuController.shared.menuItems = [editItems, deleteItems]
        return true
      }

      public func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector,
                                 forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {

        // don't show menu for add item cell
        var itemCount = 0
        
        let section = indexPath.section
        itemCount = mainListModel.dm?.getEntityCount(date: itemSetting.stringDate) ?? 0
    
        if action == #selector(modifyTapped) && itemCount > 0 {
            return true
        } else if action == #selector(deleteTapped) && itemCount > 0 {
            return true
        }

        return false
      }

      public func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {

      }
}
