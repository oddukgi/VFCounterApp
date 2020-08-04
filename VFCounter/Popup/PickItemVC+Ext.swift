//
//  PickItemVC+Ext.swift
//  VFCounter
//
//  Created by Sunmi on 2020/08/03.
//  Copyright © 2020 creativeSun. All rights reserved.
//

import UIKit
import SnapKit

extension PickItemVC {
    
    func setScrollerRulerView() {
        let unitStr = "g"
        let rulersHeight = DYScrollRulerView.rulerViewHeight()
        
        let screenWidth  = ScreenSize.width
   
        scrollRulerView = DYScrollRulerView(frame: view.bounds, tminValue: 0, tmaxValue: 1500, tstep: 20, tunit: unitStr, tNum: 5, viewcontroller:self)
        
        view.addSubview(scrollRulerView)
        scrollRulerView.snp.makeConstraints {
            $0.top.equalTo(btnAdd.snp.top).offset(SizeManager().paddingForRulerView)
            $0.leading.equalTo(view).offset(5)
            $0.width.equalTo(screenWidth - 20)
            $0.height.equalTo(rulersHeight + 10)
        }
        
        var value = 120
        if amount > 0 {
            value = amount
        }
        scrollRulerView.setDefaultValueAndAnimated(defaultValue: value, animated: true)
        scrollRulerView.bgColor       = UIColor.black
        scrollRulerView.triangleColor = UIColor.orange
        scrollRulerView.delegate      = self
        scrollRulerView.scrollByHand  = true
    }
}

extension PickItemVC: DYScrollRulerDelegate {
    func dyScrollRulerViewValueChange(rulerView: DYScrollRulerView, value: Float) {
        amount = Int(value)
        print("Value: \(value)")
    }
}

