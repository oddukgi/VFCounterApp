//
//  PickItemVC.swift
//  VFCounter
//
//  Created by Sunmi on 2020/07/25.
//  Copyright © 2020 creativeSun. All rights reserved.
//

import UIKit
import SnapKit

protocol PickItemProtocol: class {
    func addItems(item: Items, pickItemVC: PickItemVC?)
    func updateItems(item: Items, oldDate: Date)
}

class PickItemVC: UIViewController {

    enum Section: String {
        case main
    }
    
    enum NavTitle: String {
      
        case veggie = "야채 선택하기"
        case fruit  = "과일 선택하기"
            
        var text: String {
            return rawValue
        }
    }
    
    var collectionView: UICollectionView! = nil
    var dataSource: UICollectionViewDiffableDataSource<Section, PickItems.Element>! = nil
    var currentSnapshot: NSDiffableDataSourceSnapshot<Section, PickItems.Element>! = nil

    weak var delegate: PickItemProtocol?
    weak var pickItemModel: PickItemModel?
    let pickItems = PickItems()
    var checkedIndexPath = Set<IndexPath>()
    var model: ItemModel!
    var kindSegmentControl: UISegmentedControl!
  
    init(delegate: PickItemProtocol? = nil,
         model: ItemModel, sectionFilter: SectionFilter = .main) {
        super.init(nibName: nil, bundle: nil)
        self.delegate        = delegate
        self.model           = model
        self.sectionFilter   = sectionFilter
    }

    var items: Items? {
        didSet {
            self.fetchedItem = self.items
        }
    }

    var newDate: String {
        return model.date.extractDate
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if sectionFilter == .chart {
            configureSegmentControl()
        } else {
            if kindSegmentControl != nil {
                kindSegmentControl.isHidden = true
            }
        }
        updateCurrentMaxValue()
        configureBarItem()
        configureMeasurementView()
        configureHierarchy()
        configureAmountLabel()
        configureSubview()
        configureDataSource()
        updateData()
        applyFetchedItem()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateRemainTotalText()
    }

    func updateNaviTitle(for type: String) {
        type == "야채" ? (navigationItem.title = NavTitle.veggie.text)
            : (navigationItem.title = NavTitle.fruit.text)
    }
    
    func configureBarItem() {
        
        view.backgroundColor = ColorHex.lightKhaki
        let doneButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self,
                                         action: #selector(dismissVC))
    
        updateNaviTitle(for: model.type)
        navigationItem.rightBarButtonItem = doneButton
        self.setupToHideKeyboardOnTapOnView()
    }
    
    @objc func dismissVC() {
        dismiss(animated: true)
    }

    func configureMeasurementView() {
    
        measurementView = MeasurementView(tag: model.type)
        view.addSubview(measurementView)
        measurementView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(45)
            make.leading.trailing.equalTo(view)
            make.height.equalTo(50)
        }
    }

    func configureHierarchy() {
        
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createCompositionalLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.register(PickItemCell.self, forCellWithReuseIdentifier: PickItemCell.reuseIdentifier)
        view.addSubview(collectionView)
        collectionView.backgroundColor = ColorHex.lightKhaki
        
        _ = (view.bounds.height / 2) - SizeManager().veggiePickCVHeight
        collectionView.snp.makeConstraints {
            $0.top.equalTo(measurementView.snp.bottom).offset(8)
            $0.leading.trailing.equalTo(view)
            $0.height.equalTo(100)
        }
        collectionView.delegate = self
    }
   
    func configureSubview() {

        if fetchedItem != nil {
            model.date = fetchedItem!.date
        }
        
        userDTView = UserDateTimeView(dateTime: model.date,
                                     entityTime: fetchedItem?.entityDT)
    
        userDTView.delegate = self
        view.addSubViews(userDTView, btnAdd)
       
        let dateViewHeight = SizeManager().dateViewHeight
        userDTView.snp.makeConstraints { make in
            make.top.equalTo(stackView.snp.bottom).offset(15)
            make.left.right.equalTo(view).inset(10)
            make.height.equalTo(dateViewHeight)
        }
        
        btnAdd.snp.makeConstraints { make in
            make.top.equalTo(userDTView.snp.bottom).offset(15)
            make.centerX.equalTo(view.snp.centerX)
            make.size.equalTo(CGSize(width: 58, height: 38))
        }
        
        btnAdd.setTitle("Add", for: .normal)
        btnAdd.backgroundColor    = ColorHex.orangeyRed
        btnAdd.setFont(clr: .white, font: NanumSquareRound.bold.style(offset: 17))
        btnAdd.layer.cornerRadius = 18
        btnAdd.setRadiusWithShadow(18)
        btnAdd.addTarget(self, action: #selector(pressedAdd), for: .touchUpInside)
    }
    
    // MARK: Add Button
    
    func copyItem() -> Items {
            
        let indexPath = checkedIndexPath.first!
        let item = currentSnapshot.itemIdentifiers[indexPath.row]
        
        pickItems.item.amount = Int(measurementView.gramTF.text!) ?? 0
        model.date = userDTView.dateTime
      
        let remain = pickItemModel?.compareAmount(amount: pickItems.item.amount, type: model.type)
        if let remain = remain, remain > 0 {
            self.presentAlertVC(title: "알림", message: "\(remain)g 추가할 수 있습니다.", buttonTitle: "OK")
        }
        
         return Items(name: item.name, date: model.date,
                                      image: item.image, amount: pickItems.item.amount,
                                      entityDT: userDTView.dtPickerView.date, type: model.type)
    }
    
    @objc func pressedAdd() {
        
        guard !checkedIndexPath.isEmpty else { return }
        let selectedItem = copyItem()
        dismiss(animated: true)
        
        if let entityDT = fetchedItem?.entityDT {
            delegate?.updateItems(item: selectedItem, oldDate: entityDT)
        } else {
            delegate?.addItems(item: selectedItem, pickItemVC: self)
        }
    }

    func getSumValue() {
        let datamanager = DataManager()
        let sum = 10
        model.valueConfig.sumVeggies = sum
        model.valueConfig.sumFruits = sum
    }
    
    func updateCurrentMaxValue() {
        let veggieRate = SettingManager.getTaskValue(keyName: "VeggieTaskRate") ?? 0
        let fruitRate = SettingManager.getTaskValue(keyName: "FruitTaskRate") ?? 0
        
        let maxV = (veggieRate > 0) ? Int(veggieRate) : model.valueConfig.maxVeggies
        let maxF = (fruitRate > 0) ? Int(fruitRate) : model.valueConfig.maxFruits
        model.valueConfig.maxVeggies = maxV
        model.valueConfig.maxFruits = maxF
        getSumValue()
    }

    // MARK: - update max value from UIDatePickerView
    func checkMaxValueFromDate(date: String) {
       
        let datamanager = DataManager()
        model.date = date
        let maxVeggie = 500
        let maxFruit =  500
        
        SettingManager.setVeggieTaskRate(percent: Float(maxVeggie))
        SettingManager.setFruitsTaskRate(percent: Float(maxFruit))
        
        model.valueConfig.maxVeggies = maxVeggie
        model.valueConfig.maxFruits = maxFruit
        getSumValue()
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

    private var btnAdd = VFButton()
    private var measurementView: MeasurementView!
    private var userDTView: UserDateTimeView!
    private var fetchedItem: Items?
    private var sectionFilter: SectionFilter?
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.alignment = .center
        stackView.spacing = 8
        return stackView
    }()
    
    lazy var lblRemain: VFBodyLabel = {
        let fontColor = ColorHex.MilkChocolate.origin
        let label = VFBodyLabel(textAlignment: .center, font: NanumSquareRound.bold.style(offset: 16),
                                fontColor: fontColor)
        label.numberOfLines = 0
        label.clipsToBounds = true
        return label
    }()
    
    lazy var lblTotal: VFBodyLabel = {
        let fontColor = ColorHex.MilkChocolate.origin
        let label = VFBodyLabel(textAlignment: .center, font: NanumSquareRound.bold.style(offset: 16), fontColor: fontColor)
        label.numberOfLines = 0
        label.clipsToBounds = true
        return label
    }()
}