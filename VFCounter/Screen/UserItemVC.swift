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

    let vfitemController = VFItemController()
    let circularView = VFCircularView()
    var collectionView: UICollectionView! = nil
 
    var dataSource: UICollectionViewDiffableDataSource<VFItemController.VFCollections,DataType>! = nil
    var currentSnapshot: NSDiffableDataSourceSnapshot<VFItemController.VFCollections,DataType>! = nil
    let titleElementKind = "titleElementKind"
    var tag: Int = 0
    var height: CGFloat = 0
    var userSettings = [UserSettings]()
    let dataManager = DataManager()
    var stringDate: String?
    var checkedIndexPath = Set<IndexPath>()

    
     let fetchingItems =  [ { (newDate) -> [DataType] in
        
                return try! UserDataManager.dataStack.fetchAll(From<DataType>(UserDataManager.veggieConfiguration)
                    .where(format: "%K BEGINSWITH[c] %@",#keyPath(DataType.createdDate),newDate).orderBy(.descending(\.createdDate)))
        
            },
            {   (newDate) -> [DataType] in
                
                return try! UserDataManager.dataStack.fetchAll(From<DataType>(UserDataManager.fruitsConfiguration)
                            .where(format: "%K BEGINSWITH[c] %@",#keyPath(DataType.createdDate),newDate).orderBy(.descending(\.createdDate)))
        
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
//        setCircularValue()
//        
//        DispatchQueue.main.async {
//            self.dataManager.deleteAllEntity()
//        }
    }
    

    func setupLayout() {
        
        view.addSubview(circularView)        
        height = SizeManager().circularViewHeight(view: view)
        circularView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(5)
            make.width.equalTo(view)
            make.height.equalTo(height)
        }
//        circularView.layer.borderWidth = 1

    }
    
    
    func setCircularValue() {
        if let rate = SettingManager.getTaskValue(keyName: "VeggieTaskRate") {
            circularView.outerSlider.maximumValue = CGFloat(rate)
            
        }
            
        if let rate = SettingManager.getTaskValue(keyName: "FruitsTaskRate") {
            circularView.insideSlider.maximumValue = CGFloat(rate)
        }
        
    }
    //MARK: - notificationCenter
    fileprivate func prepareNotificationAddObserver(){
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateTaskRate(_:)), name: .updateTaskPercent, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateFetchingData(_:)), name: .updateFetchingData, object: nil)
        
    }
    
    // MARK: action
    //AlarSetting 화면에서 최대 복용량 받아서 링 의 최대값을 설정한다.
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
    
    
    // MARK: action
    //AlarSetting 화면에서 최대 복용량 받아서 링 의 최대값을 설정한다.
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
