//
//  TitleSupplementaryView.swift
//  VFCounter
//
//  Created by Sunmi on 2020/07/24.
//  Copyright © 2020 creativeSun. All rights reserved.
//

import UIKit
import SnapKit


protocol TitleSupplmentaryViewDelegate: class {
    func showPickUpViewController(tag: Int)
}

class TitleSupplementaryView: UICollectionReusableView {
    
    static let reuseIdentifier = "TitleSupplementaryView"
    
    var lblTitle = VFTitleLabel(textAlignment: .left, fontSize: 14)
    var lblSubtitle = VFSubTitleLabel(fontSize: 13)
    weak var delegate: TitleSupplmentaryViewDelegate?
    
    lazy var labels: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [lblTitle, lblSubtitle])
        stackView.alignment = .center
        stackView.spacing = 8
        stackView.axis = .horizontal
        stackView.distribution = .fillProportionally
        
        self.addSubview(stackView)
        return stackView
    }()
    
    lazy var btnPlus: VFButton = {
        let button = VFButton()
        button.addImage(imageName: "plus")
        self.addSubview(button)
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {
        
        labels.snp.makeConstraints { make in
            make.top.equalTo(self).offset(0)
            make.leading.equalTo(5)
            make.height.equalTo(30)
        }
        
        
        lblTitle.snp.makeConstraints { make in
            make.width.equalTo(30)
        }
        lblSubtitle.snp.makeConstraints { make in
            make.width.equalTo(180)
        }
        btnPlus.snp.makeConstraints { make in
            make.leading.equalTo(labels.snp.trailing).offset(23)
            make.top.equalTo(self)
            make.size.equalTo(CGSize(width: 33, height: 33))
        }
        
        lblTitle.textColor = .black
        lblSubtitle.textColor = .lightGray
        btnPlus.setAllSideShadow()
        
    }
    
    func updateTitles(title: String, subtitle: String) {
 
        lblTitle.text = title
        lblSubtitle.text = subtitle
        (title == "야채") ? (btnPlus.tag = 0) : (btnPlus.tag = 1)
        btnPlus.addTarget(self, action: #selector(self.displayItems(sender:)), for: .touchUpInside)
    }
    
    @objc func displayItems( sender: VFButton) {
        delegate?.showPickUpViewController(tag: sender.tag)
    }
    
}

