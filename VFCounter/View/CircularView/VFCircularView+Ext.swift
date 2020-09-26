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
      
        ringView.snp.makeConstraints { make in
            make.centerY.equalTo(self.snp.centerY)
            make.trailing.equalTo(self.snp.trailing).offset(-20)
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
        

        addSubview(horizontalStackView[1])
        horizontalStackView[1].addArrangedSubview(fruitsCircle)
        horizontalStackView[1].addArrangedSubview(lbFruits)
        addSubview(totFruitLabel)
        
        horizontalStackView[1].snp.makeConstraints { make in
            make.centerY.equalTo(self.snp.centerY).offset(20)
            make.leading.equalTo(self).offset(20)
            make.height.equalTo(20)
            
        }
        
        totFruitLabel.snp.makeConstraints { make in
            make.top.equalTo(horizontalStackView[1])
            make.leading.equalTo(horizontalStackView[1].snp.trailing).offset(8)
            make.height.equalTo(23)
        }

        addSubview(horizontalStackView[0])
        horizontalStackView[0].addArrangedSubview(veggieCircle)
        horizontalStackView[0].addArrangedSubview(lbveggie)
        addSubview(totVeggieLabel)
        
        horizontalStackView[0].snp.makeConstraints { make in
            make.top.equalTo(horizontalStackView[1].snp.top).offset(-30)
            make.leading.equalTo(self).offset(20)
            make.height.equalTo(20)
        }
        
        totVeggieLabel.snp.makeConstraints { make in
            make.top.equalTo(horizontalStackView[0])
            make.leading.equalTo(horizontalStackView[0].snp.trailing).offset(8)
            make.height.equalTo(23)
        }
        
    }
    

}
