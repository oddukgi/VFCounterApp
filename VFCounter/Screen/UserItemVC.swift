//
//  UserItemVC.swift
//  VFCounter
//
//  Created by Sunmi on 2020/07/24.
//  Copyright © 2020 creativeSun. All rights reserved.
//

import UIKit

class UserItemVC: UIViewController {

    let vfitemController = VFItemController()
    let circularView = VFCircularView()
    var collectionView: UICollectionView! = nil
    var dataSource: UICollectionViewDiffableDataSource<VFItemController.VFCollections,VFItemController.Items>! = nil
    var currentSnapshot: NSDiffableDataSourceSnapshot<VFItemController.VFCollections,VFItemController.Items>! = nil
    let titleElementKind = "titleElementKind"
    var tag: Int = 0
    var height: CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       // view.backgroundColor = .white
        setupLayout()
        configureHierarchy()
        configureDataSource()
        configureTitleDataSource()
        updateData()
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
    
}

