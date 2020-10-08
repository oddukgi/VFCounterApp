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
    var checkedIndexPath = Set<IndexPath>()
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
        connectCV()
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
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateTouchDateView(_:)),
                                               name: .touchDateView, object: nil)
    }
    
    func checkLoadingStatus() {
        if getAppLoadingStatus() {
            alreadyLoadingApp()
        } else {
            firstLoadingApp()
        }
    }
    
    func connectCV() {
        // tap the blank place, then save the icons arrangetment changes
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTapEmptySpaceGesture))
        tapGestureRecognizer.numberOfTapsRequired = 1
        self.collectionView?.backgroundView = UIView(frame:(self.collectionView?.bounds)!)
        self.collectionView?.backgroundView!.addGestureRecognizer(tapGestureRecognizer)
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
    
    
    @objc fileprivate func updateTouchDateView(_ notification: Notification) {
        if let touchView = notification.userInfo?["dateViewTouch"] as? Set<UITouch>,
           let dateView = notification.userInfo?["dateView"] as? DateView {
            
            self.dateView = dateView
            self.touchesBegan(touchView, with: nil)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
         let touch = touches.first
         if touch?.view == self.circularView ||  touch?.view == self.dateView {

            guard let indexPath = checkedIndexPath.first else { return }
            if let cell = collectionView.cellForItem(at: indexPath) as? VFItemCell {
                if cell.itemEditView.isHidden == false {
                    cell.itemEditView.isHidden = true
                }
            }
         }
    }
    
    @objc func handleTapEmptySpaceGesture(recognizer: UITapGestureRecognizer){
        let tapLocation = recognizer.location(in: self.view)
        
        if collectionView.indexPathForItem(at: tapLocation) == nil ||
            collectionView.backgroundView != nil {
        
            //The point is outside of collection cell
            guard let indexPath = checkedIndexPath.first else { return }
            if let cell = collectionView.cellForItem(at: indexPath) as? VFItemCell {
                if cell.itemEditView.isHidden == false {
                    cell.itemEditView.isHidden = true
                }
            }
         
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
//
//extension UserItemVC: UIGestureRecognizerDelegate {
//    func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
//        // only handle tapping empty space (i.e. not a cell)
//        let point = gestureRecognizer.location(in: collectionView)
//        let indexPath = collectionView.indexPathForItem(at: point)
//        return indexPath == nil
//    }
//}
