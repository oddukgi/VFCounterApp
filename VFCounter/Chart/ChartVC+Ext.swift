//
//  ChartVC+Ext.swift
//  VFCounter
//
//  Created by Sunmi on 2020/08/13.
//  Copyright © 2020 creativeSun. All rights reserved.
//

import UIKit

extension ChartVC {

    func currentDate() -> String {
        
        // segment control 인덱스 가져오기 (0:주, 1:월) / (0: 데이터, 1:리스트)
        let periodIndex = uiconfig.periodSegmentCtrl.selectedIndex
        let dataIndex = uiconfig.datafilterView.dataSegmentControl.selectedIndex
        return chartModel.getCurrentDate(periodIndex: periodIndex,
                                         dataIndex: dataIndex, configure: dateConfigure)
    }
    
    func configureSubviews() {

        let defaultFont = NanumSquareRound.bold.style(offset: 15)
        uiconfig.periodSegmentCtrl = CustomSegmentedControl()
        uiconfig.periodSegmentCtrl.setButtonTitles(buttonTitles: [ "주", "월"])
        uiconfig.periodSegmentCtrl.selectorViewColor = ColorHex.jadeGreen
        uiconfig.periodSegmentCtrl.selectorTextColor = ColorHex.jadeGreen
        uiconfig.periodSegmentCtrl.titleFont = defaultFont
        uiconfig.periodSegmentCtrl.resourceType = .timeSection
        uiconfig.periodSegmentCtrl.delegate = self

        let width = 200
        view.addSubViews(uiconfig.periodSegmentCtrl, uiconfig.btnAdd)

        let segmentSize = SizeManager().segmentSize()
        uiconfig.periodSegmentCtrl.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
            make.centerX.equalTo(view.snp.centerX)
            make.size.equalTo(segmentSize)
        }

        let btnSize = SizeManager().chartAddBtnSize()
        uiconfig.btnAdd.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
            $0.trailing.equalTo(view).offset(-20)
            $0.size.equalTo(btnSize)
        }

        uiconfig.btnAdd.addTarget(self, action: #selector(tappedAdd), for: .touchUpInside)
        
        let height = SizeManager().chartHeight
        view.addSubview(uiconfig.contentView)
        uiconfig.contentView.snp.makeConstraints {
            $0.top.equalTo(uiconfig.periodSegmentCtrl.snp.bottom).offset(13)
            $0.left.right.equalToSuperview()
            $0.bottom.equalTo(uiconfig.datafilterView.snp.top).offset(-8)
        }
        
        uiconfig.contentView.layoutIfNeeded()
    }
    
    func updateViewController(item: Items, config: ValueConfig) {
        
        let periodIndex = uiconfig.periodSegmentCtrl.selectedIndex
        let dataIndex = uiconfig.datafilterView.selectedItem
       
        print("Class Name: \(currentVC?.className)")

        let dateTime = item.entityDT
        
        if dataIndex == 1 {
            dateConfigure.date = dateTime ?? Date()
            
            if currentVC?.className == "PeriodListVC" {
                var periodListVC = currentVC as! PeriodListVC
                periodListVC.date = dateConfigure.date
                periodListVC.createEntity(item: item, config: config)
            }
            
        } else {
            dateConfigure.calendarDate = dateTime ?? Date()

            if periodIndex == 0 {
                
                var weeklyChartVC = currentVC as! WeeklyChartVC
                weeklyChartVC.date =  dateConfigure.calendarDate
                weeklyChartVC.model.createEntity(item: item, config: config)
            
            } else {

                let mainListModel = MainListModel(date: item.date.extractDate)
                calendarController.moveToSpecificDate(date: self.dateConfigure.calendarDate)
                mainListModel.createEntity(item: item, config: config)
            }
            
        }
    }
    
}
extension ChartVC: PickItemProtocol {
    
    func addItems(item: Items) {
    
        let strDate = item.date.extractDate
        chartModel.checkMaxValueFromDate(date: strDate)
        updateViewController(item: item, config: chartModel.valueConfig)
    }
    
    func updateItems(item: Items, oldDate: Date) {
        
    }
}

extension ChartVC: UpdateDateDelegate {

    func sendChartDate(date: Date) {
        dateConfigure.date = date
    }
}
