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

    func setupCV(collectionView: UICollectionView) {
        
        dataSource = UICollectionViewDiffableDataSource<String, ItemGroup>(collectionView: collectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath,
            data: ItemGroup) -> UICollectionViewCell? in
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ItemCell.reuseIdentifier,
                for: indexPath) as? ItemCell else { fatalError("Cannot create new cell") }

            cell.layer.cornerRadius = 10
            cell.layer.borderWidth = 1
            cell.layer.borderColor = ColorHex.lightlightGrey.cgColor
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
    func reloadCV(titles: [String], category: [Category], flag: Bool = false) {

        var snapshot = NSDiffableDataSourceSnapshot<String, ItemGroup>()
        titles.forEach { (title) in
            snapshot.appendSections([title])
        }
        
        let sections = snapshot.sectionIdentifiers
        category.forEach { (element) in
            
            let itemGroup = ItemGroup(date: element.date, category: element)
            snapshot.appendItems([itemGroup], toSection: element.type)
        }

        dataSource.apply(snapshot, animatingDifferences: flag)
    }

//
    func item(forIndexPath indexPath: IndexPath) -> ItemGroup? {
        let section = dataSource.snapshot().sectionIdentifiers[indexPath.section]
        return dataSource.snapshot().itemIdentifiers(inSection: section)[indexPath.row]
    }
//
//    func sectionTitle(forSection section: Int) -> String? {
//        return self.dataSource.snapshot().sectionIdentifiers[section]
//    }
}
