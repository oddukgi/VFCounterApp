//
//  SectionHeader.swift
//  VFCounter
//
//  Created by Sunmi on 2020/07/28.
//  Copyright © 2020 creativeSun. All rights reserved.
//

import UIKit

class SectionHeader: UICollectionReusableView, SelfConfigCell {
  
    static let reuseIdentifier = "SectionHeader"
    var lblTitle = VFTitleLabel(textAlignment: .left, fontSize: 15)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        setTitleStyle()
     
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {
        self.addSubview(lblTitle)
        
        lblTitle.snp.makeConstraints { make in
         //   make.top.equalTo(self).offset(25)
            make.centerX.equalTo(self.snp.centerX)
            make.height.equalTo(28)
        }
    
    }
    
    func setTitleStyle() {
        
        let baseFont = NanumSquareRound.bold.style(sizeOffset: 17.0)
        let subFont = NanumSquareRound.bold.style(sizeOffset: 19.0)
        
        lblTitle.setSubTextColor(basefont: baseFont, subfont: subFont, text: "오늘 먹은 채소 선택하기",
                                 baseColor: ColorHex.milkChocolate, specificColor: ColorHex.pineGreen, location: 6,length: 2)
    }
    

}
