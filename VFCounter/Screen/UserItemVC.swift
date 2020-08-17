//
//  UserItemVC.swift
//  VFCounter
//
//  Created by Sunmi on 2020/07/24.
//  Copyright © 2020 creativeSun. All rights reserved.
//

import UIKit
import CoreStore


class UserItemVC: UIViewController {

    let vfitemController = VFItemController()
    let circularView = VFCircularView()
    var collectionView: UICollectionView! = nil
 
    var dataSource: UICollectionViewDiffableDataSource<VFItemController.VFCollections,DataType>! = nil
    var currentSnapshot: NSDiffableDataSourceSnapshot<VFItemController.VFCollections,DataType>! = nil
    let titleElementKind = "titleElementKind"
    var tag: Int = 0
    var height: CGFloat = 0
    var chartVC: ChartVC!
    var userSettings = [UserSettings]()
    

    var userData =  [
        try? UserDataManager.dataStack.fetchAll(From<DataType>(UserDataManager.veggieConfiguration).orderBy(.descending(\.time))),
        try? UserDataManager.dataStack.fetchAll(From<DataType>(UserDataManager.fruitsConfiguration).orderBy(.descending(\.time))) ]
                     

    override func viewDidLoad() {
        super.viewDidLoad()
        
       // view.backgroundColor = .white
        setupLayout()
        configureHierarchy()
        configureDataSource()
        configureTitleDataSource()
        updateData()
        getTaskPercent()

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

    func getTaskPercent() {
        PersistenceManager.getTaskPercent { data in
            self.userSettings = data
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
