//
//  MainListModel.swift
//  VFCounter
//
//  Created by Sunmi on 2020/11/03.
//  Copyright © 2020 creativeSun. All rights reserved.
//

import UIKit
import CoreStore

class MainListModel {
    
    enum Section: String, CaseIterable {
        case vTitle = "야채"
        case fTitle = "과일"

        var title: String {
            return rawValue
        }
    }
    
    var updateRingHandler: ((String?) -> Void)?
    private var dataSource: UICollectionViewDiffableDataSource<Section, Category>!
    private var currentSnapshot: NSDiffableDataSourceSnapshot<Section, Category>!
    private var listPublisher: ListPublisher<Category>!
    private var date: String?
    private var dataManager: CoreDataManager!
    
    var dm: CoreDataManager? {
        return dataManager
    }
    
    init(date: String) {
        
        self.date = date
        publishList()
        dataManager = CoreDataManager(itemList: listPublisher)
        
    }

    func publishList() {

        listPublisher =  Storage.dataStack.publishList(From<Category>()
                                                        .where(\.$date == date)
                                                                .orderBy(.descending(\.$createdDate)))
        
        print(listPublisher.count())
    }
    
    // MARK: create collectionView datasource
    func configureDataSource(collectionView: UICollectionView) {
        dataSource = UICollectionViewDiffableDataSource<Section, Category>(collectionView: collectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath,
            data: Category) -> UICollectionViewCell? in
            
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: ItemCell.reuseIdentifier,
                for: indexPath) as? ItemCell
                else {
                    fatalError("Cannot create new cell")
                }

            cell.layer.cornerRadius = 10
            cell.layer.borderWidth = 1
            cell.layer.borderColor = ColorHex.lightlightGrey.cgColor

            cell.setDataField(data, updateHandler: nil)
            return cell
        }
    }

    func configureTitleDataSource(delegate: UserItemVC) {
        dataSource.supplementaryViewProvider = { [weak self]
            (collectionView: UICollectionView, kind: String, indexPath: IndexPath) -> UICollectionReusableView? in
            guard let self = self else { return nil }

            if let titleSupplementary = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: TitleSupplementaryView.reuseIdentifier, for: indexPath) as? TitleSupplementaryView {

                let snapshot = self.dataSource.snapshot()
                let category = snapshot.sectionIdentifiers[indexPath.section]
                titleSupplementary.delegate = delegate
                titleSupplementary.updateTitles(title: category.title)

                return titleSupplementary

            } else {
                fatalError("Cannot create new supplementary")
            }
        }
        
    }
    
    func loadData() {
        
        guard let list = listPublisher else { return }
        list.addObserver(self) { [weak self] listPublisher in
            guard let self = self else { return }
            let snapshot = listPublisher.snapshot
            self.update(with: snapshot, flag: true)
        }
        update(with: list.snapshot)
        
    }
    
    func update(with listPublisher: ListSnapshot<Category>, flag: Bool = false) {
        currentSnapshot = NSDiffableDataSourceSnapshot <Section, Category>()
        (0..<2).forEach { index in
           let sectionTitle: Section = (index == 0 ? Section.vTitle : Section.fTitle)
           currentSnapshot.appendSections([sectionTitle])
        }
        let items = listPublisher.compactMap({ $0.object })
        
        for element in items {

            if element.type == "야채" {
                currentSnapshot.appendItems([element], toSection: Section.vTitle)
            } else {
                currentSnapshot.appendItems([element], toSection: Section.fTitle)
            }
        }
        
        dataSource.apply(currentSnapshot, animatingDifferences: flag)
//        reloadRing(date: itemSetting.stringDate)
        self.updateRingHandler?(date)
    }

    func connectHandler() {
        dataManager.workHandler = { value in
            if let date = self.date, value == 0 {  // delete
                self.refetch(date: date)
            } else {
                self.loadData()
            }
        }
      
    }

    func itemCount(date: String) -> Int {
        let dataManager = CoreDataManager(itemList: listPublisher)
        return dataManager.getEntityCount(date: date)
    }
    
    func item(forIndexPath indexPath: IndexPath) -> [Category] {
        let section = dataSource.snapshot().sectionIdentifiers[indexPath.section]
        let items = dataSource.snapshot().itemIdentifiers(inSection: section)
        
        return items
    }
    
//    func sectionTitle(forSection section: Int) -> String? {
//        return self.dataSource?.snapshot().sectionIdentifiers[section]
//    }
    
    func refetch(date: String) {
        try! listPublisher.refetch(From<Category>().where(\.$date == date)
                                .orderBy(.descending(\.$createdDate)))
    }
    
    func getSumItems(date: String) -> (Int, Int) {
        
        var newDate = date.extractDate
        let dataManager = CoreDataManager(itemList: listPublisher)
        let sumV = dataManager.getSumEntity(date: newDate, type: "야채") ?? 0
        let sumF = dataManager.getSumEntity(date: newDate, type: "과일") ?? 0
        return (sumV, sumF)
    }
    
    func createEntity(item: Items, config: ValueConfig) {
        let dataManager = CoreDataManager(itemList: listPublisher)
        dataManager.createEntity(item: item, config: config)
    }

    func reloadRingWithMax(config: ValueConfig, strDate: String) {
        dataManager.reloadRingWithMax(valueConfig: config, strDate: strDate)
    }
    
    func removeobserver() {
        self.listPublisher.removeObserver(self)
    }

}
