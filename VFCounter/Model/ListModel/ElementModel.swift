//
//  ElementModel.swift
//  VFCounter
//
//  Created by Sunmi on 2020/11/01.
//  Copyright © 2020 creativeSun. All rights reserved.
//

import UIKit
import CoreStore

class ElementModel {
    
    private var dataSource: UICollectionViewDiffableDataSource<String, ItemGroup>!
    private var category: Category?
    var periodModel: PeriodListModel!

    func setupCV(collectionView: UICollectionView, elementCell: ElementCell) {
        
        dataSource = UICollectionViewDiffableDataSource<String, ItemGroup>(collectionView: collectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath,
            data: ItemGroup) -> UICollectionViewCell? in
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ItemCell.reuseIdentifier,
                for: indexPath) as? ItemCell else { fatalError("Cannot create new cell") }

            cell.layer.cornerRadius = 10
            cell.layer.borderWidth = 1
            cell.layer.borderColor = ColorHex.lightlightGrey.cgColor
            cell.itemDelegate = elementCell.parentVC as? ItemCellDelegate
//            let itemgroup = item(forIndexPath: indexPath)
            
            let category = data.category!
            cell.setDataField(category, updateHandler: nil)
            return cell
        }
    }
    
    func setupTitleView(collectionView: UICollectionView) {
         dataSource.supplementaryViewProvider = { [weak self]
             (collectionView: UICollectionView, kind: String, indexPath: IndexPath) -> UICollectionReusableView? in
             guard let self = self else { return nil }

             if let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HeaderView.reuseIdentifier, for: indexPath) as? HeaderView {

             return headerView

             } else {
                 fatalError("Cannot create new supplementary")
             }
         }
     }
    // MARK: Reload TableView
    func reloadCV(category: [Category], flag: Bool = false) {

        var snapshot = NSDiffableDataSourceSnapshot<String, ItemGroup>()
        var section = [String]()
        
        let veggieItem = category.filter { $0.type == "야채" }
        let fruitItem = category.filter { $0.type == "과일" }
        
        if veggieItem.count > 0 { section.append(veggieItem[0].type!) }
        if fruitItem.count > 0 { section.append(fruitItem[0].type!) }
        
        snapshot.appendSections(section)
        
        veggieItem.forEach { (item) in
            let itemGroup = ItemGroup(date: item.date, category: item)
            snapshot.appendItems([itemGroup], toSection: item.type)
        }
        
        fruitItem.forEach { (item) in
            let itemGroup = ItemGroup(date: item.date, category: item)
            snapshot.appendItems([itemGroup], toSection: item.type)
        }
        
        dataSource.apply(snapshot, animatingDifferences: flag)
    }
    
    func itemCount(forIndexPath indexPath: IndexPath) -> Int {
        let section = dataSource.snapshot().sectionIdentifiers[indexPath.section]
        return dataSource.snapshot().itemIdentifiers(inSection: section).count
    }

    func item(forIndexPath indexPath: IndexPath) -> ItemGroup? {
        let section = dataSource.snapshot().sectionIdentifiers[indexPath.section]
        return dataSource.snapshot().itemIdentifiers(inSection: section)[indexPath.row]
    }

//    func sectionTitle(forSection section: Int) -> String? {
//        return self.dataSource.snapshot().sectionIdentifiers[section]
//    }
}
