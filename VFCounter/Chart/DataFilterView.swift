//
//  MainFilterView.swift
//  MovieFinder
//
//  Created by Yosif Iliev on 29.08.19.
//  Copyright © 2019 Yosif Iliev. All rights reserved.
//

import UIKit


class DataFilterView: UIView {

    var dataSegmentControl: CustomSegmentedControl!
    var searchField: UITextField!
    let background = UIView()
    private var secondFilterRow: UIView!
    

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    func configure() {
        self.addSubview(background)

        background.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
  
        let defaultFont = NanumSquareRound.bold.style(sizeOffset: 13)
        dataSegmentControl = CustomSegmentedControl()
        dataSegmentControl.setButtonTitles(buttonTitles: ["Data","List"])
        dataSegmentControl.selectorViewColor = ColorHex.orangeyRed
        dataSegmentControl.selectorTextColor = ColorHex.orangeyRed
        dataSegmentControl.titleFont = defaultFont
        dataSegmentControl.resourceType = .dataSection
      
        background.addSubview(dataSegmentControl)

        dataSegmentControl.snp.makeConstraints { make in
            make.edges.size.equalTo(background)
        }
    }
}

