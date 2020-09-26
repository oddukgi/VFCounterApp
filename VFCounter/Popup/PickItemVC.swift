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
    func updateItems(item: VFItemController.Items, time: Date?)
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
    var userdate: String = ""
    var checkedIndexPath = Set<IndexPath>()
    
    private var btnAdd = VFButton()
    private var measurementView: MeasurementView!
    private var userDTView: UserDateTimeView!
    private var fetchedItem: VFItemController.Items?

    init(delegate: PickItemVCProtocol, tag: Int, date: String? = nil) {
        super.init(nibName: nil, bundle: nil)
        self.delegate        = delegate
        self.tag             = tag
        self.userdate        = date ?? ""
    }
    
    var items: VFItemController.Items? {
        didSet {
            self.fetchedItem = self.items
        }
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
        applyFetchedItem()
       
        
    }
    
    func configureBarItem() {
        view.backgroundColor = ColorHex.lightKhaki
        let doneButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self,
                                         action: #selector(dismissVC))
    
    
        tag == 0 ? (navigationItem.title = NavTitle.veggie.text) : (navigationItem.title = NavTitle.fruit.text)
        navigationItem.rightBarButtonItem = doneButton
        self.setupToHideKeyboardOnTapOnView()
    }
    
    @objc func dismissVC() {
        dismiss(animated: true)
    }

    func configureMeasurementView() {
    
        measurementView = MeasurementView()
        view.addSubview(measurementView)
        measurementView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.leading.trailing.equalTo(view)
            make.height.equalTo(70)
        }
    }

    func configureHierarchy() {
        
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createCompositionalLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.register(PickItemCell.self, forCellWithReuseIdentifier: PickItemCell.reuseIdentifier)
        view.addSubview(collectionView)
        collectionView.backgroundColor = ColorHex.lightKhaki
        
        let _ = (view.bounds.height / 2) - SizeManager().veggiePickCVHeight
        collectionView.snp.makeConstraints {
            $0.top.equalTo(measurementView.snp.bottom).offset(10)
            $0.leading.trailing.equalTo(view)
            $0.height.equalTo(100)
        }
        collectionView.delegate = self
    }
     // close button, time button
     func configureSubview() {

        if fetchedItem != nil {
            userdate = fetchedItem!.date
        }
        userDTView = UserDateTimeView(dateTime: userdate, entityTime: fetchedItem?.entityDT)
        view.addSubViews(btnAdd,userDTView)

        userDTView.snp.makeConstraints { make in
            make.top.equalTo(collectionView.snp.bottom).offset(15)
            make.leading.equalTo(view).offset(20)
            make.trailing.equalTo(view).offset(-20)
            make.height.equalTo(80)
        }
        
        btnAdd.snp.makeConstraints { make in
            make.top.equalTo(userDTView.snp.bottom).offset(10)
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
   
        guard !checkedIndexPath.isEmpty else { return }
            
        let indexPath = checkedIndexPath.first!
        let row = indexPath.row
        let item = currentSnapshot.itemIdentifiers[row]
        
        pickItems.item.amount = Int(measurementView.gramTF.text!) ?? 0
        userdate = userDTView.dateTime
        
//         print(userDTView.dtPickerView.date)
   
        let selectedItem = VFItemController.Items(name: item.name, date: userdate, image: item.image, amount: pickItems.item.amount, entityDT: userDTView.dtPickerView.date)
        
        if fetchedItem != nil {
            delegate?.updateItems(item: selectedItem, time: fetchedItem?.entityDT)
        } else {
            delegate?.addItems(item: selectedItem)
        }
       
        dismissVC()
    }

    
    
    // MARK: modify value
    func applyFetchedItem() {
        guard let fetchedItem = fetchedItem else { return }
   
        measurementView.gramTF.text = String(fetchedItem.amount)
        measurementView.slider.value = Float(fetchedItem.amount)

        let totalCount = currentSnapshot.numberOfItems
        
        for i in 0 ..< totalCount {
            let item = currentSnapshot.itemIdentifiers[i]
            
            if item.name == fetchedItem.name {
              checkedIndexPath.insert(IndexPath(row: i, section: 0))
              OperationQueue.main.addOperation {
                self.dataSource.apply(self.currentSnapshot, animatingDifferences: false)
                self.collectionView.scrollToItem(at: IndexPath(row: i, section: 0), at: .centeredHorizontally, animated: false)
              }
            
            }
        }
    }
}
