//
//  SectionHeader.swift
//  VFCounter
//
//  Created by Sunmi on 2020/07/28.
//  Copyright © 2020 creativeSun. All rights reserved.
//

import UIKit

class SectionHeader: UICollectionReusableView, SelfConfigCell {
  
    static let reuseIdentifier = "title-supplementary-reuse-identifier"
    var lblTitle = VFTitleLabel(textAlignment: .left, fontSize: 15)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()

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
        lblTitle.textColor = ColorHex.MilkChocolate.origin
    }
    

}
