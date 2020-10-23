//
//  ElementCell+Ext.swift
//  VFCounter
//
//  Created by Sunmi on 2020/10/15.
//  Copyright © 2020 creativeSun. All rights reserved.
//

import UIKit

extension ElementCell {

    func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section,
                                                        DataType>(collectionView: collectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath,
            data: DataType) -> UICollectionViewCell? in

            // Get a cell of the desired kind.
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: VFItemCell.reuseIdentifier, for: indexPath) as? VFItemCell
                else {
                    fatalError("Cannot create new cell")
                }

            cell.layer.cornerRadius = 10
            cell.layer.borderWidth = 1
            cell.delegate = self
            cell.layer.borderColor = ColorHex.lightlightGrey.cgColor

            let image = UIImage(data: data.image!)
            let amount = Int(data.amount)
            let name = data.name
            let date = data.createdDate?.changeDateTime(format: .dateTime)

            cell.updateContents(image: image, name: name!, amount: amount, date: date!)
            return cell
        }

    }
    
    func getDefaultMaxValue(date: String) -> (Int, Int) {
        let maxValues = config.datamanager.getMaxData(date: date)
        let defaultV = Int(SettingManager.getTaskValue(keyName: "VeggieTaskRate") ?? 0)
        let defaultF = Int(SettingManager.getTaskValue(keyName: "FruitTaskRate") ?? 0)

        let maxV = (maxValues.0 == 0) ? (defaultV) : (maxValues.0)
        let maxF = (maxValues.1 == 0) ? (defaultF) : (maxValues.1)
        return (maxV, maxF)
    }
    
    // MARK: - ContextMenu Action
    @objc private func modifyTapped(_ sender: UIMenuController) { }
    @objc private func deleteTapped(_ sender: UIMenuController) { }
    
}

extension ElementCell: UICollectionViewDelegate {
    // select item
//
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        // Get a cell of the desired kind.
//        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: VFItemCell.reuseIdentifier, for: indexPath) as? VFItemCell else { fatalError("Cannot create new cell") }
//
//        let date = delegate?.getSelectedDate(index: indexPath.item, tableViewCell: self) ?? ""
//    }
    
    @available(iOS 13.0, *)
    public func collectionView(_ collectionView: UICollectionView,
                               contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {

        var itemCount = data.count
        guard itemCount > 0 else { return nil }
        
        guard let cell = collectionView.cellForItem(at: indexPath) as? VFItemCell else { return nil }
        var actions = [UIAction]()
        
        if itemCount > 0 {
            
            let editAction = UIAction( title: "수정", image: UIImage(named: "edit")) { [weak self] _ in

                guard let self = self, let parentVC = self.parentVC else { return }
                let section = parentVC.tableSection
                self.config.itemModel.oldItem = cell.lblName.text ?? ""
                var newDate = parentVC.weekday[section]
                DispatchQueue.main.async {
                    cell.modifyItem(for: indexPath.item, itemdate: newDate.extractDate)
                }
            }

            let deleteAction = UIAction( title: "삭제",
                                         image: UIImage(named: "delete")) { [weak self] _ in
                guard let self = self, let parentVC = self.parentVC else { return }
                let section = parentVC.tableSection
                self.config.deleteItemName = cell.lblName.text!
                var newDate = parentVC.weekday[section]
                cell.delegate?.presentSelectedAlertVC(indexPath: indexPath,
                                                      selectedDate: newDate.extractDate)
            }

            actions = [editAction, deleteAction]
        }

        let actionProvider: UIContextMenuActionProvider = { _ in
            return UIMenu(title: "", children: actions)
        }

        return UIContextMenuConfiguration(identifier: "editItem" as NSCopying,
                                          previewProvider: nil, actionProvider: actionProvider)
    }

    public func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {

        let itemCount = data.count
        guard itemCount > 0 else { return false }
        
        let editItems = UIMenuItem(title: "수정", action: #selector(modifyTapped(_:)))
        let deleteItems = UIMenuItem(title: "삭제", action: #selector(deleteTapped(_:)))
        UIMenuController.shared.menuItems = [editItems, deleteItems]
        
        return true
    }

    public func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector,
                               forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {

        let itemCount = data.count
        guard itemCount > 0 else { return false }

        if (action == #selector(modifyTapped)  ||  action == #selector(deleteTapped))
            && (itemCount > 0) { return true }

        return false
    }

    public func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    }

}

// MARK: Item Edit

extension ElementCell: ItemCellDelegate {

    func updateSelectedItem(item: VFItemController.Items, index: Int) {

        let dataManager = DataManager()
        var datemodel: DateModel!

        let values = dataManager.getSumItems(date: item.date)
        let maxValues = getDefaultMaxValue(date: item.date)
        datemodel = DateModel(date: item.date, tag: index, sumV: values.0, sumF: values.1,
                              maxV: maxValues.0, maxF: maxValues.1)
        OperationQueue.main.addOperation {
            let itemPickVC = PickItemVC(delegate: self, datemodel: datemodel)
            itemPickVC.items = item.copy() as? VFItemController.Items
            self.delegate?.displayPickItemVC(pickItemVC: itemPickVC)
        }
    }

    func presentSelectedAlertVC(indexPath: IndexPath, selectedDate: String) {
        delegate?.presentSelectedAlertVC(indexPath: indexPath, selectedDate: selectedDate, elementCell: self)
    }
    
    func getEntityCount(date: String, section: Int) -> Int {
        
        var itemCount = 0

        if section == 0 {
            itemCount = config.datamanager.fetchedVeggies(date).count
        } else {
            itemCount = config.datamanager.fetchedFruits(date).count
        }
        
        return itemCount
     
    }

    func isEmptyEntity(oldDate: String) -> Bool {
        
        let cntV = getEntityCount(date: oldDate, section: 0)
        let cntF = getEntityCount(date: oldDate, section: 1)
        
        if cntV == 0 && cntF == 0 {
            return true
        }
        
        return false
    }
}

// MARK: - Protocol Extension

extension ElementCell: PickItemVCProtocol {

    func addItems(item: VFItemController.Items, tag: Int) {

        let maxValues = config.datamanager.getMaxData(date: item.date)
        guard maxValues.0 > 0, maxValues.1 > 0 else { return }
        let datemodel = DateModel(tag: tag, sumV: 0, sumF: 0, maxV: maxValues.0, maxF: maxValues.1)
       
        let pickItemVC = PickItemVC(delegate: self, datemodel: datemodel)
        pickItemVC.items = item.copy() as? VFItemController.Items
        delegate?.displayPickItemVC(pickItemVC: pickItemVC)

    }

    func updateItems(item: VFItemController.Items, time: Date?, tag: Int) {
        var datatype: DataType.Type!
        
        tag == 0 ? (datatype = Veggies.self) : (datatype = Fruits.self)

        guard let entityDT = item.entityDT, let fetchedDT = time else { return }
  
        self.config.datamanager.modfiyEntity(item: item, originTime: fetchedDT, datatype)
  
        let date = entityDT.changeDateTime(format: .date)
        let oldDate = fetchedDT.changeDateTime(format: .date)
        
        config.itemModel.oldDate = oldDate
        config.itemModel.newDate = date
        config.itemModel.newItem = item.name
        
        //(date: Date, imodel: ItemModel, deletedSection: Bool)
        if date == oldDate {
            self.delegate?.updateItem(date: entityDT, model: config.itemModel,
                                         deletedSection: isEmptyEntity(oldDate: config.itemModel.oldDate))
        } else {
            self.delegate?.updateNewItem(date: entityDT, model: config.itemModel,
                                       deletedSection: isEmptyEntity(oldDate: config.itemModel.oldDate))
        }
        
     }
}
