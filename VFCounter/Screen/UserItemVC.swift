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

    /// section
    let circularView = VFCircularView()
    var collectionView: UICollectionView!
    /// private
    private var dateView: DateView!
    var itemSetting = ItemSettings()
    var mainListModel: MainListModel!
    weak var delegate: CalendarVCDelegate?

    let defaultRate = 500

    init(delegate: CalendarVCDelegate?, date: String) {
        self.delegate = delegate
        itemSetting.stringDate = date
        mainListModel = MainListModel(date: date)
        super.init(nibName: nil, bundle: nil)
    }
    
    deinit {
        removeNotification()
        mainListModel.removeobserver()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        prepareNotificationAddObserver()
        checkLoadingStatus()
        setupLayout()
        configureHierarchy()
        connectHandler()
        mainListModel.configureDataSource(collectionView: collectionView)
        mainListModel.configureTitleDataSource(delegate: self)
        mainListModel.connectHandler()
        mainListModel.loadData()    
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
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateTaskRate(_:)),
                                               name: .updateTaskPercent, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateFetchingData(_:)),
                                               name: .updateFetchingData, object: nil)

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
            itemSetting.valueConfig.maxVeggies = veggieAmount
            circularView.ringView.maxVeggies = Double(veggieAmount)
            circularView.updateMaxValue(tag: 0)
        }

        if let fruitAmount = notification.userInfo?["fruitAmount"] as? Int {
            itemSetting.valueConfig.maxFruits = fruitAmount
            circularView.ringView.maxFruits = Double(fruitAmount)
            circularView.updateMaxValue(tag: 1)
        }
        
        mainListModel.reloadRingWithMax(config: itemSetting.valueConfig, strDate: itemSetting.stringDate)
    }

    @objc fileprivate func updateFetchingData(_ notification: Notification) {

        if let createdDate = notification.userInfo?["createdDate"] as? String {
            var newDate = createdDate
            
            if newDate.containsWeekday() {
                newDate.removeLast(2)
            }
            itemSetting.stringDate = newDate
            mainListModel.refetch(date: itemSetting.stringDate)
        }
        
    }
    func connectHandler() {
        mainListModel.updateRingHandler = { value in
           guard let date = value else { return }
            self.reloadRing(date: date)
        }
    }
    
    func reloadRing(date: String) {
        let sum = mainListModel.getSumItems(date: date)
    
        self.circularView.updateValue(veggieSum: sum.0, fruitSum: sum.1)
        itemSetting.valueConfig.sumVeggies = sum.0
        itemSetting.valueConfig.sumFruits = sum.1
    
    }

    // MARK: Delegate
    func updateDateHomeView(date: Date) {
        delegate?.updateDate(date: date, isUpdateCalendar: true)
    }
    
     func displayPickItemVC(_ model: ItemModel, _ item: Items? = nil) {
        DispatchQueue.main.async {
            let itemPickVC = PickItemModule.build(userVC: self, model: model)
            
            if let item = item {
                itemPickVC.items = item.copy() as? Items
            }
            
            let navController = UINavigationController(rootViewController: itemPickVC)
            self.present(navController, animated: true)
        }
    }
    
    func updateSelectedItem(item: Items) {

        guard !self.presentAmountWarning(config: itemSetting.valueConfig, type: item.type) else { return }
        let model = ItemModel(date: itemSetting.stringDate, type: item.type, config: itemSetting.valueConfig)
        displayPickItemVC(model, item)
    }
    
}

extension UserItemVC {
    
    struct ItemSettings {
        
        let circularView = VFCircularView()
        let titleElementKind = "titleElementKind"
        var height: CGFloat = 0
        var stringDate: String = ""
        var valueConfig = ValueConfig()
    }
}
