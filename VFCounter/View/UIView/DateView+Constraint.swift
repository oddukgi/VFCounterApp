//
//  DateView+Constraint.swift
//  VFCounter
//
//  Created by Sunmi on 2020/07/24.
//  Copyright © 2020 creativeSun. All rights reserved.
//

import UIKit


extension DateView {
    
    func configureStackView() {
        
        for _ in 0 ..< 3 {
            let stackView          = UIStackView()
            stackView.axis         = .horizontal
            stackView.distribution = .fill
            horizontalView.append(stackView)
        }
    }
    
    func setLayout() {
        let centerX = UIScreen.main.bounds.width / 2
        let leftPadding = (centerX / 2) + 20
        
        btnLeftArrow = VFButton(frame: CGRect(x: 0, y: 0, width: 48, height: 50))
        btnLeftArrow.setLeftTriangle()
        btnRightArrow = VFButton(frame: CGRect(x: 0, y: 0, width: 48, height: 50))
        btnRightArrow.setRightTriangle()
        
        self.addSubViews(horizontalView[0], dateLabel, weatherLabel, weatherIcon)
        horizontalView[0].addArrangedSubview(btnLeftArrow)
        horizontalView[0].addArrangedSubview(btnRightArrow)
        horizontalView[0].spacing = 130

        let padding = (150 / 3) - 11
        horizontalView[0].snp.makeConstraints { make in
            make.top.equalTo(self).offset(padding)
            make.centerX.equalTo(self).offset(5)
            make.height.equalTo(50)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(horizontalView[0])
            make.leading.equalTo(btnLeftArrow.snp.trailing)
            make.width.equalTo(130)
        }
    
        // MARK: - Icon & Label
        weatherIcon.snp.makeConstraints { make in
            make.top.equalTo(self).offset(12)
            make.leading.equalTo(self).offset(10)
            make.size.equalTo(CGSize(width: 28, height: 32))
         }
        
        weatherLabel.snp.makeConstraints { make in
            make.top.equalTo(weatherIcon)
            make.leading.equalTo(weatherIcon.snp.trailing).offset(2)
            make.height.equalTo(weatherIcon)
        }

	}

}
