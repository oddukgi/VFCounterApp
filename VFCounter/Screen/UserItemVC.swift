//
//  UserItemVC.swift
//  VFCounter
//
//  Created by Sunmi on 2020/07/24.
//  Copyright © 2020 creativeSun. All rights reserved.
//

import UIKit
import CoreStore
import CoreData



class UserItemVC: UIViewController {

    enum Section: String {     
        case vTitle = "야채"
        case fTitle = "과일"
            
        var title: String {
            return rawValue
        }
    }

    let circularView = VFCircularView()
    var collectionView: UICollectionView! = nil
 
    var dataSource: UICollectionViewDiffableDataSource<Section,DataType>! = nil
    var currentSnapshot: NSDiffableDataSourceSnapshot<Section,DataType>! = nil
    let titleElementKind = "titleElementKind"
    var height: CGFloat = 0
    var userSettings = [UserSettings]()
    let dataManager = DataManager()
    var stringDate: String = ""
    var valueConfig = ValueConfig()
    private var dateView: DateView!

        
    let defaultRate = 500
     let fetchingItems =  [ { (newDate) -> [DataType] in
        
            return try! UserDataManager.dataStack.fetchAll(From<DataType>(UserDataManager.veggieConfiguration)
            .where(format: "%K BEGINSWITH[c] %@",#keyPath(DataType.date),newDate).orderBy(.descending(\.createdDate)))
        },
        { (newDate) -> [DataType] in
            return try! UserDataManager.dataStack.fetchAll(From<DataType>(UserDataManager.fruitsConfiguration).where(format: "%K BEGINSWITH[c] %@",#keyPath(DataType.date),newDate).orderBy(.descending(\.createdDate)))
        
        } ]
    
    
    init(date: String) {
        super.init(nibName: nil, bundle: nil)
        self.stringDate = date
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareNotificationAddObserver()
        setupLayout()
        configureHierarchy()
        configureDataSource()
        configureTitleDataSource()
        checkLoadingStatus()
        updateData()
    }

    func setupLayout() {
        
        view.addSubview(circularView)

        height = SizeManager().circularViewHeight(view: view)
        let padding = height + 150
        let newHeight = height - 20
        circularView.snp.makeConstraints { make in
            make.bottom.equalTo(view.snp.bottom).offset(-padding)
            make.leading.trailing.equalTo(view)
            make.height.equalTo(newHeight)
        }
    }

   
    fileprivate func prepareNotificationAddObserver(){
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateTaskRate(_:)), name: .updateTaskPercent, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateFetchingData(_:)), name: .updateFetchingData, object: nil)

    }
    
    func checkLoadingStatus() {
        if getAppLoadingStatus() {
            alreadyLoadingApp()
        } else {
            firstLoadingApp()
        }
    }
    
    @objc fileprivate func updateTaskRate(_ notification: Notification) {
     
        if let veggieAmount = notification.userInfo?["veggieAmount"] as? Int {
            valueConfig.maxVeggies = veggieAmount
            circularView.ringView.maxVeggies = Double(veggieAmount)
            circularView.updateMaxValue(tag: 0)
        }
        
        if let fruitAmount = notification.userInfo?["fruitAmount"] as? Int {
            valueConfig.maxFruits = fruitAmount
            circularView.ringView.maxFruits = Double(fruitAmount)
            circularView.updateMaxValue(tag: 1)
        }        
        reloadDataByRange(date: stringDate)
    }

    @objc fileprivate func updateFetchingData(_ notification: Notification) {
        
        if let createdDate = notification.userInfo?["createdDate"] as? String {
            var newDate = createdDate
            newDate.removeLast(2)
            stringDate = newDate
            updateData()
        }
    }
}

extension UserItemVC {

    func reloadDataByRange(date: String) {
        
        currentSnapshot = NSDiffableDataSourceSnapshot <Section, DataType>()
    
        var sumA = 0, sumB = 0
        let veggieFetchedItem = fetchingItems[0](date)
        let fruitFetchedItem = fetchingItems[1](date)
   
        for (index, item) in veggieFetchedItem.enumerated() {
            
            sumA += Int(item.amount)
            if sumA > valueConfig.maxVeggies {
                dataManager.deleteEntity(originTime:item.createdDate!, Veggies.self)
                
                if let veggieData = self.dataSource.itemIdentifier(for: IndexPath(item: index, section: 0)) {
                     var snap = self.dataSource.snapshot()
                     snap.deleteItems([veggieData])
                     self.dataSource.apply(snap, animatingDifferences: true)
                 }
            }
        }
        
 
        for (index, item) in fruitFetchedItem.enumerated() {
            
            sumB += Int(item.amount)
            if sumB > valueConfig.maxFruits {
                dataManager.deleteEntity(originTime:item.createdDate!, Fruits.self)

                if let fruitData = self.dataSource.itemIdentifier(for: IndexPath(item: index, section: 1)) {
                    var snap = self.dataSource.snapshot()
                    snap.deleteItems([fruitData])
                    self.dataSource.apply(snap, animatingDifferences: true)
                   
                }

            }
        }
        
        reloadRing(date: date)
    }
}
