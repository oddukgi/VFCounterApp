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
    func displayPickItems(for items: [VFItemController.Items])
}

class PickItemVC: UIViewController {

    enum Section: String {
      
        case vegie = "오늘 먹은 야채 선택하기"
        case fruit = "오늘 먹은 과일 선택하기"
            
        var sectionTitle: String {
            return rawValue
        }
    }
    
    var collectionView: UICollectionView! = nil
    var dataSource: UICollectionViewDiffableDataSource<Section, PickItems.Element>! = nil

    let pickItems = PickItems()
 
    var timer: Timer?
    var vfItems: [VFItemController.Items] = []
    weak var delegate: PickItemVCProtocol?
    var tag: Int = 0
    var checkedIndexPath = Set<IndexPath>()
    var amount: Int = 0
    var pickDate: String = ""
    var measurementView: MeasurementView!

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
    
    
    func setMeasurementView() {
        
        measurementView = MeasurementView(delegate: self)
        view.addSubViews(measurementView)        
        measurementView.snp.makeConstraints { make in
            make.top.equalTo(collectionView.snp.bottom).offset(30)
            make.leading.trailing.equalTo(view)
            make.height.equalTo(250)
        }
    }

    @objc func dismissVC() {
        dismiss(animated: true)
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
        let time = timeFormatter.getCurrentTime(date: Date())
        btnTime.setTitle(time, for: .normal)
        
    }
  
    @objc func tappedAddItem() {
        guard vfItems.count > 0 else { return }
        
        
        delegate?.displayPickItems(for: vfItems)
        dismissVC()
    }
    
    
    lazy var btnClose: VFButton = {
        let button = VFButton()
        button.addImage(imageName: "close")
        button.addTarget(self, action: #selector(dismissVC), for: .touchUpInside)
        return button
    }()
    
    lazy var btnTime: VFButton = {
        let button = VFButton()
        button.layer.cornerRadius = 10
        button.backgroundColor    = ColorHex.dimmedBlack
        button.setFont(clr: ColorHex.MilkChocolate.origin, font: NanumSquareRound.extrabold.style(sizeOffset: 13))
        return button
    }()
    
    lazy var btnAdd: VFButton = {
        let button = VFButton()
        button.setTitle("Add", for: .normal)
        button.backgroundColor    = ColorHex.orangeyRed
        button.setFont(clr: .white, font: NanumSquareRound.extrabold.style(sizeOffset: 16))
        button.layer.cornerRadius = 18
        button.setRadiusWithShadow(18)
        button.addTarget(self, action: #selector(tappedAddItem), for: .touchUpInside)
        return button
    }()
    
      
}

