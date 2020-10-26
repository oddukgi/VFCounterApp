//
//  MonthlyListVC.swift
//  VFCounter
//
//  Created by Sunmi on 2020/09/22.
//  Copyright © 2020 creativeSun. All rights reserved.
//

import UIKit

class PeriodListVC: BaseViewController {

    var tableView: UITableView!

    private let reuseIdentifer = "MonthlyList"
    var sectionControl: CustomSegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        connectAction()
        configureTableView()       
    }
    
     private let fetchedItems =  [ { (newDate) -> [DataType] in
        return DataManager.fetchVeggieData(date: newDate)
     }, { (newDate) -> [DataType] in
        return DataManager.fetchFruitData(date: newDate)
     } ]
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updatePeriod()
        updateResource()
        self.initializeData()
        self.tableView.reloadData()
        
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
            $0.width.equalTo(130)
        }
    }

    func configureTableView() {

        tableView = CustomTableView(frame: view.bounds, style: .grouped)
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(stackView.snp.bottom).offset(8)
            make.leading.trailing.equalTo(view)
            make.bottom.equalTo(view.snp.bottom)
        }

        tableView.rowHeight = SizeManager().getUserItemHeight + 15
        tableView.sectionHeaderHeight = 44
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ElementCell.self, forCellReuseIdentifier: ElementCell.reuseIdentifier)
        tableView.backgroundColor = ColorHex.iceBlue
    }
    
    func updateResource() {

        let datemap = dateStrategy.updateLabel()
        lblPeriod.text = datemap.0
        weekday = datemap.1!
        datemaps = datemap.2!
        
        let date = datemaps[0].changeDateTime(format: .longDate)
        delegate?.sendChartDate(date: date)
    }

    func connectAction() {

        arrowButtons[0].addTargetClosure { _ in
            self.updatePeriod()
            self.dateStrategy.previous()
            self.updateResource()
            self.initializeData()
            self.tableView.reloadData()
            
        }
        arrowButtons[1].addTargetClosure { _ in
            self.updatePeriod()
            self.dateStrategy.next()
            self.updateResource()
            self.initializeData()
            self.tableView.reloadData()
        }
    }

    func initializeData() {
       
        var subcategory = [String]()
     
        var vData: [DataType] = []
        var fData: [DataType] = []
        
        var dtArray = [String]()
        if periodData.arrTBCell.count > 0 {
            periodData.arrTBCell.removeAll()
        }
        weekday.forEach { (item) in
  
           vData = self.fetchedItems[0](item.extractDate)
           fData = self.fetchedItems[1](item.extractDate)
           
           if vData.count > 0  && fData.count > 0 {
               subcategory = ["야채", "과일"]
           } else {
               subcategory = [ (vData.count > 0) ? "야채" : "과일" ]
           }

           let tbCellModel = TableViewCellModel(date: item,
                                                subcategory: subcategory, data: [vData, fData])
           
           self.periodData.arrTBCell.append(tbCellModel)
 
       }
    
    }

    func moveToScrollAddingItem() {
        if self.isAddedItem {
            let date = self.dateStrategy.date.changeDateTime(format: .longDate)
            
            for (index, item) in self.weekday.enumerated() {
                if item == date {
                    self.tableView.scrollToTop(animated: true, section: index)
                }
            }
            
            self.isAddedItem = false
        }
    }
    lazy var stackView: UIStackView = {
          let stackView = UIStackView()
          stackView.spacing = 130
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

    let lblPeriod = VFTitleLabel(textAlignment: .center, font: .systemFont(ofSize: SizeManager().dateViewFontSize))

}
