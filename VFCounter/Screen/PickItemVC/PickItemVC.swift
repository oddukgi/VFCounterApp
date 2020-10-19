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

    func addItems(item: VFItemController.Items, tag: Int)
    func updateItems(item: VFItemController.Items, time: Date?, tag: Int)
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
    
    let pickItems = PickItems()
    var vfItems: VFItemController.Items!
    weak var delegate: PickItemVCProtocol?

    var checkedIndexPath = Set<IndexPath>()
    var datemodel: DateModel!
    var kindSegmentControl: UISegmentedControl!
  
    init(delegate: PickItemVCProtocol, datemodel: DateModel, sectionFilter: SectionFilter = .main) {
        super.init(nibName: nil, bundle: nil)
        self.delegate        = delegate
        self.datemodel       = datemodel
        self.sectionFilter   = sectionFilter
    }
    
    var items: VFItemController.Items? {
        didSet {
            self.fetchedItem = self.items
        }
    }

    var newDate: String {
        return String(datemodel.date.split(separator: " ").first!)
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

    func updateNaviTitle(to tag: Int) {
        tag == 0 ? (navigationItem.title = NavTitle.veggie.text)
            : (navigationItem.title = NavTitle.fruit.text)
    }
    
    func configureBarItem() {
        
        view.backgroundColor = ColorHex.lightKhaki
        let doneButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self,
                                         action: #selector(dismissVC))
    
        updateNaviTitle(to: datemodel.tag)
        navigationItem.rightBarButtonItem = doneButton
        self.setupToHideKeyboardOnTapOnView()
    }
    
    @objc func dismissVC() {
        dismiss(animated: true)
    }

    func configureMeasurementView() {
    
        measurementView = MeasurementView(tag: datemodel.tag)
        view.addSubview(measurementView)
        measurementView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(50)
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
        
        _ = (view.bounds.height / 2) - SizeManager().veggiePickCVHeight
        collectionView.snp.makeConstraints {
            $0.top.equalTo(measurementView.snp.bottom).offset(10)
            $0.leading.trailing.equalTo(view)
            $0.height.equalTo(100)
        }
        collectionView.delegate = self
    }
   
    func configureSubview() {

        if fetchedItem != nil {
            datemodel.date = fetchedItem!.date
        }
        
        userDTView = UserDateTimeView(dateTime: datemodel.date,
                                     entityTime: fetchedItem?.entityDT)
    
        userDTView.delegate = self
        view.addSubViews(userDTView, btnAdd)
       
        userDTView.snp.makeConstraints { make in
            make.top.equalTo(stackView.snp.bottom).offset(20)
            make.leading.equalTo(view).offset(20)
            make.trailing.equalTo(view).offset(-20)
            make.height.equalTo(120)
        }
        
        btnAdd.snp.makeConstraints { make in
            make.top.equalTo(userDTView.snp.bottom).offset(25)
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
    @objc func pressedAdd() {
   
        guard !checkedIndexPath.isEmpty else { return }
            
        let indexPath = checkedIndexPath.first!
        let row = indexPath.row
        let item = currentSnapshot.itemIdentifiers[row]
        
        pickItems.item.amount = Int(measurementView.gramTF.text!) ?? 0
        datemodel.date = userDTView.dateTime
        if compareAmount(amount: pickItems.item.amount) {
            return
        }
   
        let selectedItem = VFItemController.Items(name: item.name, date: datemodel.date, image: item.image, amount: pickItems.item.amount, entityDT: userDTView.dtPickerView.date)
        
        if fetchedItem != nil {
            delegate?.updateItems(item: selectedItem, time: fetchedItem?.entityDT, tag: datemodel.tag)
        } else {
            delegate?.addItems(item: selectedItem, tag: datemodel.tag)
        }

        dismissVC()
    }

    func getSumValue() {
        let datamanager = DataManager()
        let sum = datamanager.getSumItems(date: newDate)
        datemodel.sumV = sum.0
        datemodel.sumF = sum.1
    }
    
    func updateCurrentMaxValue() {
        let veggieRate = SettingManager.getTaskValue(keyName: "VeggieTaskRate") ?? 0
        let fruitRate = SettingManager.getTaskValue(keyName: "FruitTaskRate") ?? 0
        
        let maxV = (veggieRate > 0) ? Int(veggieRate) : datemodel.maxV
        let maxF = (fruitRate > 0) ? Int(fruitRate) : datemodel.maxF
        datemodel.maxV = maxV
        datemodel.maxF = maxF
        getSumValue()
    }

    // MARK: - update max value from UIDatePickerView
    func checkMaxValueFromDate(date: String) {
       
        let datamanager = DataManager()
        datemodel.date = date
        let maxValues = datamanager.getMaxData(date: newDate)
        let maxVeggie = (maxValues.0 == 0) ? datemodel.maxV : maxValues.0
        let maxFruit = (maxValues.1 == 0) ? datemodel.maxF : maxValues.1
        
        SettingManager.setVeggieTaskRate(percent: Float(maxVeggie))
        SettingManager.setFruitsTaskRate(percent: Float(maxFruit))
        
        datemodel.maxV = maxVeggie
        datemodel.maxF = maxFruit
        getSumValue()
    }
    
    func compareAmount(amount: Int) -> Bool {
        
        var sumV = datemodel.sumV
        var sumF = datemodel.sumF
          
        if datemodel.tag == 0 {
            
            let simulatedVeggie = sumV + amount
            let remain = datemodel.maxV - sumV
            
            if (simulatedVeggie > datemodel.maxV) && amount > 0 {
                self.presentAlertVC(title: "알림", message: "\(remain)g 추가할 수 있습니다.", buttonTitle: "OK")
                return true
            }
            
        } else {
            
            let simulatedFruit = sumF + amount
            let remain = datemodel.maxF - sumF
            
            if (simulatedFruit > datemodel.maxF) && amount > 0 {
                self.presentAlertVC(title: "알림", message: "\(remain)g 추가할 수 있습니다.", buttonTitle: "OK")
                return true
            }
        }
        
        return false
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
    private var fetchedItem: VFItemController.Items?
    private var sectionFilter: SectionFilter?
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .center
        stackView.spacing = 12
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
