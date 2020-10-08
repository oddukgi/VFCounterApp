//
//  MonthlyListVC.swift
//  VFCounter
//
//  Created by Sunmi on 2020/09/22.
//  Copyright © 2020 creativeSun. All rights reserved.
//

import UIKit

class PeriodListVC: UIViewController {

    var tableView: CustomTableView!
    var weekday = Array<String>()
    var datemaps = Array<String>()
    private let reuseIdentifer = "MonthlyList"
    private var dateStrategy: DateStrategy!
    var sectionControl: CustomSegmentedControl!
    var selectedIndex: Int = 0

    
    init(dateStrategy: DateStrategy) {
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
        dateStrategy.fetchedData()
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        updatePeriod(true)
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
        tableView = CustomTableView(frame: view.bounds, style: .grouped)
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(stackView.snp.bottom).offset(8)
            make.leading.trailing.equalTo(view)
            make.bottom.equalTo(view.snp.bottom).offset(-8)
        }
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(ElementCell.self, forCellReuseIdentifier: ElementCell.reuseIdentifier)
    }

    
    func updatePeriod(_ reloadData: Bool = false) {
    
        dateStrategy.setDateRange()
        let datemap = dateStrategy.updateLabel()
        lblPeriod.text = datemap.0
        weekday = datemap.1!
        datemaps = datemap.2!

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

    @objc func tappedOutsideOfTableView() {
        print("user tapped outside table view")
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
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40.0
    }
}

/*
 public override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
     return 61.0
 }
 */

// MARK: - Protocol Extension
extension PeriodListVC: ElementCellProtocol {
    
    func displayPickItemVC(pickItemVC: PickItemVC) {
        DispatchQueue.main.async {
            let navController = UINavigationController(rootViewController: pickItemVC)
            self.present(navController, animated: true)
        }
    }
    
    func updateTableView() {
        updatePeriod(true)
    }

    func presentSelectedAlertVC(item: Int, section: Int) {

        let alert = UIAlertController(title: "", message: "선택한 아이템을 삭제할까요?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "취소", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "예", style: .destructive, handler: { _ in
            
            let indexPath = IndexPath(item: item, section: section)
            NotificationCenter.default.post(name: .deleteTableViewItem, object: nil,
                                             userInfo: [  "indexPath": indexPath ])
        }))

        self.present(alert, animated: true, completion: nil)
    }

}

