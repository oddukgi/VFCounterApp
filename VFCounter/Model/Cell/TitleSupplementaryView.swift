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
    func showPickUpViewController(type: String)
}

class TitleSupplementaryView: UICollectionReusableView {

    static let reuseIdentifier = "TitleSupplementaryView"

    var lblTitle = VFTitleLabel(textAlignment: .left,
                                font: NanumSquareRound.bold.style(offset: 15))
    var lblSubtitle = VFSubTitleLabel(font: NanumSquareRound.bold.style(offset: 14.4))
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
        let image = UIImage(named: "plus")?.changeTransparentBg()
        button.setImage(image, for: .normal)
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
            make.width.equalTo(145)
        }
        btnPlus.snp.makeConstraints { make in
            make.leading.equalTo(labels.snp.trailing).offset(20)
            make.top.equalTo(self)
            make.size.equalTo(CGSize(width: 35, height: 35))
        }

        lblTitle.textColor = .black
        lblSubtitle.textColor = .lightGray
        btnPlus.setAllSideShadow()
    }

    func updateTitles(title: String) {

        lblTitle.text = title
        lblSubtitle.text = (title == "야채") ? "섭취한 야채를 넣어보세요." : "섭취한 과일을 넣어보세요."
        (title == "야채") ? (btnPlus.tag = 0) : (btnPlus.tag = 1)
        btnPlus.addTarget(self, action: #selector(self.displayItems(sender:)), for: .touchUpInside)
    }

    @objc func displayItems( sender: VFButton) {
        delegate?.showPickUpViewController(type: lblTitle.text!)
        
        // haptic feedback with UIImpactFeedbackGenerator
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
    }

}
