//
//  VFContainerView.swift
//  GHFollowers
//
//  Created by Sunmi on 2020/06/30.
//  Copyright © 2020 CreativeSuns. All rights reserved.
//

import UIKit

class VFContainerView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")        
    }
    
    private func configure() {
        backgroundColor      = .systemBackground
        layer.cornerRadius   = 10
        layer.borderWidth    = 2
        layer.borderColor    = UIColor.white.cgColor
    }
}
