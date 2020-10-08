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

    let containerView = VFContainerView(frame: CGRect(x: 0, y: 0, width: 80, height: 28))
    
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
    // Create a property to store the hit insets:
    var addedTouchArea = CGFloat(0)
    
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

        containerView.layer.borderColor = ColorHex.darkGreen.cgColor
        containerView.layer.borderWidth = 0.5
        
        items.forEach { item in
            if horizontalStackView.arrangedSubviews.count > 0 {
                let separator = UIView()
                separator.widthAnchor.constraint(equalToConstant: 1).isActive = true
                separator.backgroundColor = .gray
                horizontalStackView.addArrangedSubview(separator)
                separator.heightAnchor.constraint(equalTo: horizontalStackView.heightAnchor,
                                                  multiplier: 0.6).isActive = true
            }
            
            let button = VFButton(frame: CGRect(x: 0, y: 0, width: 13, height: 13))
            button.setImage(item, for: .normal)
            itemButton.append(button)
            
            horizontalStackView.addArrangedSubview(button)
            if let firstButton = horizontalStackView.arrangedSubviews.first as? VFButton {
                button.widthAnchor.constraint(equalTo: firstButton.widthAnchor).isActive = true
            }
        }

    }
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {

        // Generate the new hit area by adding the hitInsets:
        let newBound = CGRect(
            x: self.bounds.origin.x - addedTouchArea,
            y: self.bounds.origin.y - addedTouchArea,
            width: self.bounds.width + 2 * addedTouchArea,
            height: self.bounds.width + 2 * addedTouchArea
        )
        // Check if the point is within the new hit area:
        return newBound.contains(point)

    }

}
