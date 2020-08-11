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
    
        addSubview(outerSlider)
        addSubview(insideSlider)

        let sliderSize = SizeManager().sliderSize()
        outerSlider.snp.makeConstraints { make in

            make.centerY.equalTo(self.snp.centerY)
            make.trailing.equalTo(self.snp.trailing).offset(-20)
            make.size.equalTo(sliderSize.0)
        }

        insideSlider.snp.makeConstraints { make in

            make.center.equalTo(outerSlider)
            make.size.equalTo(sliderSize.1)
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
        
        addSubview(horizontalStackView[0])
        horizontalStackView[0].addArrangedSubview(vegieCircle)
        horizontalStackView[0].addArrangedSubview(lbVegie)
        horizontalStackView[0].snp.makeConstraints { make in
            make.top.equalTo(outerSlider.snp.top).offset(20)
            make.leading.equalTo(self).offset(20)
            make.height.equalTo(20)
        }
        
        addSubview(horizontalStackView[1])
        horizontalStackView[1].addArrangedSubview(fruitsCircle)
        horizontalStackView[1].addArrangedSubview(lbFruits)
        horizontalStackView[1].snp.makeConstraints { make in
            make.top.equalTo(horizontalStackView[0].snp.bottom).offset(10)
            make.leading.equalTo(horizontalStackView[0])
            make.height.equalTo(20)
            
        }
    }
}
