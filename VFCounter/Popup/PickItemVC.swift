//
//  PickItemVC.swift
//  VFCounter
//
//  Created by Sunmi on 2020/07/25.
//  Copyright © 2020 creativeSun. All rights reserved.
//

import UIKit
import SnapKit

protocol PickItemVCProtocol: class {
    func addItems(item: VFItemController.Items) 
}

class PickItemVC: UIViewController {

    enum Section: String {
        case main
    }
    
    enum NavTitle: String {
      
        case veggie = "오늘 먹은 야채 선택하기"
        case fruit = "오늘 먹은 과일 선택하기"
            
        var text: String {
            return rawValue
        }
    }
    
    var collectionView: UICollectionView! = nil
    var dataSource: UICollectionViewDiffableDataSource<Section, PickItems.Element>! = nil
    var currentSnapshot: NSDiffableDataSourceSnapshot<Section, PickItems.Element>! = nil
    
    let pickItems = PickItems()
    var vfItems: VFItemController.Items!
    weak var delegate: PickItemVCProtocol?
    var tag: Int = 0
    var checkedIndexPath = Set<IndexPath>()
    var userdate: String = ""
    
    private var btnAdd = VFButton()
    private var measurementView: MeasurementView!
    private var userDTView: UserDateTimeView!
    private var fetchedItem: VFItemController.Items? = nil

    init(delegate: PickItemVCProtocol, tag: Int, date: String,
    item: VFItemController.Items? = nil) {
        super.init(nibName: nil, bundle: nil)
        self.delegate        = delegate
        self.tag             = tag
        self.fetchedItem     = item
        self.userdate        = date
      
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureBarItem()
        configureMeasurementView()
        configureHierarchy()
        configureSubview()
        configureDataSource()
        updateData()
        self.setupToHideKeyboardOnTapOnView()
    }
    
    func configureBarItem() {
        view.backgroundColor = ColorHex.lightKhaki
        let doneButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self,
                                         action: #selector(dismissVC))
    
    
        tag == 0 ? (navigationItem.title = NavTitle.veggie.text) : (navigationItem.title = NavTitle.fruit.text)
        navigationItem.rightBarButtonItem = doneButton
    
    }
    
    @objc func dismissVC() {
        dismiss(animated: true)
    }

    func configureMeasurementView() {
        
        measurementView = MeasurementView(delegate: self)
        view.addSubview(measurementView)
        measurementView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.leading.trailing.equalTo(view)
            make.height.equalTo(70)
        }

//        measurementView.layer.borderWidth = 1
    }

    func configureHierarchy() {
        
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createCompositionalLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(collectionView)
        collectionView.backgroundColor = ColorHex.lightKhaki
        collectionView.register(PickItemCell.self, forCellWithReuseIdentifier: PickItemCell.reuseIdentifier)
        
        let _ = (view.bounds.height / 2) - SizeManager().veggiePickCVHeight
        collectionView.snp.makeConstraints {
            $0.top.equalTo(measurementView.snp.bottom).offset(10)
            $0.leading.trailing.equalTo(view)
            $0.height.equalTo(100)
        }

//        collectionView.layer.borderWidth = 1
        collectionView.delegate = self
    }
     // close button, time button
     func configureSubview() {
        userDTView = UserDateTimeView(dateTime: userdate)
        view.addSubViews(btnAdd,userDTView)
        userDTView.snp.makeConstraints { make in
            make.top.equalTo(collectionView.snp.bottom).offset(15)
            make.leading.equalTo(view).offset(20)
            make.trailing.equalTo(view).offset(-20)
            make.bottom.equalTo(view).offset(-180)
        }

//        userDTView.layer.borderWidth = 1
        
        btnAdd.snp.makeConstraints { make in
            make.top.equalTo(userDTView.snp.bottom).offset(14)
            make.centerX.equalTo(view.snp.centerX)
            make.size.equalTo(CGSize(width: 58, height: 38))
        }
        
        btnAdd.setTitle("Add", for: .normal)
        btnAdd.backgroundColor    = ColorHex.orangeyRed
        btnAdd.setFont(clr: .white, font: NanumSquareRound.extrabold.style(sizeOffset: 15))
        btnAdd.layer.cornerRadius = 18
        btnAdd.setRadiusWithShadow(18)
        btnAdd.isUserInteractionEnabled = true
        btnAdd.addTarget(self, action: #selector(pressedAdd), for: .touchUpInside)
     }
     
    // MARK: Add Button
    @objc func pressedAdd() {
   
        pickItems.item.amount = Int(measurementView.gramTF.text!) ?? 0
        userdate = userDTView.dateTime
    
        let item = VFItemController.Items(name: pickItems.item.name,date: userdate, image: pickItems.item.image, amount: pickItems.item.amount)
        delegate?.addItems(item: item)
        dismissVC()
    }

    
    
    // MARK: modify value
//    func applyFetchedItem() {
//
//        print("\(fetchedItem?.name), \(fetchedItem?.amount), \(fetchedItem?.time)")
//        measurementView.gramTF = String(fetchedItem?.amount)
//        measurementView.slider.value = Float(fetchedItem?.amount)
//        // select collection view
//
//        let visibleItems = collectionView.indexPathsForVisibleItems
//
//        for indexPath in visibleItems {
//
//            if let cell = collectionView.cellForItem(at: indexPath) as? PickItemCell {
//
//                if cell.lblName.text? == fetchedItem?.name {
//                    checkedIndexPath.insert(indexPath)
//                    updateCollectionView()
//                }
//            }
//        }
//    }
}
