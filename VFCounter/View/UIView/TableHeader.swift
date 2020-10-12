//
//  TableHeader.swift
//  VFCounter
//
//  Created by Sunmi on 2020/10/09.
//  Copyright © 2020 creativeSun. All rights reserved.
//

import UIKit

class TableHeader: UIView {

    var lblTitle = VFTitleLabel(textAlignment: .left, fontSize: 16)

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure() {
        self.addSubview(lblTitle)
        lblTitle.snp.makeConstraints { (make) in
            make.edges.equalTo(self).inset(UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5))
            make.height.equalTo(45)
        }

        if #available(iOS 10.0, *) {
            lblTitle.adjustsFontForContentSizeCategory = true
        } else {

            NotificationCenter.default.addObserver(self, selector: #selector(contentSizeDidChange(_:)), name: UIContentSizeCategory.didChangeNotification, object: nil)
        }

    }

    @objc func contentSizeDidChange(_ notification: NSNotification) {
        lblTitle.font = UIFont.preferredFont(forTextStyle: .title3)
    }
}
