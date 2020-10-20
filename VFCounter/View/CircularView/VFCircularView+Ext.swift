//
//  VFCircularView+Ext.swift
//  VFCounter
//
//  Created by Sunmi on 2020/07/23.
//  Copyright © 2020 creativeSun. All rights reserved.
//

import UIKit

extension VFCircularView {

    func setCircularView() {

        ringView = MainRingView()
        addSubview(ringView)
        let sliderSize = SizeManager().sliderSize()
        let padding = SizeManager().ringViewPadding
        
        ringView.snp.makeConstraints { make in
            make.bottom.equalTo(self).offset(-padding)
            make.trailing.equalTo(self.snp.trailing).offset(-18)
            make.size.equalTo(sliderSize)
        }

        for _ in 0 ..< 2 {
            let stackview          = UIStackView()
            stackview.axis         = .horizontal
            stackview.distribution = .fill
            stackview.spacing = 8
            horizontalStackView.append(stackview)
        }
    }

    func setsubviewLayout() {

        horizontalStackView[0].addArrangedSubview(veggieCircle)
        horizontalStackView[0].addArrangedSubview(lbveggie)
        addSubViews(horizontalStackView[0], totVeggieLabel)
        
        horizontalStackView[1].addArrangedSubview(fruitsCircle)
        horizontalStackView[1].addArrangedSubview(lbFruits)
        addSubViews(horizontalStackView[1], totFruitLabel)

        horizontalStackView[1].snp.makeConstraints { make in
            make.top.equalTo(self).offset(110)
            make.leading.equalTo(self).offset(18)
            make.height.equalTo(20)

        }
        
        horizontalStackView[0].snp.makeConstraints { make in
            make.top.equalTo(horizontalStackView[1].snp.top).offset(-60)
            make.leading.equalTo(self).offset(18)
            make.height.equalTo(20)
        }
        
        totVeggieLabel.snp.makeConstraints { make in
            make.top.equalTo(horizontalStackView[0].snp.bottom).offset(5)
            make.leading.equalTo(self).offset(18)
            make.height.equalTo(23)
        }
        
        totFruitLabel.snp.makeConstraints { make in
            make.top.equalTo(horizontalStackView[1].snp.bottom).offset(5)
            make.leading.equalTo(self).offset(18)
            make.height.equalTo(23)
        }
    }

}
