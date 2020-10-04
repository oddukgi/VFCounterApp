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
        
        let defaultFont = NanumSquareRound.bold.style(sizeOffset: 13)
        segmentControl = CustomSegmentedControl()
        segmentControl.setButtonTitles(buttonTitles: [ "주","월"])
        segmentControl.selectorViewColor = ColorHex.jadeGreen
        segmentControl.selectorTextColor = ColorHex.jadeGreen
        segmentControl.titleFont = defaultFont
        segmentControl.resourceType = .timeSection
        segmentControl.delegate = self
      
        let width = 200
        view.addSubViews(segmentControl, btnAdd)

        segmentControl.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
            make.centerX.equalTo(view.snp.centerX)
            make.size.equalTo(CGSize(width: width, height: 38))
        }
        segmentControl.layer.borderWidth = 1
    
        btnAdd.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
            $0.leading.equalTo(segmentControl.snp.trailing).offset(10)
            $0.size.equalTo(CGSize(width: 30, height: 30))
        }
        
        btnAdd.layer.borderWidth = 1
  
        btnAdd.addTarget(self, action: #selector(tappedAdd), for: .touchUpInside)
        
        view.addSubview(contentView)
        contentView.snp.makeConstraints {
            $0.top.equalTo(segmentControl.snp.bottom).offset(13)
            $0.width.equalTo(view.bounds.width)
            $0.bottom.equalTo(datafilterView.snp.top).offset(-10)
        }

    }
        
}
