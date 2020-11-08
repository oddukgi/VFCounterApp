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
    
    // message handler
    
    private var datemap: [String] = []
    private var dataSource: EditableListDataSource<String, Category>!
    private var listPublisher: ListPublisher<Category>!
    private var strategy: DateStrategy!
    private var kind: Kind?
    var tableView: UITableView!
    var updateItem = UpdateItem()
    var dm: CoreDataManager { return CoreDataManager(itemList: listPublisher) }
    
    deinit {
        removeobserver()
    }
    
    var itemCount: Int { return updateItem.itemCount }
    
    init(strategy: DateStrategy, kind: Kind) {
        self.strategy = strategy
        self.kind = kind
        connectRefreshHandler()
        publishList()

    }
    
    var datemaps: [String] {
        return datemap
    }

    func publishList() {
        let dates = strategy.getDateMap()
        
        let firstDate = dates.first?.startOfDay()
        let lastDate = dates.last?.endOfDay()
        print("FirstDate: \(firstDate), LastDate: \(lastDate)")
        
        listPublisher = Storage.dataStack.publishList(From<Category>().sectionBy(\.$date)
                                                            .where(
                                                                \.$createdDate >= firstDate
                                                                    && \.$createdDate <= lastDate)
                                                                .orderBy(.descending(\.$createdDate)))
        print(listPublisher.count())
        datemap = getCommonDate(publisher: listPublisher)
    }
    
    func getCommonDate(publisher: ListPublisher<Category>) -> [String] {
    
       let strDates = strategy.strDateMap
        var items = Set<String>()
        let dataManager = CoreDataManager(itemList: publisher)
        
        for item in strDates {
            // get yyyy.MM.dd
            let shortDate = item.extractDate

            if dataManager.getEntityCount(date: shortDate) > 0 {
                items.insert(item)
            }
        }
    
        return Array(items).sorted()
    }
    
    func setupTableView(tableView: UITableView, periodListVC: PeriodListVC) {
        
        var flag = false
        self.tableView = tableView
          dataSource = EditableListDataSource<String, Category>(tableView: tableView) {[weak self] (tableView, indexPath, _) -> UITableViewCell? in
              guard let self = self else { return nil }
    
            guard let cell: ElementCell = tableView.dequeueCell(indexPath: indexPath) else { fatalError() }
                let items = self.item(forIndexPath: indexPath)
                cell.pModel = periodListVC.listmodel
               
                let status = self.updateItem.status
                switch status {
                
                case .add:
                    flag = false
                 break
                case .delete:
                    (self.itemCount == 1) ?  (flag = true) : (flag = false)
                default:
                    flag = false
                }
                
                cell.updateData(category: items, flag: flag)
                
                return cell
          }
        
      }

     func loadTableView() {
        
        listPublisher.addObserver(self) {[weak self] publisher in
            guard let self = self else { return }
            self.updateTableView(publisher: publisher)
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

    func countOfSubs(date: String, _ publisher: ListPublisher<Category>) -> Int {
        let type = ["야채", "과일" ]
        var section = [String]()
        let object = publisher.snapshot.compactMap({ $0.object })
        let vCategory = object.filter({ $0.date == date && $0.type == type[0]})
        let fCategory = object.filter({ $0.date == date && $0.type == type[1]})
        
        if vCategory.count > 0 { section.append(vCategory[0].type!)}
        if fCategory.count > 0 { section.append(fCategory[0].type!)}
        
        return section.count
    }
    
    fileprivate func deleteListPublisher(categoryCnt: Int,
                                         _ publisher: ListPublisher<Category>) {
        let date = self.updateItem.date ?? ""
        var flag = false

        print("DELETE, \(categoryCnt), \(itemCount), \(date)")
        
        switch categoryCnt {
        
        case 0:
           for (index, item) in datemap.enumerated() {
                if item.contains(date) { datemap.remove(at: index) }
            }
            self.reloadTable(publisher: publisher, flag: true)
            break

        case 2:
            itemCount == 1 ? (flag = true) : (flag = false)
            self.reloadTable(publisher: publisher, flag: flag)
            break
            
        default:
            self.tableView.rowHeight = SizeManager().getUserItemHeight + 15
            self.reloadTable(publisher: publisher)
        }
    }
    func updateTableView(publisher: ListPublisher<Category>) {
        let status = updateItem.status
        let date = self.updateItem.date ?? ""
        let categoryCount = self.countOfSubs(date: date, publisher)
  
        addDate(date: date)
        var flag = false
        
        print("ADD / EDIT, \(categoryCount), \(itemCount), \(date)")
        self.tableView.rowHeight = UITableView.automaticDimension
        
        switch status {
        
        case .add,
            .edit:
            if categoryCount == 2 {
                self.reloadTable(publisher: publisher)
                break
            }
          
            itemCount == 0 ? (flag = true) : ((status == .edit) ? (flag = true) : (flag = false))
            self.reloadTable(publisher: publisher, flag: flag)
            
        case .delete:
            deleteListPublisher(categoryCnt: categoryCount, publisher)
        default:
            self.reloadTable(publisher: publisher)
        }
    }
    
    func addDate(date: String) {

        if date.isEmpty { return }
        let fullDate = date.getWeekday()

        if updateItem.status == .edit {
            compareDate()
        }
   
        if !self.datemap.contains(fullDate) {
            self.datemap.append(fullDate)
            sortDateMap()
        }
        
    }
    
    func compareDate() {
        
        let oldDate = updateItem.olddate
        let newDate = updateItem.date
        
        if !oldDate.contains(newDate) {
            for (index, item) in datemap.enumerated() {
                if item.hasPrefix(oldDate) {
                    datemap.remove(at: index)
                    break
                }
            }
        }
    }
    
    func sortDateMap() {
    
        let dates = self.datemap.map { $0.changeDateTime(format: .longDate)}
        let sortedDates = dates.sorted { $0 < $1 }
        self.datemap = sortedDates.map { $0.changeDateTime(format: .longDate)}
    }

    func loadChart() {
        listPublisher.addObserver(self) {[weak self] _ in
            guard let self = self else { return }
            self.refreshChartHandler?(true)
        }
        
        refreshChartHandler?(true)
    }
    
    func updateItemInfo(date: String) {
        let object = listPublisher.snapshot.compactMap({ $0.object })
        let data = object.filter { $0.date == date }
        let fetchCount = data.count
        updateItem.date = date
        updateItem.itemCount = fetchCount
    }
    
    func connectRefreshHandler() {
        refreshHandler = { h_refresh in
            
            self.updateItem.status = .refetch
            guard let h_refresh = h_refresh else { return}
            self.refetch(h_refresh)
        }
    }

    // MARK: Reload TableView

    private func reloadTable(publisher: ListPublisher<Category>, flag: Bool = false) {
    
        var snapshot = NSDiffableDataSourceSnapshot<String, Category>()
        let object = publisher.snapshot.compactMap({ $0.object })
        
        for date in datemap {
            snapshot.appendSections([date])
            let groupItems = object.filter({ $0.date == date.extractDate })
           
            snapshot.appendItems(groupItems, toSection: date)
      
        }
        self.dataSource.apply(snapshot, animatingDifferences: flag)
    }
    
    private func updateDeleteTable(publisher: ListPublisher<Category>, flag: Bool = false) {

        let date = updateItem.date
        var snapshot = NSDiffableDataSourceSnapshot<String, Category>()
        let object = publisher.snapshot.compactMap({ $0.object })
        if object.count == 0 {
            self.dataSource.apply(snapshot, animatingDifferences: flag)
        }
    }
    
    func refetch(_ strategy: DateStrategy) {
        
        self.strategy = strategy
        
        let dates = strategy.getDateMap()
        datemap = getCommonDate(publisher: listPublisher)
 
        let firstDate = dates.first?.changeDateTime(format: .date)
        let lastDate = dates.last?.changeDateTime(format: .date)
        
        print("FirstDate: \(firstDate), LastDate: \(lastDate)")
        
        try! listPublisher?.refetch(From<Category>().where(\.$date >= firstDate &&
                                                            \.$date <= lastDate)
                                                    .orderBy(.descending(\.$createdDate)))
        
        updateItem.status = .refetch
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
    
    func findSections(date: String) -> Int {
        let sections = self.dataSource?.snapshot().sectionIdentifiers ?? []
        var i = 0
    
        for (index, item) in sections.enumerated() {
            if item.hasPrefix(date) {
                return index
            }
        }
        
        return 0
        
    }
    
    func getSumItems(date: String) -> (Int, Int) {
        
        var newDate = date.extractDate
        let sumV = dm.getSumEntity(date: newDate, type: "야채") ?? 0
        let sumF = dm.getSumEntity(date: newDate, type: "과일") ?? 0
        return (sumV, sumF)
    }
    
    func createEntity(item: Items, config: ValueConfig) {
        let date = item.date.extractDate
        updateItemInfo(date: date)
        updateItem.status = .add
        dm.createEntity(item: item, config: config)
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

//        if !datemap.contains(newDate) && newDate.count > 0 {
//
//            let date = newDate.getWeekday()
//            datemap.append(date)
//            datemap.sorted()
//        }
