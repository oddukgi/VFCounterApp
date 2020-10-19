//
//  ElementCell.swift
//  VFCounter
//
//  Created by Sunmi on 2020/09/22.
//  Copyright © 2020 creativeSun. All rights reserved.
//

import UIKit

protocol ElementCellProtocol: class {

    func displayPickItemVC(pickItemVC: PickItemVC)
    func updateItem(date: Date, model: ItemModel, deletedSection: Bool)
    func updateNewItem(date: Date, model: ItemModel, deletedSection: Bool)
    func updateDeleteItem(date: Date, model: ItemModel)
    func updateEmptyItem(date: String)
    func presentSelectedAlertVC(indexPath: IndexPath, selectedDate: String, elementCell: ElementCell)
    func getSelectedDate(index: Int, tableViewCell: ElementCell) -> String
}

class ElementCell: UITableViewCell, SelfConfigCell {

    enum Section: String {
        case main
    }
    static let reuseIdentifier = "ElementCell"
 
    var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Section, DataType>! = nil
    var currentSnapshot: NSDiffableDataSourceSnapshot<Section, DataType>! = nil
    weak var delegate: ElementCellProtocol?
    var config = Config()
    
    var data: [DataType] = [] {
        didSet {
            updateData()
        }
    }
    
    var parentVC: PeriodListVC? {
        let parentVC = self.parentViewController as? PeriodListVC
        return parentVC
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
        configureDataSource()
        updateData()
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
    
    func deleteTableViewItem(indexPath: IndexPath, selectedDate: String) {

        let section = config.deleteItemName.retrieveKind()
        var datatype: DataType.Type! 
        section == 0 ? (datatype = Veggies.self) : (datatype = Fruits.self)

        var entityDate: Date?
        config.datamanager.fetchedDate(tag: section, index: indexPath.item, datatype,
                                       newDate: selectedDate) { (date) in
            entityDate = date
        }
        
        deleteEntity(entityDate: entityDate, datatype: datatype)
      
    }
    
    func deleteEntity(entityDate: Date?, datatype: DataType.Type) {
        
        var snapshot = self.dataSource.snapshot()

        guard let newDate = entityDate else { return }
        let entity = config.datamanager.getEntity(originTime: newDate, datatype)
        config.datamanager.deleteEntity(originTime: newDate, datatype)
        snapshot.deleteItems([entity])
        self.dataSource.apply(snapshot, animatingDifferences: true)
        
        var model = ItemModel()
        model.oldItem = entity.name ?? ""
        delegate?.updateDeleteItem(date: newDate, model: model)
    }

    func configure() {

        collectionView = UICollectionView(frame: contentView.bounds, collectionViewLayout:
                                        UIHelper.createHorizontalLayout(isHeader: false))
        contentView.addSubview(collectionView)
        collectionView.register(VFItemCell.self, forCellWithReuseIdentifier: VFItemCell.reuseIdentifier)

        collectionView.snp.makeConstraints { (maker) in
            maker.top.equalTo(contentView)
            maker.leading.trailing.equalTo(contentView)
            maker.bottom.equalTo(contentView)
        }
    
        collectionView.backgroundColor = .white
        collectionView.delegate = self
    }
    
    func updateData() {
        currentSnapshot = NSDiffableDataSourceSnapshot<Section, DataType>()
        currentSnapshot.appendSections([.main])
        currentSnapshot.appendItems(data)
        updateCollectionView()
    }
    
    func updateCollectionView() {
         OperationQueue.main.addOperation {
            self.dataSource.apply(self.currentSnapshot, animatingDifferences: false)
        }
    }
}

extension ElementCell {
    struct Config {
        let datamanager = DataManager()
        var selectedDate: String = ""
        var itemModel = ItemModel()
        var deleteItemName: String = ""
    }
}
