//
//  DateView+Constraint.swift
//  VFCounter
//
//  Created by Sunmi on 2020/07/24.
//  Copyright © 2020 creativeSun. All rights reserved.
//

import UIKit

extension DateView {

    func setLayout() {
        
        for _ in 0 ..< 3 {
            let stackView          = UIStackView()
            stackView.axis         = .horizontal
            stackView.distribution = .fill
            horizontalView.append(stackView)
        }
        
        let centerX = UIScreen.main.bounds.width / 2
        let leftPadding = (centerX / 2) + 20

        btnLeftArrow = VFButton(frame: CGRect(x: 0, y: 0, width: 50, height: 48))
        btnLeftArrow.setLeftTriangle()
        btnRightArrow = VFButton(frame: CGRect(x: 0, y: 0, width: 50, height: 48))
        btnRightArrow.setRightTriangle()

        self.addSubViews(horizontalView[0], dateLabel)
        horizontalView[0].addArrangedSubview(btnLeftArrow)
        horizontalView[0].addArrangedSubview(btnRightArrow)
        horizontalView[0].spacing = 143

        let padding = (150 / 3) - 11
        horizontalView[0].snp.makeConstraints { make in
            make.top.equalTo(self).offset(padding)
            make.centerX.equalTo(self).offset(5)
            make.height.equalTo(48)
        }

        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(horizontalView[0])
            make.leading.equalTo(btnLeftArrow.snp.trailing)
            make.width.equalTo(143)
        }
	}

}
