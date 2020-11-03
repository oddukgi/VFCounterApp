//
//  ElementCell.swift
//  VFCounter
//
//  Created by Sunmi on 2020/09/22.
//  Copyright © 2020 creativeSun. All rights reserved.
//

import UIKit

class ElementCell: UITableViewCell, SelfConfigCell {

    static var reuseIdentifier = String(describing: ElementCell.self)

    var collectionView: UICollectionView!
    let elementModel = ElementModel()
    
    var parentVC: PeriodListVC? {
        let parentVC = self.parentViewController as? PeriodListVC
        return parentVC
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
    }
   
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - SizeFitting
    //https://medium.com/better-programming/self-sizing-hell-uitableview-and-uicollectionview-cells-509f0fdc7ff1
    // When this function is not overriden the "table view cell height zero" warning is displayed.
    override func systemLayoutSizeFitting(_ targetSize: CGSize, withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority, verticalFittingPriority: UILayoutPriority) -> CGSize {
        self.contentView.frame = self.bounds
        self.contentView.layoutIfNeeded()
        return self.collectionView.contentSize
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
   
    func configure() {
        
        let titleElementKind = "headerView"
        collectionView = UICollectionView(frame: contentView.bounds, collectionViewLayout:
                                            UIHelper.createHorizontalLayout(titleElemendKind: titleElementKind, isHeader: true, isPaddingForSection: true, nKind: 1))
        contentView.addSubview(collectionView)
        collectionView.register(ItemCell.self, forCellWithReuseIdentifier: ItemCell.reuseIdentifier)
        collectionView.register(HeaderView.self, forSupplementaryViewOfKind: titleElementKind, withReuseIdentifier: HeaderView.reuseIdentifier)
        collectionView.snp.makeConstraints { (maker) in
            maker.edges.equalTo(contentView)
        }
        collectionView.backgroundColor = .white
        collectionView.delegate = self
        elementModel.setupCV(collectionView: collectionView)
        elementModel.setupTitleView(collectionView: collectionView)
    }
    
    func updateData(titles: [String], category: [Category]) {
        elementModel.reloadCV(titles: titles, category: category)
    }

}
