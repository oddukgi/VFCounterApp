//
//  ElementCell+Ext.swift
//  VFCounter
//
//  Created by Sunmi on 2020/10/15.
//  Copyright © 2020 creativeSun. All rights reserved.
//

import UIKit

extension ElementCell {
    
    // MARK: - ContextMenu Action
    @objc private func modifyTapped(_ sender: UIMenuController) { }
    @objc private func deleteTapped(_ sender: UIMenuController) { }
    
}

extension ElementCell: UICollectionViewDelegate {

    @available(iOS 13.0, *)
      public func collectionView(_ collectionView: UICollectionView,
                                 contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {

        var itemCount = 0
        let section = indexPath.section
        
//        let sectionGroup = elementModel.sectionTitle(forSection: indexPath.section)
//        print(sectionGroup?.date!, sectionGroup?.type!)
        
//        itemCount = dataManager.getEntityCount(date: itemSetting.stringDate)
    
//        guard indexPath.item < itemCount else {
//            return nil
//        }

        guard let cell = collectionView.cellForItem(at: indexPath) as? ItemCell else { return nil }

          var actions = [UIAction]()
          if itemCount > 0 {
              let editAction = UIAction( title: "수정",
                                         image: UIImage(named: "edit")) { [weak self] _ in
                
                guard let self = self else { return }
                
              }

              let deleteAction = UIAction( title: "삭제",
                                           image: UIImage(named: "delete")) { [weak self] _ in
                
                guard let self = self else { return }
//                cell.deleteEntity(parentVC: self, indexPath: indexPath)
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
//        itemCount = dataManager.getEntityCount(date: itemSetting.stringDate)
//
//        guard indexPath.item < itemCount else {
//            return false
//        }

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
//        itemCount = dataManager.getEntityCount(date: itemSetting.stringDate)
    
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
