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
    let itemEditView = ItemEditView()
    private var date = ""
    weak var delegate: ItemCellDelegate?
    private let dataManager = DataManager()
    private var row = 0
    private var section = 0
    
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
        contentView.addSubViews(imageView, lblTime, lblName, lblAmount)
        
        imageView.contentMode = .scaleAspectFit
        imageView.snp.makeConstraints { make in
            make.top.equalTo(contentView).offset(3)
            make.centerX.equalTo(contentView.snp.centerX)
            make.size.equalTo(CGSize(width: 28, height: 29))
        }
        
        lblTime.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(3)
            make.leading.equalTo(contentView.snp.leading).offset(3)
            make.size.equalTo(CGSize(width: 38, height: 27))
        }
        lblName.snp.makeConstraints { make in
            make.top.equalTo(lblTime.snp.bottom).offset(3)
            make.centerX.equalTo(contentView.snp.centerX)
            make.height.equalTo(1)
        }
        
        lblAmount.snp.makeConstraints { make in
            make.top.equalTo(lblName.snp.bottom).offset(1.2)
            make.centerX.equalTo(contentView.snp.centerX)
            make.size.equalTo(CGSize(width: 50, height: 18))
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

    
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
         super.apply(layoutAttributes)
         self.layer.zPosition = CGFloat(layoutAttributes.zIndex)
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
        
        self.date = String(date.split(separator: " ").first!)
        let time = date.trimmingTime(start: 0, end: -11).trimmingTime(start: 5, end: -3)
        lblTime.text = time
        lblName.text = name
        lblAmount.text = "\(amount)g"
    }
    
    func connectedTarget() {
        itemEditView.itemButton[0].addTarget(self, action: #selector(modifyItem(_:)), for: .touchUpInside)
        itemEditView.itemButton[1].addTarget(self, action: #selector(deleteItem(_:)), for: .touchUpInside)
    }
    
    func selectedIndexPath(_ indexPath: IndexPath) {

        row = indexPath.row
        section = indexPath.section
    }

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
