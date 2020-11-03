//
//  ItemCell.swift
//  VFCounter
//
//  Created by Sunmi on 2020/10/27.
//  Copyright © 2020 creativeSun. All rights reserved.
//

import UIKit

class ItemCell: UICollectionViewCell {
    
    // MARK: Internal
    
    static let reuseIdentifier: String = NSStringFromClass(ItemCell.self)
    let imageView    = UIImageView()
    let lblTime      =  VFSubTitleLabel(font: NanumSquareRound.regular.style(offset: 11))
    let lblName      =  VFSubTitleLabel(font: NanumSquareRound.bold.style(offset: 13))
    let lblAmount    =  VFSubTitleLabel(font: NanumSquareRound.regular.style(offset: 11))
//    weak var delegate: ItemCellDelegate?
    private var date     = ""
    private var section = 0
    weak var delegate: TitleSupplmentaryViewDelegate?
    private var updateHandler: (() -> Void)?
    
    // Bool property
    var type: String {
        
        var newType = ""
        (section == 0) ? (newType = "야채") : (newType = "과일")
        return newType
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setLayout() {
        contentView.addSubViews(imageView, lblTime, lblName, lblAmount)

        imageView.contentMode = .scaleAspectFit
        
        let imgSize = SizeManager().itemImgSize()
        imageView.snp.makeConstraints { make in
            make.top.equalTo(contentView).offset(3)
            make.centerX.equalTo(contentView.snp.centerX)
            make.size.equalTo(imgSize)
        }

        lblTime.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(5)
            make.centerX.equalTo(contentView.snp.centerX)
            make.height.equalTo(10.2)
        }
        lblName.snp.makeConstraints { make in
            make.top.equalTo(lblTime.snp.bottom).offset(3)
            make.centerX.equalTo(contentView.snp.centerX)
            make.height.equalTo(14.2)
        }

        lblAmount.snp.makeConstraints { make in
            make.top.equalTo(lblName.snp.bottom).offset(0.2)
            make.centerX.equalTo(contentView.snp.centerX)
            make.width.equalTo(50)
            make.height.equalTo(18)
        }

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

    func setDataField(_ field: Category, updateHandler: (() -> Void)? = nil) {
        
        guard let image = field.image else { return }
        imageView.image = UIImage(data: image)?.changeTransparentBg()
        lblName.text = field.name
        
        let time = field.createdDate?.changeDateTime(format: .time)
        // let time = date.trimmingTime(start: 0, end: -11).trimmingTime(start: 5, end: -3)
        lblTime.text = time
        lblAmount.text = "\(field.amount)g"
        self.updateHandler = updateHandler
    }
    // modify and delete methods work in UserItemVC
    
    func modifyEntity(parentVC: UserItemVC, indexPath: IndexPath) {
        section = indexPath.section
        
        let strDate = parentVC.itemSetting.stringDate
        let entityDT = parentVC.mainListModel.dm?
            .getCreatedDate(index: indexPath.item, type: type, date: strDate)
        
        let img = self.imageView.image
        var strAmount = self.lblAmount.text!
        strAmount.removeLast()
        let amount = Int(strAmount) ?? 0
        var item = Items(name: self.lblName.text!, date: strDate,
                        image: img, amount: amount, entityDT: entityDT, type: self.type)
        parentVC.updateSelectedItem(item: item)
    
    }
    
    func deleteEntity(parentVC: UserItemVC, indexPath: IndexPath) {
        section = indexPath.section
        let strDate = parentVC.itemSetting.stringDate
        if let entityDT = parentVC.mainListModel.dm?.getCreatedDate(index: indexPath.item,
                                                                    type: type, date: strDate) {

            parentVC.mainListModel.dm?.deleteEntity(createdDate: entityDT, type: self.type)
        }
        
    }
}
