//
//  SettingItemCell.swift
//  VFCounter
//
//  Created by Sunmi on 2020/08/05.
//  Copyright © 2020 creativeSun. All rights reserved.
//

import UIKit
import SnapKit

class SettingItemCell: UITableViewCell {
    
    static let reuseIdentifier = "SettingItemCell"
    
    lazy var itemImgView: UIImageView = {
        let image = UIImage(named: "alarm")
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        return imageView
        
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setLayout()
    }
    
    func setLayout() {
        
        contentView.addSubview(itemImgView)
        
        itemImgView.snp.makeConstraints { make in
            make.centerY.equalTo(contentView.snp.centerY)
            make.leading.equalTo(contentView).offset(25)
            make.size.equalTo(CGSize(width: 25, height: 25))
        }

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    

    }

}
