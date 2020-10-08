//
//  UserItemVC+Ext.swift
//  VFCounter
//
//  Created by Sunmi on 2020/07/24.
//  Copyright © 2020 creativeSun. All rights reserved.
//

import UIKit
import SnapKit


extension UserItemVC {
    
// MARK: create collectionView layout
    
    fileprivate func updateCircularView(veggieValue : Int, fruitValue: Int) {
        circularView.ringView.maxVeggies = Double(veggieValue)
        circularView.ringView.maxFruits = Double(fruitValue)
    }
    
    func alreadyLoadingApp() {
       
        let veggieRate = SettingManager.getTaskValue(keyName: "VeggieTaskRate") ?? 0
        SettingManager.setVeggieTaskRate(percent: veggieRate)
        valueConfig.maxVeggies = Int(veggieRate)

        let fruitRate = SettingManager.getTaskValue(keyName: "FruitTaskRate") ?? 0
        SettingManager.setFruitsTaskRate(percent: fruitRate)
        valueConfig.maxFruits = Int(fruitRate)
        
        updateCircularView(veggieValue : Int(veggieRate), fruitValue: Int(fruitRate))
    }

    func firstLoadingApp() {

        SettingManager.setVeggieTaskRate(percent: Float(defaultRate))
        SettingManager.setFruitsTaskRate(percent: Float(defaultRate))
        valueConfig.maxVeggies = defaultRate
        valueConfig.maxFruits = defaultRate
        updateCircularView(veggieValue : defaultRate, fruitValue: defaultRate)
        
        SettingManager.setVeggieAlarm(veggieFlag: true)
        SettingManager.setFruitsAlarm(fruitsFlag: true)
    }
    
    func getAppLoadingStatus() -> Bool {

         let flag = SettingManager.getInitialLaunching(keyName: "InitialLaunching")
         
         if flag == true {
            print("App already launched")
            return true
        } else {
            print("App launched first time")
            SettingManager.setInitialLaunching(flag: true)
            return false
        }
    }
    
    func configureHierarchy() {
    
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: UIHelper.createHorizontalLayout(titleElemendKind: titleElementKind, isPaddingForSection: true))
        collectionView.backgroundColor = ColorHex.iceBlue
        view.addSubview(collectionView)

        collectionView.snp.makeConstraints { make in
            make.top.equalTo(circularView.snp.bottom)
            make.width.equalTo(view.frame.width)
            make.bottom.equalTo(view)
        }
        
        collectionView.delegate = self
        collectionView.register(VFItemCell.self, forCellWithReuseIdentifier: VFItemCell.reuseIdentifier)
        collectionView.register(TitleSupplementaryView.self, forSupplementaryViewOfKind: titleElementKind,
                                     withReuseIdentifier: TitleSupplementaryView.reuseIdentifier)
        collectionView.isScrollEnabled = false
    }
    
    // MARK: create collectionView datasource
    func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, DataType>(collectionView: collectionView) {
            (collectionView: UICollectionView,  indexPath: IndexPath,
            data: DataType) -> UICollectionViewCell? in
            
            // Get a cell of the desired kind.
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: VFItemCell.reuseIdentifier,
                for: indexPath) as? VFItemCell
                else {
                    fatalError("Cannot create new cell")
                }
            
            cell.delegate = self
            cell.layer.cornerRadius = 10
            cell.layer.borderWidth = 1
            cell.layer.borderColor = ColorHex.lightlightGrey.cgColor
            
            let image = UIImage(data: data.image!)
            let amount = Int(data.amount)

            let dateTime = data.createdDate?.changeDateTime(format: .dateTime)

            cell.updateContents(image: image,name: data.name!, amount: amount, date: dateTime!)
            cell.selectedItem = self.checkedIndexPath.contains(indexPath)

            return cell
        }        
    }
    

    func configureTitleDataSource() {
        dataSource.supplementaryViewProvider = { [weak self]
            (collectionView: UICollectionView, kind: String, indexPath: IndexPath) -> UICollectionReusableView? in
            guard let self = self, let snapshot = self.currentSnapshot else { return nil }
            
            if let titleSupplementary = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: TitleSupplementaryView.reuseIdentifier, for: indexPath) as? TitleSupplementaryView {
                
                let category = snapshot.sectionIdentifiers[indexPath.section]
                titleSupplementary.delegate = self
                titleSupplementary.updateTitles(title: category.title)
                
                return titleSupplementary
                
            } else {
                fatalError("Cannot create new supplementary")
            }
        }
    }
    
    func updateData(flag: Bool = true) {
        
        currentSnapshot = NSDiffableDataSourceSnapshot <Section, DataType>()
    
        for i in 0..<2 {
            
            let sectionTitle: Section = (i == 0 ? Section.vTitle : Section.fTitle)
            currentSnapshot.appendSections([sectionTitle])
            let fetchedItem = fetchingItems[i](stringDate)
            currentSnapshot.appendItems(fetchedItem)
        }
        
        self.dataSource.apply(self.currentSnapshot, animatingDifferences: flag)
        reloadRing(date: stringDate)
    }

    func reloadRing(date: String) {
    
        let maxVeggies = valueConfig.maxVeggies
        let maxFruits = valueConfig.maxFruits
       
        let values = dataManager.getSumItems(date: date)
        self.circularView.updateValue(veggieSum: values.0, fruitSum: values.1)
        self.valueConfig.sumVeggies = values.0
        self.valueConfig.sumFruits = values.1     
    }
    
    func hideItemView() {
        checkedIndexPath.removeAll()
        collectionView.reloadData()
    }
}

extension UserItemVC: UICollectionViewDelegate {
    
    // 아이템 값 수정 및 삭제
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // 아이템을 선택하면, 홈화면으로 이동
        let cell = collectionView.cellForItem(at: indexPath) as! VFItemCell
        var snap = self.dataSource.snapshot()
        if checkedIndexPath.isEmpty {
            cell.selectedItem = true
            checkedIndexPath.insert(indexPath)
            cell.selectedIndexPath(indexPath)
            
        } else {
            checkedIndexPath.removeAll()
             OperationQueue.main.addOperation {
                self.dataSource.apply(snap, animatingDifferences: false)
            }
        }
        
    }
}

// MARK: - Protocol Extension

extension UserItemVC: PickItemVCProtocol {
    

    func addItems(item: VFItemController.Items, tag: Int) {

        self.hideItemView()
        if !item.name.isEmpty {
            stringDate = String(item.date.split(separator: " ").first!)
            dataManager.createEntity(item: item, tag: tag)            
		    updateData()
            NotificationCenter.default.post(name: .updateDateTime, object: nil, userInfo: ["userdate": stringDate])
        }
      
    }
    
    func updateItems(item: VFItemController.Items, time: Date?, tag: Int) {
        var datatype: DataType.Type!
        tag == 0 ? (datatype = Veggies.self) : (datatype = Fruits.self)
        
        self.hideItemView()
        OperationQueue.main.addOperation {
            self.updateData(flag: false)
        }

        dataManager.modfiyEntity(item: item, originTime: time!, datatype)
        let date = item.entityDT?.changeDateTime(format: .selectedDT)
        let newDate = date!.replacingOccurrences(of: "-", with: ".").components(separatedBy: " ")
        NotificationCenter.default.post(name: .updateDateTime, object: nil, userInfo: ["userdate": newDate[0]])
    }

}

extension UserItemVC: TitleSupplmentaryViewDelegate {
    
    func showPickUpViewController(tag: Int) {
        self.hideItemView()

        if tag == 0 {
            if valueConfig.sumVeggies == valueConfig.maxVeggies ,  valueConfig.sumVeggies > 0{
                self.presentAlertVC(title: "알림", message: "최대치를 넘었습니다. 아이템을 삭제하세요!", buttonTitle: "OK")
                return
            }
            
        } else {
            if valueConfig.sumFruits == valueConfig.maxFruits, valueConfig.sumFruits > 0 {
                self.presentAlertVC(title: "알림", message: "최대치를 넘었습니다. 아이템을 삭제하세요!", buttonTitle: "OK")
                return
            }
        }
        
        
        let datemodel = DateModel(date: self.stringDate, tag: tag, sumV: valueConfig.sumVeggies,
                                  sumF: valueConfig.sumFruits, maxV: valueConfig.maxVeggies , maxF: valueConfig.maxFruits)
        DispatchQueue.main.async {
            let itemPickVC = PickItemVC(delegate: self, datemodel: datemodel)
            let navController = UINavigationController(rootViewController: itemPickVC)
            self.present(navController, animated: true)
                
        }
    
    }

    func deleteSelectedItem(item: Int, section: Int) {
  
        let sectionTitle: Section = (section == 0 ? Section.vTitle : Section.fTitle)
       
        var datatype: DataType.Type!
        section == 0 ? (datatype = Veggies.self) : (datatype = Fruits.self)
        var snapshot = self.dataSource.snapshot()
        
        if let listData = self.dataSource.itemIdentifier(for: IndexPath(item: item, section: section)) {
            dataManager.deleteEntity(originTime:listData.createdDate!,datatype)
            snapshot.deleteItems([listData])
            self.dataSource.apply(snapshot, animatingDifferences: true)
        }
        
        reloadRing(date: stringDate)
    }
    

    
  
}

extension UserItemVC: ItemCellDelegate {

    func updateSelectedItem(item: VFItemController.Items, index: Int) {

        let datemodel = DateModel(tag: index, sumV: self.valueConfig.sumVeggies,
                                  sumF: self.valueConfig.sumFruits, maxV: self.valueConfig.maxVeggies,
                                  maxF: self.valueConfig.maxFruits)
        DispatchQueue.main.async {

            let itemPickVC = PickItemVC(delegate: self, datemodel: datemodel)
            itemPickVC.items = item.copy() as? VFItemController.Items
            let navController = UINavigationController(rootViewController: itemPickVC)
            self.present(navController, animated: true)
        }
    }
    
    
  
    func presentSelectedAlertVC(item: Int, section: Int) {
        
        self.hideItemView()
        let alert = UIAlertController(title: "", message: "선택한 아이템을 삭제할까요?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "취소", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "예", style: .destructive, handler: { _ in
            self.deleteSelectedItem(item: item, section: section)
        }))

        self.present(alert, animated: true, completion: nil)
    }

}



