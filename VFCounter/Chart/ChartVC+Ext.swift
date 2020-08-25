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
        
        segmentControl = CustomSegmentControl(items: ["주", "월"])
        segmentControl.selectedSegmentIndex = 0
        
        let width = 200
        view.addSubview(segmentControl)
        
        segmentControl.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            make.centerX.equalTo(view.safeAreaLayoutGuide.snp.centerX)
            make.width.equalTo(width)
            make.height.equalTo(30)
        }
        
        // segmentstyle : rounded
        segmentControl.backgroudClr = .white
        segmentControl.tintClr = UIColor(white: 0, alpha: 0)
        segmentControl.selectedSegmentTintClr = ColorHex.weirdGreen

        let defaultFont = NanumSquareRound.bold.style(sizeOffset: 12)
        segmentControl.initConfiguration(font: defaultFont, color: ColorHex.lightGreyBlue)
        segmentControl.selectedConfiguration(font: defaultFont, color: .white)
        segmentControl.addTarget(self, action: #selector(changedIndexSegment), for: .valueChanged)
        
        view.addSubview(contentView)
        contentView.snp.makeConstraints {
            $0.top.equalTo(segmentControl.snp.bottom).offset(22)
            $0.leading.equalTo(view)
            $0.width.equalTo(view.bounds.width)
            $0.bottom.equalTo(view).offset(-210)
        }
    }
        
}
