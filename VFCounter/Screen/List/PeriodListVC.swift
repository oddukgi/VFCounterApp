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
    var weekday = Array<String>()
    var datemaps = Array<String>()
    private let reuseIdentifer = "MonthlyList"
    var sectionControl: CustomSegmentedControl!
    var selectedIndex: Int = 0


    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        connectAction()
        configureTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        updatePeriod()
        updateResource()
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
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.register(ElementCell.self, forCellReuseIdentifier: ElementCell.reuseIdentifier)
        
        guard #available(iOS 10.0, *) else {
            // Manually observe the UIContentSizeCategoryDidChange
            // notification for iOS 9.

            NotificationCenter.default.addObserver(self, selector: #selector(contentSizeDidChange(_:)), name: UIContentSizeCategory.didChangeNotification, object: nil)
            return
        }
    }

    func updateResource(_ isReloaded: Bool = false) {

        let datemap = dateStrategy.updateLabel()
        lblPeriod.text = datemap.0
        weekday = datemap.1!
        datemaps = datemap.2!

        if isReloaded == true {
            self.tableView.reloadData()
        }
     }

    func connectAction() {
        
        arrowButtons[0].addTargetClosure { _ in
            self.updatePeriod()
            self.dateStrategy.previous()
            self.updateResource(true)
        }
        arrowButtons[1].addTargetClosure { _ in
            self.updatePeriod()
            self.dateStrategy.next()
            self.updateResource(true)
        }
    }
 
    @objc func tappedOutsideOfTableView() {
        print("user tapped outside table view")
    }
    
    @objc private func contentSizeDidChange(_ notification: NSNotification) {
        tableView.reloadData()
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
                                             userInfo: [ "indexPath": indexPath ])
        }))

        self.present(alert, animated: true, completion: nil)
    }

}

