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

    lazy var itemImage: UIImageView = {
        let image = UIImage(named: "lettuce")
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    lazy var checkImageView: UIImageView = {
        let image = UIImage(named: "uncheck")
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        return imageView

    }()

    let uncheckImage = UIImage(named: "uncheck")
    let checkImage = UIImage(named: "check")

    let lblName = VFSubTitleLabel(font: NanumSquareRound.bold.style(offset: 13))

    var veggieDict: [String: Any] = [:]

    // Bool property
    var isChecked: Bool = false {
        didSet {
          if isChecked == true {
            checkImageView.image = checkImage?.changeTransparentBg()
          } else {
            checkImageView.image = uncheckImage?.changeTransparentBg()
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
        contentView.addSubViews(itemImage, lblName, checkImageView)

        itemImage.snp.makeConstraints {
            $0.top.equalTo(contentView).offset(4)
            $0.leading.equalTo(contentView).offset(11)
            $0.size.equalTo(CGSize(width: 39, height: 37))
       }

        lblName.snp.makeConstraints {
            $0.centerX.equalTo(contentView.snp.centerX)
            $0.bottom.equalTo(contentView.snp.bottom).offset(-10)
            $0.height.equalTo(20)
        }

        lblName.textAlignment = .center

        checkImageView.snp.makeConstraints {
            $0.top.equalTo(contentView).offset(20)
            $0.trailing.equalTo(contentView).offset(-5)
            $0.size.equalTo(CGSize(width: 20, height: 20))
        }
    }

    // data model 형성
    func set(_ image: UIImage?, _ name: String) {
        itemImage.image = image?.changeTransparentBg()
        lblName.text = name
    }

}
