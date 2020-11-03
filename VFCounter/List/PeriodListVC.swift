//
//  MonthlyListVC.swift
//  VFCounter
//
//  Created by Sunmi on 2020/09/22.
//  Copyright © 2020 creativeSun. All rights reserved.
//

import UIKit
import CoreStore

class PeriodListVC: UIViewController {
  
    weak var delegate: UpdateDateDelegate?
    var sectionControl: CustomSegmentedControl!
    var strategy: DateStrategy!    
    var model: PeriodListModel!
    var tableView: UITableView!
  
    init(delegate: UpdateDateDelegate, strategy: DateStrategy) {
        super.init(nibName: nil, bundle: nil)
        self.delegate = delegate
        self.strategy = strategy
        self.updatePeriod()
        model = PeriodListModel(strategy: strategy, kind: .list)

    }
    deinit {
        model.removeobserver()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        connectAction()
        configureTableView()
        model.loadTableView()
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
        
        lblPeriod.text = strategy.period
    }

    func configureTableView() {

        tableView = UITableView(frame: view.bounds, style: .grouped)
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(stackView.snp.bottom).offset(8)
            make.leading.trailing.equalTo(view)
            make.bottom.equalTo(view.snp.bottom)
        }
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(ElementCell.self, forCellReuseIdentifier: ElementCell.reuseIdentifier)
        tableView.backgroundColor = ColorHex.iceBlue
        tableView.delegate = self
        model.setupTableView(tableView: tableView)
    }

    func connectAction() {

        arrowButtons[0].addTargetClosure { _ in
            self.strategy.previous()
            self.lblPeriod.text = self.strategy.period
            self.model.refreshHandler?(self.strategy)
        }
        arrowButtons[1].addTargetClosure { _ in
            self.strategy.next()
            self.lblPeriod.text = self.strategy.period
            self.model.refreshHandler?(self.strategy)
        }
    }

    func updatePeriod() {
        strategy.fetchedData()
        strategy.setMinimumDate()
        strategy.setMaximumDate()
    }
    
    func fetchedDate() {
        strategy.getDateMap()
    }
    func changeDefaultDate(date: Date) {
        strategy.date = date
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
