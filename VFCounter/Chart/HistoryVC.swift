//
//  HistoryVC.swift
//  VFCounter
//
//  Created by Sunmi on 2020/09/15.
//  Copyright © 2020 creativeSun. All rights reserved.
//

import UIKit

class HistoryVC: UIViewController {
    
    var periodRange: PeriodRange
    var date: String?
    let lblweek = VFTitleLabel(textAlignment: .center, fontSize: 14)
    private var aDayWeek: Date?
    var setting: DateSettings.HistoryList
    
    var weekDate = Array<String>()
    let sectionHeaderElementKind = "section-header-element-kind"
    var checkedIndexPath = Set<IndexPath>()
    let dataManager = DataManager()
    
    init(periodRange: PeriodRange, setting: DateSettings.HistoryList) {
        self.periodRange = periodRange
        self.setting = setting
        super.init(nibName: nil, bundle: nil)
        getCurrentWeek()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        
        configureView()
        configureHierarchy()
        connectAction()
        configureDataSource()
        configureTitleDataSource()

        updateList()
    }
    

    // MARK: create collectionView layout
    
    private func configureView() {
        view.addSubViews(stackView, lblweek)
        
        arrowButtons.forEach {
            stackView.addArrangedSubview($0)
        }
        
        stackView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(7)
            $0.centerX.equalTo(view.snp.centerX)
            $0.height.equalTo(32)
        }
        
        lblweek.snp.makeConstraints {
            $0.leading.equalTo(arrowButtons[0].snp.trailing)
            $0.centerY.equalTo(stackView.snp.centerY)
            $0.width.equalTo(105)
        }
    }

    
    func configureHierarchy() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UIHelper.createList())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        collectionView.register(ListCell.self, forCellWithReuseIdentifier: ListCell.reuseIdentifier)
        collectionView.register(SectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                     withReuseIdentifier: SectionHeader.reuseIdentifier)
        
        view.addSubview(collectionView)
        
        collectionView.backgroundColor = ColorHex.iceBlue
        collectionView.snp.makeConstraints {
            $0.top.equalTo(stackView.snp.bottom).offset(8)
            $0.leading.trailing.equalTo(view)
            $0.bottom.equalTo(view.snp.bottom).offset(-8)
        }


    }
    
    private func getCurrentWeek() {
        if DateSettings.default.listCtrl.startDate == nil {
            aDayWeek = setting.startDate?.getStartOfWeek()
        } else {
            aDayWeek = DateSettings.default.listCtrl.startDate 
        }
        updateData()
    }
    
    func connectAction() {
        
        arrowButtons[0].addTargetClosure { _ in
            self.aDayWeek = self.aDayWeek?.aDayInLastWeek.getStartOfWeek()
            DateSettings.default.weekChartCtrl.startDate = self.aDayWeek
            self.updateData()
        }
        arrowButtons[1].addTargetClosure { _ in
            self.aDayWeek = self.aDayWeek?.aDayInNextWeek.getStartOfWeek()
            self.updateData()
        }
    }
    
    func updateData() {
        DateProvider.updateDateMap(date: self.aDayWeek!) {  [weak self] (datemap) in
            self?.updateWeekLabel(startDate: datemap.first!, endDate: datemap.last!)
  
            weekDate = datemap.map {
                String($0.split(separator: " ").first!)
            }
            
        }
    }
    
    func updateWeekLabel(startDate: String, endDate: String) {
        let startDateArray = startDate.components(separatedBy: [".", " "])
        let endDateArray = endDate.components(separatedBy: ["."," "])

        let firstMonth = startDateArray[1]
        let secondMonth = endDateArray[1]

        if firstMonth == secondMonth {
            let value = "\(firstMonth).\(startDateArray[2]) ~ \(endDateArray[2])"
            lblweek.text = value
            
        } else {
            let value = "\(firstMonth).\(startDateArray[2]) ~ \(secondMonth).\(endDateArray[2])"
            lblweek.text = value
        }
    }
    
    var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Weeks, SubItems>! = nil
    var currentSnapshot: NSDiffableDataSourceSnapshot<Weeks, SubItems>! = nil
    
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
    
    
}

extension DateSettings {
    
    struct HistoryList {
        var calendar: Calendar = .current
        var startDate: Date?
        
        mutating func weekDays() -> [Weeks] {
            
            
            calendar.locale = Locale(identifier: "ko_KR")
            var weekDays = self.calendar.shortWeekdaySymbols
            weekDays.append(weekDays.remove(at: 0))
            
            var newArray = weekDays.joined(separator: "  ").components(separatedBy: " ")
            newArray.append(" ")
            
            var arrays = [Weeks]()
            newArray.forEach {
                
                let weekitem = Weeks(day: $0)
                arrays.append(weekitem)
            }
            
            return arrays
            
        }
    }

}
