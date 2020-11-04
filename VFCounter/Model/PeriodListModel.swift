//
//  PeriodListPresenter.swift
//  VFCounter
//
//  Created by Sunmi on 2020/10/31.
//  Copyright © 2020 creativeSun. All rights reserved.
//

import UIKit
import CoreStore

class PeriodListModel {

    enum Kind: String {
        case chart, list
        
        var type: String {
            return rawValue
        }
    }
    
    var setting = PeriodListModel.Settings()
    var refreshHandler: ((DateStrategy?) -> Void)?
    var refreshChartHandler: ((Bool?) -> Void)?
    
    private var datemap: [String] = []
    private var dataSource: EditableListDataSource<String, Category>!
    private var listPublisher: ListPublisher<Category>!
    private var strategy: DateStrategy?
    private var kind: Kind?
    
    var dm: CoreDataManager { return CoreDataManager(itemList: listPublisher) }
 
    init(strategy: DateStrategy, kind: Kind) {
        self.strategy = strategy
        self.kind = kind
        connectHandler()
        publishList()

    }
    
    var datemaps: [String] {
        return datemap
    }

    func publishList() {
        
        guard let strategy = strategy else { return }
        datemap = strategy.getCommonDate()
        let dates = strategy.getDateMap()

//        let firstDate = dates.first
//        let lastDate = dates.last?.addingTimeInterval(50)
        
        let firstDate = dates.first?.startOfDay()
        let lastDate = dates.last?.startOfDay()
        print("FirstDate: \(firstDate), LastDate: \(lastDate)")
        
        listPublisher = Storage.dataStack.publishList(From<Category>().sectionBy(\.$date)
                                                            .where(
                                                                \.$createdDate >= firstDate
                                                                    && \.$createdDate <= lastDate)
                                                                .orderBy(.descending(\.$createdDate)))
        
        print(listPublisher.count())
    }
    
    func setupTableView(tableView: UITableView) {
        dataSource = EditableListDataSource<String, Category>(tableView: tableView) {[weak self] (tableView, indexPath, _) -> UITableViewCell? in
            guard let self = self else { return nil }
            
            if let cell: ElementCell = tableView.dequeueCell(indexPath: indexPath) {
            let items = self.item(forIndexPath: indexPath)
                cell.updateData(category: items)
                return cell
            } else {
                fatalError()
            }
        }
    }
        
     func loadTableView() {
        listPublisher.addObserver(self) {[weak self] publisher in
            guard let self = self else { return }
            self.reloadTable(publisher: publisher, flag: false)
            
        }
        dataSource.titleForSection = {[weak self] section in
            guard let self = self else { return nil }
            return self.sectionTitle(forSection: section)
        }
        
        dataSource.subcategorys = {[weak self] section in
            guard let self = self else { return nil }
            return 1

        }
        
        reloadTable(publisher: listPublisher)
    }
    
    func loadChart() {
        listPublisher.addObserver(self) {[weak self] _ in
            guard let self = self else { return }
            self.refreshChartHandler?(true)
        }
        
        refreshChartHandler?(true)
    }
    
    func refetch(_ strategy: DateStrategy) {
        
        self.strategy = strategy
        
        let dates = strategy.getDateMap()
        datemap = strategy.getCommonDate()
 
        let firstDate = dates.first?.changeDateTime(format: .date)
        let lastDate = dates.last?.changeDateTime(format: .date)
        
        print("Common date: \(datemap)")
        print("FirstDate: \(firstDate), LastDate: \(lastDate)")
        
        try! listPublisher?.refetch(From<Category>().where(\.$date >= firstDate &&
                                                            \.$date <= lastDate)
                                                        .orderBy(.descending(\.$createdDate)))

    }
    
    // MARK: Reload TableView
    private func reloadTable(publisher: ListPublisher<Category>, flag: Bool = false) {
        
        var snapshot = NSDiffableDataSourceSnapshot<String, Category>()
        let object = publisher.snapshot.compactMap({ $0.object })
        
        if object.isEmpty { return }
        
        for date in datemap {
            snapshot.appendSections([date])
            let groupItems = object.filter({
                                            $0.date == date.extractDate })
            if groupItems.count > 0 {
                snapshot.appendItems(groupItems, toSection: date)
            }
        }
        self.dataSource.apply(snapshot, animatingDifferences: flag)
    }
    
    // make empty view
    func reloadEmptyView() {
        var snapshot = NSDiffableDataSourceSnapshot<String, Category>()
        snapshot.appendSections([""])
        snapshot.appendItems([])
        
        self.dataSource.apply(snapshot, animatingDifferences: true)
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
    
    func sectionTitle(forSection section: Int) -> String? {
        return self.dataSource?.snapshot().sectionIdentifiers[section]
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
    
    func connectHandler() {
        refreshHandler = { h_refresh in
            
            guard let h_refresh = h_refresh else { return}
            self.refetch(h_refresh)
        }
    }
    
    func removeobserver() {
        self.listPublisher.removeObserver(self)
    }

}

extension PeriodListModel {
    
    struct Settings {
        var weekday = [String]()
        var datemaps = [String]()
        var selectedIndex: Int = 0
        var tableSection: Int = 0
        var isAddedItem = false        
    }
}
