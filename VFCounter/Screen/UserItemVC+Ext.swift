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

    // 384 X 104 , item : 74 X 73
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
        dataSource = UICollectionViewDiffableDataSource<VFItemController.VFCollections, DataType>(collectionView: collectionView) {
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
            
            
        
            cell.updateContents(image: image,name: data.name!, amount: amount, date: data.createdDate!)
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
                titleSupplementary.updateTitles(title: category.title, subtitle: category.subtitle)
                return titleSupplementary
                
            } else {
                fatalError("Cannot create new supplementary")
            }
        }
    }
    
    func updateData() {
        
        currentSnapshot = NSDiffableDataSourceSnapshot <VFItemController.VFCollections, DataType>()
    
        for i in 0..<2 {
            currentSnapshot.appendSections([vfitemController.collections[i]])
  
            let fetchedItem = fetchingItems[i](stringDate)
            currentSnapshot.appendItems(fetchedItem)

        }
        
        DispatchQueue.main.async {
            self.dataSource.apply(self.currentSnapshot, animatingDifferences: true)
        }

        reloadRing(date: stringDate)
    }

    func reloadRing(date: String) {
    
        dataManager.getSumItems(date: date) { (veggieSum, fruitSum) in
            print("\(veggieSum) \(fruitSum)")
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
            
        } else {
            checkedIndexPath.removeAll()
            DispatchQueue.main.async {
                self.dataSource.apply(self.currentSnapshot, animatingDifferences: false)
            }
        }
        
    }
}

// MARK: - Protocol Extension

extension UserItemVC: PickItemVCProtocol {
    
    func addItems(item: VFItemController.Items) {

        if !item.name.isEmpty {

            dataManager.createEntity(item: item, tag: tag)            
            stringDate = String(item.date.split(separator: " ").first!)
            updateData()
        }
      
    }

}

extension UserItemVC: TitleSupplmentaryViewDelegate {
    
    func showPickUpViewController(tag: Int) {
         DispatchQueue.main.async {
        
            self.hideItemView()
            self.tag = tag
            
            let date = self.stringDate + Date().changeDateTimeKR(format: " h:mm:ss a")
            let itemPickVC = PickItemVC(delegate: self, tag: tag, date: date)
            let navController = UINavigationController(rootViewController: itemPickVC)
            navController.modalPresentationStyle = .fullScreen
            self.present(navController, animated: false)
         
         }
    }
}

extension UserItemVC: VFItemCellDelegate {
    
    // receive data from VFItemCell
    func updateSelectedItem(item: VFItemController.Items, index: Int) {
        // display PickItemVC
        DispatchQueue.main.async {
            let itemPickVC = PickItemVC(delegate: self, tag: index, date: "", item: item)
            let navController = UINavigationController(rootViewController: itemPickVC)
            navController.modalPresentationStyle = .fullScreen
            self.present(navController, animated: false)
        }
    }
    
    
}
