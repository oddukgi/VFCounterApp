//
//  ElementCell.swift
//  VFCounter
//
//  Created by Sunmi on 2020/09/22.
//  Copyright © 2020 creativeSun. All rights reserved.
//

import UIKit
import CoreStore

class ElementCell: UITableViewCell, SelfConfigCell {

    static var reuseIdentifier = String(describing: ElementCell.self)

    var collectionView: UICollectionView!
    let elementModel = ElementModel()
    // ListPublisher
    private var pModel: PeriodListModel!
    
    var model: PeriodListModel? {
        didSet {
            pModel = model
        }
    }
    
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
        elementModel.setupCV(collectionView: collectionView, elementCell: self)
        elementModel.setupTitleView(collectionView: collectionView)
    }
    
    func updateData(category: [Category], flag: Bool = false) {
        elementModel.reloadCV(category: category, flag: flag)
    }

}
extension ElementCell: UICollectionViewDelegate {

    @available(iOS 13.0, *)
      public func collectionView(_ collectionView: UICollectionView,
                                 contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {

        var itemCount = 0
        itemCount = elementModel.itemCount(forIndexPath: indexPath)
        
        guard indexPath.item < itemCount else {
            return nil
        }

        guard let cell = collectionView.cellForItem(at: indexPath) as? ItemCell else { return nil }

          var actions = [UIAction]()
          if itemCount > 0 {
            
//            print("Section \(indexPath.section) : \(itemCount)")
            
              let editAction = UIAction( title: "수정",
                                         image: UIImage(named: "edit")) { [weak self] _ in
                
                guard let self = self,
                      let item = self.elementModel.item(forIndexPath: indexPath)
                      else { return }

                self.pModel.updateItem =  UpdateItem(date: item.date!, itemCount: itemCount, status: .edit)
                cell.modifyEntity(date: item.date!, dataManager: self.pModel.dm, indexPath: indexPath)
                
              }

              let deleteAction = UIAction( title: "삭제",
                                           image: UIImage(named: "delete")) { [weak self] _ in
                
                guard let self = self,
                      let item = self.elementModel.item(forIndexPath: indexPath)
                      else { return }
                
                self.pModel.updateItem = UpdateItem(date: item.date!, itemCount: itemCount, status: .delete)
                cell.deleteEntity(date: item.date!, indexPath: indexPath)
              }

              actions = [editAction, deleteAction]
          }

          let actionProvider: UIContextMenuActionProvider = { _ in
              return UIMenu(title: "", children: actions)
          }

          return UIContextMenuConfiguration(
              identifier: "editItem" as NSCopying,
              previewProvider: nil,
              actionProvider: actionProvider)
      }

      public func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {

          // don't show menu for add item cell
        let itemCount = elementModel.itemCount(forIndexPath: indexPath)
   
        guard indexPath.item < itemCount else { return false }

        let editItems = UIMenuItem(title: "수정", action: #selector(modifyTapped(_:)))
        let deleteItems = UIMenuItem(title: "삭제", action: #selector(deleteTapped(_:)))
        UIMenuController.shared.menuItems = [editItems, deleteItems]
        return true
      }

      public func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector,
                                 forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {

        // don't show menu for add item cell
        let itemCount = elementModel.itemCount(forIndexPath: indexPath)
    
        if action == #selector(modifyTapped) && itemCount > 0 {
            return true
        } else if action == #selector(deleteTapped) && itemCount > 0 {
            return true
        }

        return false
      }

      public func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {

      }
}
