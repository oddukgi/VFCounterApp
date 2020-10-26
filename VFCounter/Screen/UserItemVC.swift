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
    let titleElementKind = "titleElementKind"
    let dataManager = DataManager()

    var height: CGFloat = 0
    var stringDate: String = ""
    var valueConfig = ValueConfig()
    var collectionView: UICollectionView! = nil
    var dataSource: UICollectionViewDiffableDataSource<Section, DataType>! = nil
    var currentSnapshot: NSDiffableDataSourceSnapshot<Section, DataType>! = nil
    private var dateView: DateView!
    
    weak var delegate: CalendarVCDelegate?
    let fetchedItems =  [ { (newDate) -> [DataType] in
       return DataManager.fetchVeggieData(date: newDate)
    }, { (newDate) -> [DataType] in
       return DataManager.fetchFruitData(date: newDate)
    } ]
   
    let defaultRate = 500
    
    deinit {
        removeNotification()
    }
    init(delegate: CalendarVCDelegate?, date: String) {
        super.init(nibName: nil, bundle: nil)
        self.delegate = delegate
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
        
        DispatchQueue.main.async {
            self.updateData()
        }
    }

    func setupLayout() {

        view.addSubview(circularView)

        let height = SizeManager().circularViewHeight
    
        circularView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(height)
        }
    }

    fileprivate func prepareNotificationAddObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateTaskRate(_:)), name: .updateTaskPercent, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateFetchingData(_:)), name: .updateFetchingData, object: nil)

    }
    
    func removeNotification() {
        NotificationCenter.default.removeObserver(self, name: .updateTaskPercent, object: nil)
        NotificationCenter.default.removeObserver(self, name: .updateFetchingData, object: nil)
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
            
            if newDate.containsWeekday() {
                newDate.removeLast(2)
            }
            stringDate = newDate
            updateData()
        }
    }
}

extension UserItemVC {

    func reloadDataByRange(date: String) {

        currentSnapshot = NSDiffableDataSourceSnapshot <Section, DataType>()

        var sumA = 0, sumB = 0
        let veggieFetchedItem = fetchedItems[0](date)
        let fruitFetchedItem = fetchedItems[1](date)
        
        for (index, item) in veggieFetchedItem.enumerated() {

            sumA += Int(item.amount)
            if sumA > valueConfig.maxVeggies {
     
                if let veggieData = self.dataSource.itemIdentifier(for: IndexPath(item: index, section: 0)) {
                    var snap = self.dataSource.snapshot()
                    snap.deleteItems([veggieData])
                    self.dataSource.apply(snap, animatingDifferences: true)
                    dataManager.deleteEntity(originTime: item.createdDate!, Veggies.self)

                 }
            }
        }

        for (index, item) in fruitFetchedItem.enumerated() {

            sumB += Int(item.amount)
            if sumB > valueConfig.maxFruits {
      
                if let fruitData = self.dataSource.itemIdentifier(for: IndexPath(item: index, section: 1)) {
                    var snap = self.dataSource.snapshot()
                    snap.deleteItems([fruitData])
                    self.dataSource.apply(snap, animatingDifferences: true)
                    dataManager.deleteEntity(originTime: item.createdDate!, Fruits.self)

                }

            }
        }

        reloadRing(date: date)
    }
}
