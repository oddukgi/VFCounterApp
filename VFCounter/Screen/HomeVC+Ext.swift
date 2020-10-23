//
//  HomeVC+Constraint.swift
//  VFCounter
//
//  Created by Sunmi on 2020/07/21.
//  Copyright © 2020 creativeSun. All rights reserved.
//

import UIKit
import SnapKit

extension HomeVC {

    // MARK: Constraint

    func setupConstraints() {

        headerView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(10)
            make.width.equalToSuperview()
            make.height.equalTo(SizeManager().getHeaderviewHeight)
            make.leading.equalToSuperview()
        }

        headerView.addSubview(dateView)
        dateView.snp.makeConstraints { make in
            make.leading.trailing.equalTo(view)
            make.height.equalTo(headerView.snp.height)
        }

//        headerView.layer.borderWidth = 1
//        dateView.layer.borderWidth = 1
    }

    func add(childVC: UIViewController, to containerView: UIView) {
        addChild(childVC)
        containerView.addSubview(childVC.view)
        childVC.view.frame = containerView.bounds
        childVC.didMove(toParent: self)
    }

    /// contentView is showing the number of veggies or fruits
    func setContentView() {
        view.addSubview(contentView)

        contentView.snp.makeConstraints { make in
            make.top.equalTo(headerView.snp.bottom)
            make.width.equalTo(view.snp.width)
            make.bottom.equalTo(view.snp.bottom)
        }

        contentView.addSubview(userItemView)
        var newDate = dateView.dateLabel.text
        newDate?.removeLast(2)

        userItemView.snp.makeConstraints { make in
            make.edges.equalTo(contentView).inset(UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
       }
        self.add(childVC: UserItemVC(delegate: self, date: newDate!), to: self.userItemView)
    }

}
