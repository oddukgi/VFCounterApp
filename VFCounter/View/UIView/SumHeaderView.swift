//
//  SumHeaderView.swift
//  VFCounter
//
//  Created by Sunmi on 2020/10/19.
//  Copyright © 2020 creativeSun. All rights reserved.
//

import UIKit

class SumHeaderView: UIView {

    let lblDate = VFBodyLabel(textAlignment: .left,
                              font: NanumSquareRound.bold.style(offset: 15), fontColor: ColorHex.darkGreen)
    
    let lblSum = VFBodyLabel(textAlignment: .left,
                             font: NanumSquareRound.bold.style(offset: 15), fontColor: ColorHex.MilkChocolate.alpha60)
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.spacing = 10
        stackView.alignment = .center
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure() {
        addSubview(stackView)
        
        stackView.addArrangedSubview(lblDate)
        stackView.addArrangedSubview(lblSum)
        
        stackView.snp.makeConstraints { (maker) in
            maker.top.equalTo(self)
            maker.leading.trailing.equalTo(self)
            maker.height.equalTo(44)
        }
        
        lblDate.snp.makeConstraints { (maker) in
            maker.height.equalTo(44)
        }
        
        lblSum.snp.makeConstraints { (maker) in
            maker.width.equalTo(98).priority(.high)
            maker.height.equalTo(44)
        }
 
    }
    
    func updateHeader(date: String, sumV: Int, sunF: Int) {
        lblDate.text = date
        lblSum.text = "아채:\(sumV)g , 과일: \(sunF)g"
    }
}
