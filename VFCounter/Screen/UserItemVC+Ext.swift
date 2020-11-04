//
//  UserItemVC+Ext.swift
//  VFCounter
//
//  Created by Sunmi on 2020/10/27.
//  Copyright © 2020 creativeSun. All rights reserved.
//

import UIKit
import CoreStore

extension UserItemVC: PickItemProtocol {
  
    func addItems(item: Items) {
        
        if !item.name.isEmpty {
            itemSetting.stringDate = item.date.extractDate
            mainListModel.createEntity(item: item, config: self.itemSetting.valueConfig)
            guard let date = item.entityDT else { return }
            self.updateDateHomeView(date: date)
        }
    }

    func updateItems(item: Items, oldDate: Date) {
     
        guard let date = item.entityDT else { return }
        updateDateHomeView(date: date)
        mainListModel.dm?.modifyEntity(item: item, oldDate: oldDate)
    }
}

extension UserItemVC: TitleSupplmentaryViewDelegate {

    func showPickUpViewController(type: String) {
        guard !self.presentAmountWarning(config: itemSetting.valueConfig, type: type) else { return }
        let model = ItemModel(date: itemSetting.stringDate, type: type, config: itemSetting.valueConfig)
        displayPickItemVC(model)

    }

}
