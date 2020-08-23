//
//  VFItemCell.swift
//  VFCounter
//
//  Created by Sunmi on 2020/07/24.
//  Copyright © 2020 creativeSun. All rights reserved.
//

import UIKit
import SnapKit

class VFItemCell: UICollectionViewCell {
 
    static let reuseIdentifier = "VFItemCell"
    let imageView   = UIImageView()
    let lblTime     =  VFSubTitleLabel()
    let lblName     =  VFSubTitleLabel()
    let lblAmount    =  VFSubTitleLabel()
    var itemEditView: ItemEditView!
    
    // Bool property
    var selectedItem: Bool = false {
        didSet{
          if selectedItem == true {
            showItemEditView()
          } else {
            hideItemEditView()
          }
       }
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setLayout()    
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
        itemEditView = ItemEditView()
        contentView.addSubview(itemEditView)
        itemEditView.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.top).offset(-7)
            make.centerX.equalTo(contentView.snp.centerX)
        }
     }
    
    func hideItemEditView() {
        
        DispatchQueue.main.async {
            if self.itemEditView != nil {
                self.itemEditView.removeFromSuperview()
                self.itemEditView = nil
            }
        }

    }
    
    func updateContents(image: UIImage?, time: String, name: String, amount: Int, date: String) {
        imageView.image = image
        lblTime.text = time
        lblName.text = name
        lblAmount.text = "\(amount)g"
       
    }
    
    
    

}

