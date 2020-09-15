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
    func configureHierarchy() {
    
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: UIHelper.createHorizontalLayout(titleElemendKind: titleElementKind))
        collectionView.backgroundColor = ColorHex.iceBlue
        view.addSubview(collectionView)

        let tabBarHeight = tabBarController?.tabBar.bounds.size.height ?? 0
        let padding = (view.bounds.height - height) - tabBarHeight
        collectionView.snp.makeConstraints { make in
          //  make.top.equalTo(view).offset(height)
            make.top.equalTo(circularView.snp.bottom).offset(8)
            make.leading.trailing.equalTo(view)
            make.height.equalTo(padding)
        }
        
        collectionView.delegate = self
        collectionView.register(VFItemCell.self, forCellWithReuseIdentifier: VFItemCell.reuseIdentifier)
        collectionView.register(TitleSupplementaryView.self, forSupplementaryViewOfKind: titleElementKind,
                                     withReuseIdentifier: TitleSupplementaryView.reuseIdentifier)
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
            
            print("\(data.name!) \(data.createdDate!)")
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
    
        dataManager.getSumItems(date: date) { (veggieSum, fruitSum) in
//            print("\(veggieSum) \(fruitSum)")
            self.circularView.updateValue(amount: Int(veggieSum), tag: 0)
            self.circularView.updateValue(amount: Int(fruitSum), tag: 1)
            
        }
    }
    
    func hideItemView() {
        checkedIndexPath.removeAll()
        updateData()
    }
}


extension UserItemVC: UICollectionViewDelegate {
    
    // 아이템 값 수정 및 삭제
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // 아이템을 선택하면, 홈화면으로 이동
        let cell = collectionView.cellForItem(at: indexPath) as! VFItemCell
       
        if checkedIndexPath.isEmpty {
            cell.selectedItem = true
            checkedIndexPath.insert(indexPath)
            cell.selectedIndexPath(indexPath)
            
        } else {
            checkedIndexPath.removeAll()
             OperationQueue.main.addOperation {
                self.dataSource.apply(self.currentSnapshot, animatingDifferences: false)
            }
        }
        
    }
}

// MARK: - Protocol Extension

extension UserItemVC: PickItemVCProtocol {
    
    func addItems(item: VFItemController.Items) {

        if !item.name.isEmpty {
            stringDate = String(item.date.split(separator: " ").first!)
            NotificationCenter.default.post(name: .updateDateTime, object: nil, userInfo: ["userdate": stringDate])
            dataManager.createEntity(item: item, tag: tag)            
		    updateData() 
        }
      
    }
    
    func updateItems(item: VFItemController.Items, time: Date?) {
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
        self.tag = tag
        
        let date = self.stringDate + Date().changeDateTime(format: .onlyTime)
        DispatchQueue.main.async {
            let itemPickVC = PickItemVC(delegate: self, tag: tag, date: date)
            let navController = UINavigationController(rootViewController: itemPickVC)
            self.present(navController, animated: true)
        }
    
    }
}

extension UserItemVC: VFItemCellDelegate {

    func updateSelectedItem(item: VFItemController.Items, index: Int) {
        // display PickItemVC
        DispatchQueue.main.async {
            let itemPickVC = PickItemVC(delegate: self, tag: index)
            self.tag = index
            itemPickVC.items = item.copy() as? VFItemController.Items
            let navController = UINavigationController(rootViewController: itemPickVC)
            self.present(navController, animated: true)
        }
    }
    
    
    func deleteSelectedItem(item: Int, section: Int) {
        let sectionTitle: Section = (section == 0 ? Section.vTitle : Section.fTitle)     
        let sectionItem = currentSnapshot.itemIdentifiers(inSection: sectionTitle)[item]
      
        var datatype: DataType.Type!
        section == 0 ? (datatype = Veggies.self) : (datatype = Fruits.self)
        
//        print(sectionItem.createdDate)
        dataManager.deleteEntity(originTime: sectionItem.createdDate!, datatype)
        self.currentSnapshot.deleteItems([sectionItem])
        self.updateData(flag: false)
    }
    
}
