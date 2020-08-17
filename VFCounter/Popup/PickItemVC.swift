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

    let pickItems = PickItems()
 
    var timer: Timer?
    var vfItems: VFItemController.Items!
    weak var delegate: PickItemVCProtocol?
    var tag: Int = 0
    var checkedIndexPath = Set<IndexPath>()
    var amount: Int = 0
    var pickDate: String = ""
    var measurementView: MeasurementView!
    let btnClose = VFButton()
    let btnTime = VFButton()
    var btnAdd = VFButton()
    let now = Date()
    

    init(delegate: PickItemVCProtocol, tag: Int) {
        super.init(nibName: nil, bundle: nil)
        self.delegate = delegate
        self.tag      = tag
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
        setCurrentTime()
    }
    
    // hide navigation bar
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
      
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        timer?.invalidate()
    }
    
    // close button, time button
    func setLayout() {
      
        view.backgroundColor = ColorHex.lightKhaki
        view.addSubViews(btnClose, btnTime, btnAdd)
        
        btnClose.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(25)
            make.trailing.equalTo(view).offset(-14)
            make.size.equalTo(CGSize(width: 29, height: 29))
        }
      
        btnTime.snp.makeConstraints { make in
             make.top.equalTo(view.safeAreaLayoutGuide).offset(24)
             make.leading.equalTo(view).offset(26)
             make.size.equalTo(CGSize(width: 81, height: 30))
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

        btnTime.layer.cornerRadius = 10
        btnTime.backgroundColor    = ColorHex.dimmedBlack
        btnTime.setFont(clr: ColorHex.MilkChocolate.origin, font: NanumSquareRound.extrabold.style(sizeOffset: 13))

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
            make.top.equalTo(collectionView.snp.bottom).offset(30)
            make.leading.trailing.equalTo(view)
            make.bottom.equalTo(btnAdd.snp.top).offset(-20)
        }
    }

    @objc func dismissVC() {
        dismiss(animated: true)
    }
    
    // MARK: Add Button
    @objc func pressedAdd() {
   
        pickItems.item.amount = Int(measurementView.gramTF.text!) ?? 0
        let item = VFItemController.Items(name: pickItems.item.name, time: pickItems.item.time,
                                          date: now, image: pickItems.item.image, amount: pickItems.item.amount)
        
        delegate?.addItems(item: item)

        // save data to context
        dismissVC()
    }

    
    func setCurrentTime() {
        
        timer?.invalidate()
        let seconds = Date.timeIntervalSinceReferenceDate.truncatingRemainder(dividingBy: 60)
        let fireAt = Date(timeIntervalSinceNow: 60 - seconds)
        timer = Timer(fireAt: fireAt, interval: 60, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
        RunLoop.current.add(timer!, forMode: RunLoop.Mode.default)
        
        if btnTime.titleLabel!.text == nil {
            let timeFormatter = TimeFormatter(timeformat: "h:mm a")
            let time = timeFormatter.getCurrentTime(date: Date())
            btnTime.setTitle(time, for: .normal)
        }
        
    }
    
    @objc func updateTime() {

        let timeFormatter = TimeFormatter(timeformat: "h:mm a")
        let time = timeFormatter.getCurrentTime(date: now)
        btnTime.setTitle(time, for: .normal)
        
    }
  
}

