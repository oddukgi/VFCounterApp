//
//  ChartVC+Ext.swift
//  VFCounter
//
//  Created by Sunmi on 2020/08/13.
//  Copyright © 2020 creativeSun. All rights reserved.
//

import UIKit

extension ChartVC {

    func configure() {

        let defaultFont = NanumSquareRound.bold.style(offset: 15)
        periodSegmentCtrl = CustomSegmentedControl()
        periodSegmentCtrl.setButtonTitles(buttonTitles: [ "주", "월"])
        periodSegmentCtrl.selectorViewColor = ColorHex.jadeGreen
        periodSegmentCtrl.selectorTextColor = ColorHex.jadeGreen
        periodSegmentCtrl.titleFont = defaultFont
        periodSegmentCtrl.resourceType = .timeSection
        periodSegmentCtrl.delegate = self

        let width = 200
        view.addSubViews(periodSegmentCtrl, btnAdd)

        periodSegmentCtrl.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
            make.centerX.equalTo(view.snp.centerX)
            make.size.equalTo(CGSize(width: width, height: 40))
        }

        btnAdd.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
            $0.leading.equalTo(periodSegmentCtrl.snp.trailing).offset(20)
            $0.size.equalTo(CGSize(width: 40, height: 40))
        }

        btnAdd.addTarget(self, action: #selector(tappedAdd), for: .touchUpInside)
        
        let height = SizeManager().chartHeight
        view.addSubview(contentView)
        contentView.snp.makeConstraints {
            $0.top.equalTo(periodSegmentCtrl.snp.bottom).offset(13)
            $0.width.equalTo(view.bounds.width)
            $0.bottom.equalTo(datafilterView.snp.top).offset(-8)
        }
    }
}
