//
//  VFItemCell.swift
//  VFCounter
//
//  Created by Sunmi on 2020/07/24.
//  Copyright © 2020 creativeSun. All rights reserved.
//

import UIKit
import SnapKit


protocol VFItemCellDelegate: class {
    func updateSelectedItem(item: VFItemController.Items, index: Int)
}

class VFItemCell: UICollectionViewCell {
 
    static let reuseIdentifier = "VFItemCell"
    let imageView    = UIImageView()
    let lblTime      =  VFSubTitleLabel()
    let lblName      =  VFSubTitleLabel()
    let lblAmount    =  VFSubTitleLabel()
    let itemEditView = ItemEditView()
    var date: Date?
    weak var delegate: VFItemCellDelegate?
    
    // Bool property
    var selectedItem: Bool = false {
        didSet{
          if selectedItem == true {
            itemEditView.isHidden = false
          } else {
            itemEditView.isHidden = true
          }
       }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setLayout()
        showItemEditView()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setLayout() {
        contentView.addSubViews(imageView,lblTime,lblName,lblAmount)
        
        imageView.contentMode = .scaleAspectFit
        imageView.snp.makeConstraints { make in
            make.top.equalTo(contentView).offset(3)
            make.centerX.equalTo(contentView.snp.centerX)
            make.size.equalTo(CGSize(width: 39, height: 37))
        }
    
        lblTime.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(3)
            make.centerX.equalTo(contentView.snp.centerX)
            make.height.equalTo(10.2)
        }
        lblName.snp.makeConstraints { make in
            make.top.equalTo(lblTime.snp.bottom).offset(3)
            make.centerX.equalTo(contentView.snp.centerX)
            make.height.equalTo(14.2)
        }
        
        lblAmount.snp.makeConstraints { make in
           make.top.equalTo(lblName.snp.bottom).offset(1.2)
           make.centerX.equalTo(contentView.snp.centerX)
           make.width.equalTo(50)
           make.height.equalTo(18)
        }
        
        lblTime.font = NanumSquareRound.regular.style(sizeOffset: 11)
        lblName.font = NanumSquareRound.bold.style(sizeOffset: 13)
        lblAmount.font = NanumSquareRound.regular.style(sizeOffset: 12)
        
        lblTime.textColor = .black
        lblName.textColor = ColorHex.MilkChocolate.origin
        lblAmount.textColor = ColorHex.darkGreen
        
        lblAmount.layer.cornerRadius = 8
        lblAmount.clipsToBounds = true
        lblAmount.backgroundColor = ColorHex.iceBlue
        
        lblTime.textAlignment = .center
        lblName.textAlignment = .center
        lblAmount.textAlignment = .center
       
    }
    
    func showItemEditView() {
        contentView.addSubview(itemEditView)
        itemEditView.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.top).offset(25)
            make.centerX.equalTo(contentView.snp.centerX).offset(-40)
        }
        connectedTarget()
     }

    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {

        guard isUserInteractionEnabled else { return nil }
        guard !isHidden else { return nil }
        guard alpha >= 0.01 else { return nil }

        guard self.point(inside: point, with: event) else { return nil }


        // add one of these blocks for each button in our collection view cell we want to actually work
        if  !self.itemEditView.isHidden && self.itemEditView.itemButton[0].point(inside: convert(point, to: itemEditView.itemButton[0]), with: event) {
           return self.itemEditView.itemButton[0]
        }
        if !self.itemEditView.isHidden && self.itemEditView.itemButton[1].point(inside: convert(point, to: itemEditView.itemButton[1]), with: event) {
           	return self.itemEditView.itemButton[1]
        }

        return super.hitTest(point, with: event)
    }
    

    func updateContents(image: UIImage?, name: String, amount: Int, date: String) {
        imageView.image = image
    
        let time = date.trimmingTime(start: 0, end: -11).trimmingTime(start: 5, end: -3)
        lblTime.text = time
        lblName.text = name
        lblAmount.text = "\(amount)g"
    }
    
  
    func connectedTarget() {
        itemEditView.itemButton[0].addTarget(self, action: #selector(modifyItem(_:)), for: .touchUpInside)
        itemEditView.itemButton[1].addTarget(self, action: #selector(deleteItem(_:)), for: .touchUpInside)
    }

    @objc func modifyItem(_ sender: VFButton) {
        print("tapped modify item")
        
//        let newDate = date.changeDate()    
//        let item = VFItemController.Items(name: lblTime.text, time: lblName.text, date: <#T##Date#>(), image: <#T##UIImage?#>, amount: <#T##Int#>)
//        delegate?.updateSelectedItem(item: <#T##VFItemController.Items#>, index: <#T##Int#>)
    }
    
    @objc func deleteItem(_ sender: VFButton) {
        print("tapped delete item")
    }
}

