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

    let circularView = VFCircularView()
    var collectionView: UICollectionView!
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
        mainListModel.configureDataSource(collectionView: collectionView, currentVC: self)
        mainListModel.configureTitleDataSource(delegate: self)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        mainListModel.loadData()
    }
    override func viewWillDisappear(_ animated: Bool) {
        mainListModel.removeobserver()
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
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateAmount(_:)),
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

    @objc fileprivate func updateAmount(_ notification: Notification) {

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
            mainListModel.status = .refetch
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
    
        self.circularView.updateValue(veggieSum: sum.0, fruitSum: sum.1, date: date)
        itemSetting.valueConfig.sumVeggies = sum.0
        itemSetting.valueConfig.sumFruits = sum.1
    
    }

    func updateDateHomeView(date: Date) {
        delegate?.updateDate(date: date, isUpdateCalendar: true)
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
