//
//  MonthlyListVC.swift
//  VFCounter
//
//  Created by Sunmi on 2020/09/22.
//  Copyright © 2020 creativeSun. All rights reserved.
//

import UIKit

class MonthlyListVC: UIViewController {


    var tableView: UITableView!
    private let reuseIdentifer = "MonthlyList"
    var setting: DateSettings.MonthlyList
    let elementDataSource = ElementDataSource()
  

    private var aDay: Date?
    
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = self.setting.locale
        formatter.dateFormat = self.setting.format
        return formatter
    }()
    

   init(setting: DateSettings.MonthlyList) {
       self.setting = setting
       super.init(nibName: nil, bundle: nil)
    
   }
     
   required init?(coder: NSCoder) {
       fatalError("init(coder:) has not been implemented")
   }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.fetchTimeRange()
        configureView()
        updateMonth()
        connectAction()
        configureTableView()
    }
    
    // MARK: create collectionView layout
    
    private func configureView() {
        view.backgroundColor = .white
        view.addSubViews(stackView, lblMonth)
        
        arrowButtons.forEach {
            stackView.addArrangedSubview($0)
        }
        
        stackView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(7)
            $0.centerX.equalTo(view.snp.centerX)
            $0.height.equalTo(32)
        }
        
        lblMonth.snp.makeConstraints {
            $0.leading.equalTo(arrowButtons[0].snp.trailing)
            $0.centerY.equalTo(stackView.snp.centerY)
            $0.width.equalTo(105)
        }
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
        tableView.register(ElementCell.self, forCellReuseIdentifier: ElementCell.reuseIdentifier)
    }

    private func fetchTimeRange() {
        if DateSettings.default.monthlyListCtrl.startDate == nil {
            aDay = setting.startDate
        } else {
            aDay = DateSettings.default.monthlyListCtrl.startDate
        }
    }
    
    func updateMonth() {
        guard let date = aDay else { return }
        lblMonth.text = dateFormatter.string(from: date)
        lblMonth.textColor = setting.textColor

        DateProvider.updateDateMap(date: aDay!, period: .monthly) { (datemap) in
            elementDataSource.dates = datemap
        }
        elementDataSource.checkDate()
        
    }
    
    
    
    func connectAction() {
        
        arrowButtons[0].addTargetClosure { _ in
            
            self.updateMonth()
        }
        arrowButtons[1].addTargetClosure { _ in
//            self.aDayWeek = self.aDayWeek?.aDayInNextWeek.getStartOfWeek()
            self.updateMonth()
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
    
    let lblMonth = VFTitleLabel(textAlignment: .center, fontSize: 14)
}

extension MonthlyListVC: UITableViewDelegate {
    
}

extension DateSettings {
    
    struct MonthlyList {
        var calendar: Calendar = .current
        var startDate: Date?
        var format: String = "YYYY MM"
        var locale = Locale(identifier: "ko_KR")
        var textColor: UIColor = .black
        
    }
}
