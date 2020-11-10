//
//  PickItemVC.swift
//  VFCounter
//
//  Created by Sunmi on 2020/07/25.
//  Copyright © 2020 creativeSun. All rights reserved.
//

import UIKit
import SnapKit
import CoreStore

protocol PickItemProtocol: class {
    func addItems(item: Items)
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
    var pickItemModel: PickItemModel!
    let pickItems = PickItems()
    var checkedIndexPath = Set<IndexPath>()
    var model: ItemModel!
    var kindSegmentControl: UISegmentedControl!
    private var listPublisher: ListPublisher<Category>!
    
    init(delegate: PickItemProtocol? = nil,
         model: ItemModel, sectionFilter: SectionFilter = .main) {
        super.init(nibName: nil, bundle: nil)
        self.delegate        = delegate
        self.model           = model
        self.sectionFilter   = sectionFilter
        pickItemModel = PickItemModel(config: model.valueConfig)
     
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
            changeSegmentBySection()
        } else {
            if kindSegmentControl != nil {
                kindSegmentControl.isHidden = true
            }
        }
        checkMaxValueFromDate(date: model.date)
        configureBarItem()
        configureMeasurementView()
        configureHierarchy()
        configureAmountLabel()
        configureSubview()
        changeDateRange()
        configureDataSource()
        updateData()
        publishList()
        applyFetchedItem()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateRemainTotalText()
    }

    func publishList() {
        listPublisher =  Storage.dataStack.publishList(From<Category>()
                                                        .where(\.$date == model.date)
                                                                .orderBy(.descending(\.$createdDate)))
    }
    
    func getSumValue() {
        publishList()
        
        let dm = CoreDataManager(itemList: listPublisher)
        let sumV = dm.getSumEntity(date: newDate, type: "야채") ?? 0
        let sumF = dm.getSumEntity(date: newDate, type: "과일") ?? 0
    
        model.valueConfig.sumVeggies = sumV
        model.valueConfig.sumFruits = sumF
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
    
    func copyItem() -> Items? {
            
        guard let indexPath = checkedIndexPath.first else { return nil }
        let item = currentSnapshot.itemIdentifiers[indexPath.row]
        
        pickItems.item.amount = Int(measurementView.gramTF.text!) ?? 0
        model.date = userDTView.dateTime.extractDate
        var copyItems: Items?
      
        let remain = pickItemModel.compareAmount(amount: pickItems.item.amount,
                                                 type: model.type, config: model.valueConfig)
        if remain >= 0 {
            copyItems = Items(name: item.name, date: model.date,
                                          image: item.image, amount: pickItems.item.amount,
                                          entityDT: userDTView.dtPickerView.date, type: model.type)
            
        } else {
            
            let overrange = remain.magnitude
            self.presentAlertVC(title: "범위초과", message: "😮 \(overrange)g 더 넣었네요!", buttonTitle: "OK")
            copyItems = nil
        }
        
        return copyItems
    }
    
    @objc func pressedAdd() {
        guard let selectedItem = copyItem(),
              !checkedIndexPath.isEmpty else { return }
        
        dismissVC()
        
        if let entityDT = fetchedItem?.entityDT {
            delegate?.updateItems(item: selectedItem, oldDate: entityDT)
        } else {
            delegate?.addItems(item: selectedItem)
        }
    }
    
    func checkMaxValueFromDate(date: String) {
        let defaultV = Int(SettingManager.getMaxValue(keyName: "VeggieAmount") ?? 0)
        let defaultF = Int(SettingManager.getMaxValue(keyName: "FruitAmount") ?? 0)

        let type = ["야채", "과일"]
        let newDate = date.extractDate
        var values: [Int] = []
        type.map { type in
           
            let value = CoreDataManager.queryMax(date: date, type: type)
            values.append(value)
        }
        
        let maxV = (values[0] == 0) ? defaultV : values[0]
        let maxF = (values[1] == 0) ? defaultF : values[1]

        model.valueConfig.maxVeggies = maxV
        model.valueConfig.maxFruits = maxF
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
    
    func changeDateRange() {

        if let minDate = model.minDate, let maxDate = model.maxDate {
            userDTView.changeDateRange(minDate: minDate, maxDate: maxDate)
        }
    }
    
    fileprivate func changeSegmentBySection() {
        if sectionFilter == .chart {
            if model.type == "야채" {
                kindSegmentControl.selectedSegmentIndex = 0
            } else {
                kindSegmentControl.selectedSegmentIndex = 1
            }
            
            return
        }
        
        let type = SettingManager.getKindSegment(keyName: "KindOfItem") ?? ""
        (type == "야채") ? (kindSegmentControl.selectedSegmentIndex = 0) : (kindSegmentControl.selectedSegmentIndex = 1)
        changedIndexSegment(sender: kindSegmentControl)
    }
    
    private var btnAdd = VFButton()
    private var measurementView: MeasurementView!
    private var userDTView: UserDateTimeView!
    private var fetchedItem: Items?
    var sectionFilter: SectionFilter?
    
    var datePickerView: UserDateTimeView {
        return userDTView
    }
    
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
