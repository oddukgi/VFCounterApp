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
      
        case veggie = "오늘 먹은 야채 선택하기"
        case fruit = "오늘 먹은 과일 선택하기"
            
        var sectionTitle: String {
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
    var pickDate: String = ""
    
    let btnClose = VFButton()
    var btnAdd = VFButton()
    var userdate: String = ""
    private var measurementView: MeasurementView!
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
  
        setLayout()
        setStyle()
        configureHierarchy()
        setMeasurementView()
        configureDataSource()
        updateData()
        self.setupToHideKeyboardOnTapOnView()
    }
    
    // hide navigation bar
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
        
        if fetchedItem != nil {
            // call
            
        }
      
    }
    
    override func viewWillDisappear(_ animated: Bool) {
    
    }
    
    // close button, time button
    func setLayout() {
      
        view.backgroundColor = ColorHex.lightKhaki
        view.addSubViews(btnClose, btnAdd)
        
        btnClose.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(25)
            make.trailing.equalTo(view).offset(-14)
            make.size.equalTo(CGSize(width: 29, height: 29))
        }
      
        btnAdd.snp.makeConstraints { make in
            make.bottom.equalTo(view.snp.bottom).offset(SizeManager().pickItemVCPadding)
            make.centerX.equalTo(view.snp.centerX)
            make.size.equalTo(CGSize(width: 61, height: 40))
        }
        btnClose.setShadow()

    }
    
    func setStyle() {
        btnClose.addImage(imageName: "close")
        btnClose.addTarget(self, action: #selector(dismissVC), for: .touchUpInside)

        btnAdd.setTitle("Add", for: .normal)
        btnAdd.backgroundColor    = ColorHex.orangeyRed
        btnAdd.setFont(clr: .white, font: NanumSquareRound.extrabold.style(sizeOffset: 16))
        btnAdd.layer.cornerRadius = 18
        btnAdd.setRadiusWithShadow(18)
        btnAdd.isUserInteractionEnabled = true
        btnAdd.addTarget(self, action: #selector(pressedAdd), for: .touchUpInside)
    
    }
    
    func setMeasurementView() {
        
        measurementView = MeasurementView(delegate: self)
        view.addSubview(measurementView)
        measurementView.snp.makeConstraints { make in
            make.top.equalTo(collectionView.snp.bottom).offset(5)
            make.leading.trailing.equalTo(view)
            make.bottom.equalTo(btnAdd.snp.top).offset(-20)
        }
    
//        measurementView.layer.borderWidth = 1
    }

    @objc func dismissVC() {
        dismiss(animated: true)
    }
    
    // MARK: Add Button
    @objc func pressedAdd() {
   
        pickItems.item.amount = Int(measurementView.gramTF.text!) ?? 0
        userdate = measurementView.userDTView.dateTime
    
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
