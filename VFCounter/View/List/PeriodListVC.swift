//
//  MonthlyListVC.swift
//  VFCounter
//
//  Created by Sunmi on 2020/09/22.
//  Copyright © 2020 creativeSun. All rights reserved.
//

import UIKit

class PeriodListVC: UIViewController {

    let elementDataSource = ElementDataSource()
    var periodRange: PeriodRange
    var tableView: UITableView!
    
    private let reuseIdentifer = "MonthlyList"
    private var dateStrategy: DateStrategy!


    init(periodRange: PeriodRange,dateStrategy: DateStrategy) {
      
        self.periodRange = periodRange
        self.dateStrategy = dateStrategy
        super.init(nibName: nil, bundle: nil)
    
   }
     
   required init?(coder: NSCoder) {
       fatalError("init(coder:) has not been implemented")
   }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
     
        connectAction()
        configureTableView()
        updatePeriod()
    }
    
    // MARK: create collectionView layout
    
    private func configureView() {
        view.backgroundColor = .white
        view.addSubViews(stackView, lblPeriod)
        
        arrowButtons.forEach {
            stackView.addArrangedSubview($0)
        }
        
        stackView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(7)
            $0.centerX.equalTo(view.snp.centerX)
            $0.height.equalTo(32)
        }
        
        lblPeriod.snp.makeConstraints {
            $0.leading.equalTo(arrowButtons[0].snp.trailing)
            $0.centerY.equalTo(stackView.snp.centerY)
            $0.width.equalTo(105)
        }
        lblPeriod.textColor = .black
    }


    func configureTableView() {
        tableView = UITableView(frame: view.bounds, style: .grouped)
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(stackView.snp.bottom).offset(8)
            make.leading.trailing.equalTo(view)
            make.bottom.equalTo(view.snp.bottom).offset(-8)
        }
        tableView.delegate = self
        tableView.dataSource = elementDataSource
        
        tableView.rowHeight = UITableView.automaticDimension
//        tableView.estimatedRowHeight = SizeManager().getUserItemHeight * 2
        tableView.contentInsetAdjustmentBehavior = .automatic
        tableView.register(ElementCell.self, forCellReuseIdentifier: ElementCell.reuseIdentifier)
    }

    
    func updatePeriod(_ reloadData: Bool = false) {
        
        dateStrategy.setDateRange()
        let dateMap = dateStrategy.updateLabel()
        lblPeriod.text = dateMap.0
        
        let dateSet = dateMap.1!
        elementDataSource.weekday = dateSet
        
        tableView.isUserInteractionEnabled = true
      
        if reloadData == true {

            self.tableView.reloadData()
        }
         
     }
       
    
    func connectAction() {
        
        arrowButtons[0].addTargetClosure { _ in
            self.dateStrategy.previous()
            self.updatePeriod(true)

        }
        arrowButtons[1].addTargetClosure { _ in
            self.dateStrategy.next()
            self.updatePeriod(true)
        }
        
     
    }
    
    lazy var stackView: UIStackView = {
          let stackView = UIStackView()
          stackView.spacing = 105
          stackView.axis = .horizontal
          stackView.distribution = .fill
          return stackView
    }()
    
    
    lazy var arrowButtons: [UIButton] = {
        var buttons = [UIButton]()
        var img = ["chartL", "chartR"]
        (0 ..< 2).forEach { index in
            
            let button = UIButton()
            button.setImage(UIImage(named: img[index]), for: .normal)
            button.contentMode = .scaleAspectFit
            buttons.append(button)
        }
        return buttons
    }()
    
    let lblPeriod = VFTitleLabel(textAlignment: .center, fontSize: 14)
}

extension PeriodListVC: UITableViewDelegate {
    
}

