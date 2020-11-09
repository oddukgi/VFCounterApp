//
//  ChartVC+Ext.swift
//  VFCounter
//
//  Created by Sunmi on 2020/08/13.
//  Copyright © 2020 creativeSun. All rights reserved.
//

import UIKit

extension ChartVC {
    
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
        view.addSubview(contentView)
        contentView.snp.makeConstraints {
            $0.top.equalTo(uiconfig.periodSegmentCtrl.snp.bottom).offset(13)
            $0.left.right.equalToSuperview()
            $0.bottom.equalTo(uiconfig.datafilterView.snp.top).offset(-8)
        }
        
        contentView.layoutIfNeeded()
    }
    
}

extension ChartVC: UpdateDateDelegate {

    func sendChartDate(date: Date) {
        dateConfigure.date = date
    }
}
