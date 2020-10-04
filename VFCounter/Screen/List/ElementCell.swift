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
    func updateTableView()
    
}
class ElementCell: UITableViewCell, SelfConfigCell {
    
    static let reuseIdentifier = "ElementCell"

    let sectionHeaderElementKind = "ElementSectionHeaderCell"
    let datamanager = DataManager()
    
    var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Int, SubItems>! = nil
    var currentSnapshot: NSDiffableDataSourceSnapshot<Int, SubItems>! = nil
    var checkedIndexPath = Set<IndexPath>()
    weak var delegate: ElementCellProtocol?
    
    private var date: String = "" {
        didSet {
            updateList()
        }   
    }
    
    var kindIndex: Int = 0
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
        collectionView.register(VFItemCell.self, forCellWithReuseIdentifier: VFItemCell.reuseIdentifier)
      
        collectionView.snp.makeConstraints { (maker) in
            maker.top.equalTo(contentView)
            maker.leading.trailing.equalTo(contentView)
            maker.bottom.equalTo(contentView)
        }
        collectionView.backgroundColor = .white
        collectionView.delegate = self
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
        let datamanager = DataManager()
        currentSnapshot = NSDiffableDataSourceSnapshot<Int, SubItems>()

        let veggieData = datamanager.getList(date: date, index: 0)
        let fruitData = datamanager.getList(date: date, index: 1)
        if !veggieData.isEmpty {
            
            flag = true
            currentSnapshot.appendSections([0])
            currentSnapshot.appendItems(veggieData)
        }
        
        if !fruitData.isEmpty {
            
            (flag == true) ? currentSnapshot.appendSections([1]) : currentSnapshot.appendSections([0])
            currentSnapshot.appendItems(fruitData)
            
        }
    
        self.dataSource.apply(self.currentSnapshot, animatingDifferences: false)

      }

    
    func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Int, SubItems>(collectionView: collectionView) {
            (collectionView: UICollectionView,  indexPath: IndexPath,
            items: SubItems) -> UICollectionViewCell? in
            
            // Get a cell of the desired kind.
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: VFItemCell.reuseIdentifier,
                for: indexPath) as? VFItemCell
                else {
                    fatalError("Cannot create new cell")
                }            
          
            cell.layer.cornerRadius = 10
            cell.layer.borderWidth = 1
            cell.delegate = self
            cell.layer.borderColor = ColorHex.lightlightGrey.cgColor
            
            let image = UIImage(data: items.element.image!)
            let amount = Int(items.element.amount)
            let name = items.element.name
            let date = items.element.createdDate?.changeDateTime(format: .dateTime)
            
            cell.updateContents(image: image, name: name!, amount: amount, date: date!)
            cell.selectedItem = self.checkedIndexPath.contains(indexPath)
            return cell

        }
        
    }
    
    func hideItemView() {
        checkedIndexPath.removeAll()
//        updateData()
    }
    
}


extension ElementCell: UICollectionViewDelegate {
    
    // 아이템 값 수정 및 삭제
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // 아이템을 선택하면, 홈화면으로 이동
        let cell = collectionView.cellForItem(at: indexPath) as! VFItemCell
        var snap = self.dataSource.snapshot()
        if checkedIndexPath.isEmpty {
            cell.selectedItem = true
            checkedIndexPath.insert(indexPath)
            cell.selectedIndexPath(indexPath)
            
        } else {
            checkedIndexPath.removeAll()
             OperationQueue.main.addOperation {
                self.dataSource.apply(snap, animatingDifferences: false)
            }
        }
        
    }
}


extension ElementCell: ItemCellDelegate {

    func updateSelectedItem(item: VFItemController.Items, index: Int) {
        
        let dataManager = DataManager()
        
        var datemodel: DateModel!
        
        print(item.date)
        
        dataManager.getSumItems(date: item.date) { (veggieSum, fruitSum) in
            
            datemodel = DateModel(tag: index, sumV: veggieSum,
                                      sumF: fruitSum, maxV: 500, maxF: 500)
            
        }

        let itemPickVC = PickItemVC(delegate: self, datemodel: datemodel)
        itemPickVC.items = item.copy() as? VFItemController.Items
        delegate?.displayPickItemVC(pickItemVC: itemPickVC)
    }
    
    
    func deleteSelectedItem(item: Int, section: Int) {

        var datatype: DataType.Type!
        section == 0 ? (datatype = Veggies.self) : (datatype = Fruits.self)
        var snapshot = self.dataSource.snapshot()
        
        if let listData = self.dataSource.itemIdentifier(for: IndexPath(item: item, section: section)) {
            datamanager.deleteEntity(originTime:listData.element.createdDate!,datatype)
            snapshot.deleteItems([listData])
            self.dataSource.apply(snapshot, animatingDifferences: true)
        }
        
        OperationQueue.main.addOperation {
            self.delegate?.updateTableView()
        }
        
    }
    
}

// MARK: - Protocol Extension

extension ElementCell: PickItemVCProtocol {
    
    func addItems(item: VFItemController.Items, tag: Int) {

        let datemodel = DateModel(tag: tag, sumV: 0,sumF: 0, maxV: 500, maxF: 500)
        let pickItemVC = PickItemVC(delegate: self, datemodel: datemodel)
        pickItemVC.items = item.copy() as? VFItemController.Items
        delegate?.displayPickItemVC(pickItemVC: pickItemVC)
    }
    
    func updateItems(item: VFItemController.Items, time: Date?, tag: Int) {
        var datatype: DataType.Type!
        tag == 0 ? (datatype = Veggies.self) : (datatype = Fruits.self)
        

        datamanager.modfiyEntity(item: item, originTime: time!, datatype)
        OperationQueue.main.addOperation {
            self.updateList(flag: true)
            self.delegate?.updateTableView()
        }

        let date = item.entityDT?.changeDateTime(format: .selectedDT)
        let newDate = date!.replacingOccurrences(of: "-", with: ".").components(separatedBy: " ")
      
        NotificationCenter.default.post(name: .updateDateTime, object: nil, userInfo: ["userdate": newDate[0]])
    }
}
