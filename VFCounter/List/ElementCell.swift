//
//  ElementCell.swift
//  VFCounter
//
//  Created by Sunmi on 2020/09/22.
//  Copyright © 2020 creativeSun. All rights reserved.
//

import UIKit

class ElementCell: UITableViewCell, SelfConfigCell {
    
    static let reuseIdentifier = "ElementCell"

    let sectionHeaderElementKind = "ElementSectionHeaderCell"
    
    var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Int, SubItems>! = nil
    var currentSnapshot: NSDiffableDataSourceSnapshot<Int, SubItems>! = nil
    
    private var date: String = "" {
        didSet {
            updateList()
        }   
    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
        configureDataSource()
       
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {
        
       
        collectionView = UICollectionView(frame: contentView.bounds, collectionViewLayout:
                                        UIHelper.createHorizontalLayout(titleElemendKind: sectionHeaderElementKind, isHeader: false))
        contentView.addSubview(collectionView)
        collectionView.register(ListCell.self, forCellWithReuseIdentifier: ListCell.reuseIdentifier)
      
        collectionView.snp.makeConstraints { (maker) in
            maker.top.equalTo(contentView)
            maker.leading.trailing.equalTo(contentView)
            maker.bottom.equalTo(contentView)
        }
        collectionView.backgroundColor = .white
    }

    // MARK: - SizeFitting
    // https://medium.com/better-programming/self-sizing-hell-uitableview-and-uicollectionview-cells-509f0fdc7ff1
    // When this function is not overriden the "table view cell height zero" warning is displayed.
    override func systemLayoutSizeFitting(_ targetSize: CGSize, withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority, verticalFittingPriority: UILayoutPriority) -> CGSize {
        // `collectionView.contentSize` has a wrong width because in this nested example, the sizing pass occurs before te layout pass,
        // so we need to force a force a  layout pass with the corredt width.
        self.contentView.frame = self.bounds
        self.contentView.layoutIfNeeded()
        // Returns `collectionView.contentSize` in order to set the UITableVieweCell height a value greater than 0.
        return self.collectionView.contentSize
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func updateDate(_ date: String) {
        self.date = date
    }
}

extension ElementCell {

    func updateList(flag: Bool = false) {
          
        var flag = false
        currentSnapshot = NSDiffableDataSourceSnapshot<Int, SubItems>()

        let veggieData = DataManager.getList(date: date, index: 0)
        let fruitData = DataManager.getList(date: date, index: 1)
        if !veggieData.isEmpty {
            
            flag = true
            currentSnapshot.appendSections([0])
            currentSnapshot.appendItems(veggieData)
        }
        
        if !fruitData.isEmpty {
            
            (flag == true) ? currentSnapshot.appendSections([1]) : currentSnapshot.appendSections([0])
            currentSnapshot.appendItems(fruitData)
            
        }
        
        self.dataSource.apply(self.currentSnapshot, animatingDifferences: flag)
//          reloadRing(date: stringDate)
      }

    
    func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Int, SubItems>(collectionView: collectionView) {
            (collectionView: UICollectionView,  indexPath: IndexPath,
            items: SubItems) -> UICollectionViewCell? in
            
            // Get a cell of the desired kind.
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: ListCell.reuseIdentifier,
                for: indexPath) as? ListCell
                else {
                    fatalError("Cannot create new cell")
                }
            
          
            let image = UIImage(data: items.element.image!)
            let amount = Int(items.element.amount)
            let name = items.element.name
            let date = items.element.createdDate?.changeDateTime(format: .dateTime)
            
            cell.updateContents(image: image, name: name!, amount: amount, date: date!)
            return cell

        }
        
    }
  
}
