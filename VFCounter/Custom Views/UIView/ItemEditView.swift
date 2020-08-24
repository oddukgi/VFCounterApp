//
//  ItemEditView.swift
//  VFCounter
//
//  Created by Sunmi on 2020/08/23.
//  Copyright © 2020 creativeSun. All rights reserved.
//

// Refer to : https://stackoverflow.com/questions/44098314/ios-add-vertical-line-programatically-inside-a-stack-view

import UIKit

typealias Item = UIImage?

class ItemEditView: UIView {

    let containerView = VFContainerView(frame: CGRect(x: 0, y: 0, width: 80, height: 25))
    
    lazy var horizontalStackView: UIStackView = {
       let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.frame = containerView.bounds
        return stackView
    }()
    
    let items: [Item] = [
        Item(UIImage(named: "edit")!),
        Item(UIImage(named: "delete")!)
    ]
    
    var itemButton = [VFButton]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {
        
        addSubview(containerView)
        containerView.backgroundColor = .white
        containerView.addSubview(horizontalStackView)
        
        items.forEach { item in
            if horizontalStackView.arrangedSubviews.count > 0 {
                let separator = UIView()
                separator.widthAnchor.constraint(equalToConstant: 1).isActive = true
                separator.backgroundColor = .gray
                horizontalStackView.addArrangedSubview(separator)
                separator.heightAnchor.constraint(equalTo: horizontalStackView.heightAnchor, multiplier: 0.6).isActive = true
            }
            
            let button = VFButton(frame: CGRect(x: 0, y: 0, width: 16, height: 16))
            button.setImage(item, for: .normal)
            itemButton.append(button)
            
            
            horizontalStackView.addArrangedSubview(button)
            if let firstButton = horizontalStackView.arrangedSubviews.first as? VFButton {
                button.widthAnchor.constraint(equalTo: firstButton.widthAnchor).isActive = true
            }
        }

    }

}

//        itemButton[0].layer.borderWidth = 1
//        itemButton[1].layer.borderWidth = 1
