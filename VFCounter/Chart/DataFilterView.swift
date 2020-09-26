//
//  MainFilterView.swift
//  MovieFinder
//
//  Created by Yosif Iliev on 29.08.19.
//  Copyright © 2019 Yosif Iliev. All rights reserved.
//

import UIKit


class DataFilterView: UIStackView {

    var dataBtn: UIButton!
    var listBtn: UIButton!
    var searchField: UITextField!

    private var secondFilterRow: UIView!

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init(coder: NSCoder) {
        super.init(coder: coder)
    }


    func selectSection(section: DataFilter) {

        switch section {
        case .data:
            dataBtn.setTitleColor(UIColor.white, for: .normal)
            dataBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
            dataBtn.backgroundColor = SegmentColor.primary
            listBtn.setTitleColor(UIColor.darkGray, for: .normal)
            listBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .light)
            listBtn.backgroundColor = .clear

        case .list:
            dataBtn.setTitleColor(UIColor.darkGray, for: .normal)
            dataBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .light)
            dataBtn.backgroundColor = .clear
            listBtn.setTitleColor(UIColor.white, for: .normal)
            listBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
            listBtn.backgroundColor = SegmentColor.primary
        }
    }
}

extension DataFilterView {

    private func setupViews() {
        axis = .vertical
        distribution = .equalSpacing
        spacing = 0
        setupSectionView()

    }

    private func setupSectionView() {

        let background = UIView(frame: .zero)
        background.translatesAutoresizingMaskIntoConstraints = false
        background.layer.cornerRadius = 19
        addArrangedSubview(background)

        dataBtn = createSectionBtn(title: "데이터".localized)
        dataBtn.tag = 0
        dataBtn.backgroundColor = SegmentColor.tertiery
        dataBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        background.addSubview(dataBtn)

        listBtn = createSectionBtn(title: "내역".localized)
        listBtn.tag = 1
        background.addSubview(listBtn)
        NSLayoutConstraint.activate([
            
            background.widthAnchor.constraint(equalToConstant: 200),
            background.heightAnchor.constraint(equalToConstant: 38),

            dataBtn.widthAnchor.constraint(equalTo: background.widthAnchor, multiplier: 1 / 2),
            dataBtn.leftAnchor.constraint(equalTo: background.leftAnchor, constant: 1),
            dataBtn.safeTopAnchor.constraint(equalTo: background.topAnchor, constant: 1),
            dataBtn.heightAnchor.constraint(equalToConstant: 36),

            listBtn.widthAnchor.constraint(equalTo: background.widthAnchor, multiplier: 1 / 2),
            listBtn.rightAnchor.constraint(equalTo: background.rightAnchor, constant: -1),
            listBtn.safeTopAnchor.constraint(equalTo: background.topAnchor, constant: 1),
            listBtn.heightAnchor.constraint(equalToConstant: 36)

         ])
    }

    private func createSectionBtn(title: String) -> UIButton {

        let btn = UIButton(type: .custom)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.layer.cornerRadius = 18
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .light)
        btn.backgroundColor = .clear
        btn.setTitle(title, for: .normal)
        return btn
    }
}
