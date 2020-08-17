//
//  PickItemCell.swift
//  VFCounter
//
//  Created by Sunmi on 2020/07/27.
//  Copyright © 2020 creativeSun. All rights reserved.
//

import UIKit


// chechbox 버튼을 눌렀을 때 적용

class PickItemCell: UICollectionViewCell {
    
    static let reuseIdentifier = "PickItemCell"
   
    lazy var veggieImage: UIImageView = {
        let image = UIImage(named: "lettuce")?.imageByMakingWhiteBackgroundTransparent()
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    lazy var checkImageView: UIImageView = {
        let image = UIImage(named: "uncheck")?.imageByMakingWhiteBackgroundTransparent()
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        return imageView
        
    }()
    
    let uncheckImage = UIImage(named: "uncheck")?.imageByMakingWhiteBackgroundTransparent()
    let checkImage = UIImage(named: "check")?.imageByMakingWhiteBackgroundTransparent()
    
    let lblName = VFSubTitleLabel(fontSize: 14)
    
    let amountLabel = VFBodyLabel()
    var veggieDict: [String: Any] = [:]
    
    // Bool property
    var isChecked: Bool = false {
        didSet{
          if isChecked == true {
            checkImageView.image = checkImage
          } else {
            checkImageView.image = uncheckImage
          }
       }
    }
    

    override init(frame: CGRect) {
        super.init(frame: frame)
        setLayout()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setLayout() {
        contentView.addSubViews(veggieImage, lblName, checkImageView)
        
        veggieImage.snp.makeConstraints {
            $0.top.equalTo(contentView).offset(4)
            $0.leading.equalTo(contentView).offset(11)
            $0.size.equalTo(CGSize(width: 53, height: 57.8))
       }
        
        lblName.snp.makeConstraints {
            $0.leading.equalTo(contentView).offset(11)
            $0.bottom.equalTo(contentView.snp.bottom).offset(-10)
            $0.height.equalTo(20)
        }
        
        checkImageView.snp.makeConstraints {
            $0.top.equalTo(contentView).offset(20)
            $0.trailing.equalTo(contentView).offset(-5)
            $0.size.equalTo(CGSize(width: 31, height: 31))
        }
    }
    
    // data model 형성
    func set(_ image: UIImage?,_ name: String) {
        veggieImage.image = image?.imageByMakingWhiteBackgroundTransparent()
        lblName.text = name
    }
    
}

