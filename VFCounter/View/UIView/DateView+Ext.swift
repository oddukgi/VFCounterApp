//
//  DateView+Ext.swift
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

        btnLeftArrow = VFButton(frame: CGRect(x: 0, y: 0, width: 48, height: 44))
        btnLeftArrow.setLeftTriangle()
        btnRightArrow = VFButton(frame: CGRect(x: 0, y: 0, width: 48, height: 44))
        btnRightArrow.setRightTriangle()

        self.addSubViews(horizontalView[0], dateLabel)
        
        horizontalView[0].addArrangedSubview(btnLeftArrow)
        horizontalView[0].addArrangedSubview(btnRightArrow)
        horizontalView[0].spacing = 135

        let padding = SizeManager().dateViewTopPadding
        horizontalView[0].snp.makeConstraints { make in
            make.top.equalTo(self).offset(padding)
            make.centerX.equalTo(self).offset(5)
            make.height.equalTo(44)
        }

        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(horizontalView[0])
            make.leading.equalTo(btnLeftArrow.snp.trailing)
            make.width.equalTo(135)
        }

	}

}
