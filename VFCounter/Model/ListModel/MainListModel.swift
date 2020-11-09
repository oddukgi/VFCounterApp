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
    var status: Status = .add
    var dm: CoreDataManager { return CoreDataManager(itemList: listPublisher) }

    deinit {
        removeobserver()
    }
    
    init(date: String) {
        
        self.date = date
        publishList()
    }

    private func publishList() {

        listPublisher =  Storage.dataStack.publishList(From<Category>()
                                                        .where(\.$date == date)
                                                                .orderBy(.descending(\.$createdDate)))
        
//        print(listPublisher.count())
    }
    
    // MARK: create collectionView datasource
    func configureDataSource(collectionView: UICollectionView, currentVC: UIViewController) {
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
            cell.itemDelegate = currentVC as! ItemCellDelegate
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
    
    fileprivate func updateListPublisher(_ listPublisher: ListPublisher<Category>) {
        let snapshot = listPublisher.snapshot
        
        if self.status == .add || self.status == .refetch
            || self.status == .edit { 
            self.update(with: snapshot)
        } else if self.status == .delete { // DELETE
            self.update(with: snapshot, flag: true)
        }
    }
    
    func loadData() {
        
        guard let list = listPublisher else { return }
        list.addObserver(self) { [weak self] listPublisher in
            guard let self = self else { return }
            self.updateListPublisher(listPublisher)
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
        self.updateRingHandler?(date)
    }
    
    func updateSum() -> [Int] {
        var arraySum = [Int]()
        
        guard let date = date else { return [] }
        let values = self.getSumItems(date: date)
        arraySum  = [values.0, values.1]
        return arraySum
    }

    func itemCount(date: String) -> Int {
//        let dm = CoreDataManager(itemList: listPublisher)
        return dm.getEntityCount(date: date)
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
        self.date = date
        try! listPublisher.refetch(From<Category>().where(\.$date == date)
                                .orderBy(.descending(\.$createdDate)))
    }
    
    func getSumItems(date: String) -> (Int, Int) {
        
        var newDate = date.extractDate
//        let dm = CoreDataManager(itemList: listPublisher)
        let sumV = dm.getSumEntity(date: newDate, type: "야채") ?? 0
        let sumF = dm.getSumEntity(date: newDate, type: "과일") ?? 0
        return (sumV, sumF)
    }
    
    func createEntity(item: Items, config: ValueConfig) {
//        let dm = CoreDataManager(itemList: listPublisher)
        dm.createEntity(item: item, config: config)
    }

    func reloadRingWithMax(config: ValueConfig, strDate: String) {
        dm.reloadRingWithMax(valueConfig: config, strDate: strDate)
    }
    
    func removeobserver() {
        self.listPublisher.removeObserver(self)
    }

}
