//
//  CustomSegmentedControl.swift
//  VFCounter
//
//  Created by Sunmi on 2020/10/03.
//  Copyright © 2020 creativeSun. All rights reserved.
//

import UIKit

/// CustomSegmentControl
/// refer to : https://github.com/Code-With-Coffee/CustomSegmentedControl

protocol CustomSegmentedControlDelegate: class {
    func valueChangedPeriod(to index: Int)
    func valueChangedData(to index: Int)
}

class CustomSegmentedControl: UIView {

    enum ResourceKind: CaseIterable {

        case timeSection, dataSection

        var title: String {
            switch self {
            case .timeSection:
                return "Time"
            default:
                return "Data"
            }
        }
    }

    private var buttonTitles = [String]()
    private var buttons = [UIButton]()
    private var selectorView: UIView!

    var textColor: UIColor = .black
    var selectorViewColor: UIColor = .red
    var selectorTextColor: UIColor = .red
    var font: UIFont!

    weak var delegate: CustomSegmentedControlDelegate?
    var resourceType: ResourceKind = .timeSection

    public private(set) var selectedIndex: Int = 0

    @IBInspectable var titleFont: UIFont = .systemFont(ofSize: 13) {
         didSet {
            buttons.forEach({ $0.titleLabel?.font = titleFont })
         }
    }

    convenience init(frame: CGRect, buttonTitle: [String]) {
        self.init(frame: frame)
        self.buttonTitles = buttonTitle

    }

    override func draw(_ rect: CGRect) {
          super.draw(rect)
          self.backgroundColor = UIColor.white
        
        let periodIndex = SettingManager.getPeriodSegment(keyName: "PeriodSegment")
        let dataIndex = SettingManager.getDataSegment(keyName: "DataSegment")
        
        if periodIndex == dataIndex {
          updateView()
        }
      }
    
    func setButtonTitles(buttonTitles: [String]) {
        self.buttonTitles = buttonTitles
        
        self.updateView()
    }

    func setIndex(index: Int) {
        buttons.forEach({ $0.setTitleColor(textColor, for: .normal)})
        let button = buttons[index]
        selectedIndex = index
        button.setTitleColor(selectorTextColor, for: .normal)
        let selectorPosition = frame.width / CGFloat(buttonTitles.count) * CGFloat(index)
        UIView.animate(withDuration: 0.2) {
            self.selectorView.frame.origin.x = selectorPosition
        }
        
        if resourceType == .timeSection {
            SettingManager.setPeriodSegment(index: selectedIndex)
            delegate?.valueChangedPeriod(to: selectedIndex)
        } else {
            SettingManager.setDataSegment(index: selectedIndex)
            delegate?.valueChangedData(to: selectedIndex)
        }
        
    }
    
    @objc func buttonAction(sender: UIButton) {

        for (buttonIndex, btn) in buttons.enumerated() {
            btn.setTitleColor(textColor, for: .normal)
            if btn == sender {
                let selectorPosition = frame.width / CGFloat(buttonTitles.count) * CGFloat(buttonIndex)
                selectedIndex = buttonIndex

                if resourceType == .timeSection {
                  
                    SettingManager.setPeriodSegment(index: selectedIndex)
                    delegate?.valueChangedPeriod(to: selectedIndex)
                } else {
                    SettingManager.setDataSegment(index: selectedIndex)
                    delegate?.valueChangedData(to: selectedIndex)
                }

                UIView.animate(withDuration: 0.2) {
                    self.selectorView.frame.origin.x = selectorPosition
                }
                
                btn.setTitleColor(selectorTextColor, for: .normal)
            }
        }
    }
}

// Configuration View

extension CustomSegmentedControl {
    private func updateView() {
        createButton()
        configSelectorView()
        configStackView()
    }

    private func configStackView() {
        let stackView = UIStackView(arrangedSubviews: buttons)
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        addSubview(stackView)
        stackView.snp.makeConstraints { (make) in
            make.edges.equalTo(self).inset(UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
        }

    }
    private func configSelectorView() {
        let selectorWidth = frame.width / CGFloat(self.buttonTitles.count)
        selectorView = UIView(frame: CGRect(x: 0, y: self.frame.height,
                                            width: selectorWidth, height: 2))
        selectorView.backgroundColor = selectorViewColor
        addSubview(selectorView)
    }

    private func createButton() {
        buttons = [UIButton]()
        buttons.removeAll()
        subviews.forEach({ $0.removeFromSuperview() })

        for buttonTitle in buttonTitles {
            let button = UIButton(type: .system)
            button.setTitle(buttonTitle, for: .normal)
            button.addTarget(self, action: #selector(buttonAction(sender:)), for: .touchUpInside)
            button.setTitleColor(textColor, for: .normal)
            button.tag = tag
            buttons.append(button)

        }

        buttons[0].setTitleColor(selectorTextColor, for: .normal)
    }
}
