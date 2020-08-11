//
//  DateView.swift
//  VFCounter
//
//  Created by Sunmi on 2020/07/21.
//  Copyright © 2020 creativeSun. All rights reserved.
//

import UIKit
import SnapKit

class DateView: UIView {

    var btnLeftArrow: VFButton!
    var btnRightArrow: VFButton!
    var horizontalView: [UIStackView] = []
    let dateLabel = VFTitleLabel(textAlignment: .center, fontSize: 16)
    let weatherLabel = VFSubTitleLabel(fontSize: 13)
    let commentLabel = VFBodyLabel(textAlignment: .left, fontSize: 13, fontColor: ColorHex.dullOrange)
    
    lazy var locationIcon: UIImageView = {
    
        let image = UIImage(named: "smilingsun")?.imageByMakingWhiteBackgroundTransparent()
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    lazy var btnLocation: VFButton = {
        let button = VFButton()
        button.addImage(imageName: "location")
        return button
    }()
    
    lazy var commentIcon: UIImageView = {
        let image = UIImage(named: "strawberry")?.imageByMakingWhiteBackgroundTransparent()
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureStackView()
        setLayout()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initialize() {
        
        let dateconverter = DateConverter(date: Date())
        dateLabel.text = dateconverter.convertDate()
        dateLabel.textColor = UIColor.black
        weatherLabel.text = "27도"
        commentLabel.numberOfLines = 0
        commentLabel.text = """
                            좋은 아침!
                            사과를 섭취하면, 몸이 활력이 생겨요
                            """
    }

}
