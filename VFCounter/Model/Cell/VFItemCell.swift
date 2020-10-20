//
//  VFItemCell.swift
//  VFCounter
//
//  Created by Sunmi on 2020/07/24.
//  Copyright © 2020 creativeSun. All rights reserved.
//

import UIKit
import SnapKit

// protocol : UserItemVC called --> VFItemCell

protocol ItemCellDelegate: class {
    func updateSelectedItem(item: VFItemController.Items, index: Int)
    func presentSelectedAlertVC(indexPath: IndexPath, selectedDate: String)
}

class VFItemCell: UICollectionViewCell {

    static let reuseIdentifier = "VFItemCell"
    let imageView    = UIImageView()
    let lblTime      =  VFSubTitleLabel(font: NanumSquareRound.regular.style(offset: 11))
    let lblName      =  VFSubTitleLabel(font: NanumSquareRound.bold.style(offset: 13))
    let lblAmount    =  VFSubTitleLabel(font: NanumSquareRound.regular.style(offset: 11))
    weak var delegate: ItemCellDelegate?
    
    private var date     = ""
    private var section = 0
    private let dataManager = DataManager()
    
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
        imageView.snp.makeConstraints { make in
            make.top.equalTo(contentView).offset(3)
            make.centerX.equalTo(contentView.snp.centerX)
            make.size.equalTo(CGSize(width: 39, height: 37))
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
           make.top.equalTo(lblName.snp.bottom).offset(1.2)
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

    func updateContents(image: UIImage?, name: String, amount: Int, date: String) {
        imageView.image = image?.changeTransparentBg()

        self.date = String(date.split(separator: " ").first!)
        let time = date.trimmingTime(start: 0, end: -11).trimmingTime(start: 5, end: -3)
        lblTime.text = time
        lblName.text = name
        lblAmount.text = "\(amount)g"
    }

    func modifyItem(for row: Int, itemdate: String = "") {
        
        var datatype: DataType.Type!
        var item: VFItemController.Items?
        let name     = self.lblName.text!
        let image    = self.imageView.image!
        let amount   = String(self.lblAmount.text!.dropLast())
        
        var itemDate =  (itemdate.count > 0) ? itemdate : date
        
        section = name.retrieveKind()
        section == 0 ? (datatype = Veggies.self) : (datatype = Fruits.self)
        dataManager.fetchedDate(tag: section, index: row, datatype, newDate: itemDate) { (result) in
           item = VFItemController.Items(name: name, date: self.date,
                                         image: image, amount: Int(amount) ?? 0, entityDT: result)
        }

        if let unwrappedItem = item {
            self.delegate?.updateSelectedItem(item: unwrappedItem, index: self.section)
        }
    }

    func deleteItem(indexPath: IndexPath) {
        delegate?.presentSelectedAlertVC(indexPath: indexPath, selectedDate: "")
    }
}
