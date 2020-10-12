//
//  TableHeaderView.swift
//  VFCounter
//
//  Created by Sunmi on 2020/08/18.
//  Copyright © 2020 creativeSun. All rights reserved.
//

import UIKit
import SnapKit

class TableHeaderView: UITableViewHeaderFooterView {

    // MARK: - Properties
    static var reuseIdentifier: String {
        return String(describing: self)
    }

    let lbTitle = VFTitleLabel(textAlignment: .left, fontSize: 15)

    // MARK: - Init
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        configure()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Configure

    func configure() {
        contentView.addSubview(lbTitle)
        lbTitle.snp.makeConstraints { make in
            make.edges.equalTo(contentView).inset(UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10))
            make.height.equalTo(40)
        }
    }

    func setTitle(with section: SettingVC.Section) {
        lbTitle.text = section.title
    }
}
