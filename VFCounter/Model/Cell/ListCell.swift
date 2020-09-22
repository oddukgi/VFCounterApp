//
//  ListCell.swift
//  VFCounter
//
//  Created by Sunmi on 2020/09/18.
//  Copyright © 2020 creativeSun. All rights reserved.
//

import UIKit

class ListCell: UICollectionViewCell, SelfConfigCell {
    static let reuseIdentifier: String = "ListCell"
    
    let lblTime      = VFSubTitleLabel()
    let imageView    = UIImageView()
    let lblName      = VFSubTitleLabel()
    let lblAmount    = VFSubTitleLabel()
//    let itemEditView = ItemEditView()
    private var date = ""
    weak var delegate: ItemCellDelegate?
    private let dataManager = DataManager()
    private var row = 0
    private var section = 0
    

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setLayout()
        setStyle()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        layer.cornerRadius = 10
        layer.borderWidth = 1
        layer.borderColor = ColorHex.lightlightGrey.cgColor
    }

    private func setLayout() {
        contentView.addSubViews(imageView, lblTime, lblName, lblAmount)
        
        imageView.contentMode = .scaleAspectFit
        imageView.snp.makeConstraints { make in
            make.top.equalTo(contentView).offset(3)
            make.centerX.equalTo(contentView.snp.centerX)
            make.size.equalTo(CGSize(width: 28, height: 29))
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
            make.size.equalTo(CGSize(width: 50, height: 18))
        }
        
    }
    
    private func setStyle() {
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
    
    
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
         super.apply(layoutAttributes)
         self.layer.zPosition = CGFloat(layoutAttributes.zIndex)
    }
    


    func updateContents(image: UIImage?, name: String, amount: Int, date: String) {
        
        imageView.image = image
        
        self.date = String(date.split(separator: " ").first!)
        let time = date.trimmingTime(start: 0, end: -11).trimmingTime(start: 5, end: -3)
        lblTime.text = time
        lblName.text = name
        lblAmount.text = "\(amount)g"
    }
    
    func selectedIndexPath(_ indexPath: IndexPath) {

        row = indexPath.row
        section = indexPath.section
    }

    // MARK: - Edit Item
    @objc func modifyItem(_ sender: VFButton) {
        print("tapped modify item")

        var datatype: DataType.Type!
        section == 0 ? (datatype = Veggies.self) : (datatype = Fruits.self)
        dataManager.getData(tag: section, index: row, datatype, newDate: date) { (result) in

            let name     = self.lblName.text!
            let image    = self.imageView.image!
            let amount   = String(self.lblAmount.text!.dropLast())

            let item = VFItemController.Items(name: name, date: "", image: image, amount: Int(amount) ?? 0, entityDT: result)
            self.delegate?.updateSelectedItem(item: item, index: self.section)
        }
    
    }
    
    @objc func deleteItem(_ sender: VFButton) {
        delegate?.deleteSelectedItem(item: row, section: section)
    }
    
}
