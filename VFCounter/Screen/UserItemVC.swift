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
    var tag: Int = 0
    var height: CGFloat = 0
    var userSettings = [UserSettings]()
    let dataManager = DataManager()
    var stringDate: String = ""
    var checkedIndexPath = Set<IndexPath>()
        
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
        setupLayout()
        configureHierarchy()
        configureDataSource()
        configureTitleDataSource()
        updateData()
        prepareNotificationAddObserver()

    }

    func setupLayout() {
        
        view.addSubview(circularView)

        height = SizeManager().circularViewHeight(view: view)
        let padding = height + 90
        circularView.snp.makeConstraints { make in
            make.bottom.equalTo(view.snp.bottom).offset(-padding)
            make.leading.trailing.equalTo(view)
            make.height.equalTo(height)
        }
    }

    func setCircularValue() {
        if let rate = SettingManager.getTaskValue(keyName: "VeggieTaskRate") {
            circularView.outerSlider.maximumValue = CGFloat(rate)
            
        }
            
        if let rate = SettingManager.getTaskValue(keyName: "FruitsTaskRate") {
            circularView.insideSlider.maximumValue = CGFloat(rate)
        }
        
    }

    fileprivate func prepareNotificationAddObserver(){
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateTaskRate(_:)), name: .updateTaskPercent, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateFetchingData(_:)), name: .updateFetchingData, object: nil)
        
    }
    
    @objc fileprivate func updateTaskRate(_ notification: Notification) {
     
        if let veggieAmount = notification.userInfo?["veggieAmount"] as? Int {
        
           print(veggieAmount)
           circularView.outerSlider.maximumValue = CGFloat(veggieAmount)
        }
        
        if let fruitAmount = notification.userInfo?["fruitAmount"] as? Int {
            
            print(fruitAmount)
            circularView.insideSlider.maximumValue = CGFloat(fruitAmount)
        }
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


/*

 Delete AllEntity
 DispatchQueue.main.async {
     UserDataManager.deleteAllEntity()
     self.updateData()
 }
*/
