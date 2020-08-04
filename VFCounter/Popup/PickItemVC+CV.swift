//
//  PickItemVC+CV.swift
//  VFCounter
//
//  Created by Sunmi on 2020/07/28.
//  Copyright © 2020 creativeSun. All rights reserved.
//

import UIKit

extension PickItemVC {
    // MARK: Set Layout for collection View

    func createCompositionalLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout(section: UIHelper.createColumnsLayout())
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 10
        layout.configuration = config
        
        return layout
    }
    
    func configureHierarchy() {
       
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createCompositionalLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(collectionView)
        collectionView.backgroundColor = ColorHex.lightKhaki
        collectionView.register(PickItemCell.self, forCellWithReuseIdentifier: PickItemCell.reuseIdentifier)
        collectionView.register(SectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                       withReuseIdentifier: SectionHeader.reuseIdentifier)
  
        let halfheight = (view.bounds.height / 2) - SizeManager().vegiePickCVHeight
        collectionView.snp.makeConstraints {
            $0.top.equalTo(btnClose.snp.bottom).offset(20)
            $0.leading.trailing.equalTo(view)
            $0.height.equalTo(halfheight)
        }
 
//     collectionView.layer.borderWidth = 1
        collectionView.delegate = self
   }

   func configureDataSource() {
 
    // MARK: Section DataSource
    
    dataSource = UICollectionViewDiffableDataSource<Section, PickItems.Element>(collectionView:collectionView,cellProvider: { (collectionView, indexPath, items) -> UICollectionViewCell? in
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PickItemCell.reuseIdentifier, for: indexPath)as! PickItemCell
        // 선택한 아이템을 다른 곳에 담기
        cell.contentView.backgroundColor = ColorHex.iceBlue
        cell.contentView.layer.cornerRadius = 10
        cell.setRadiusWithShadow(10)
        
        // vegie, fruit
        cell.set(items.image, items.name)
    
        // cell.set(vegies.image, vegies.name)
        cell.isChecked = self.checkedIndexPath.contains(indexPath)
        
        return cell
    })
    // MARK: Header DataSource
    dataSource.supplementaryViewProvider = { [weak self] collectionView, kind, indexPath in
        guard let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier:SectionHeader.reuseIdentifier, for: indexPath) as? SectionHeader else { return nil }
        
        let section = self?.dataSource.snapshot().sectionIdentifiers[indexPath.section]
        sectionHeader.lblTitle.text = section?.sectionTitle
        return sectionHeader
    }
    
   }
       
       
    func updateData() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, PickItems.Element>()
       
        if tag == 0 {
            snapshot.appendSections([.vegie])
            snapshot.appendItems(pickItems.collections.first!.elements)
      
        } else {
            snapshot.appendSections([.fruit])
            snapshot.appendItems(pickItems.collections.last!.elements)
        }
        
        // UI runs on mainthread
        DispatchQueue.main.async {
            self.dataSource.apply(snapshot, animatingDifferences: false)
        }
    }

    func storeItems(name: String, time: String, image: UIImage?, isChecked: Bool) {

       if isChecked {
        let item = VFItemController.Items(name: name, time: time, image: image, amount: amount)
            vfItems.append(item)
        }
        else {
            vfItems = vfItems.filter { $0.name != name }
        }
        
    }
        
}

extension PickItemVC: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // 아이템을 선택하면, 홈화면으로 이동
        self.collectionView.deselectItem(at: indexPath, animated: true)
        
        let cell = collectionView.cellForItem(at: indexPath) as! PickItemCell
        
        print("\(indexPath.row), \(indexPath.section)")
    
        if checkedIndexPath.contains(indexPath) {
            checkedIndexPath.remove(indexPath)
            cell.isChecked = false
        } else {
            checkedIndexPath.insert(indexPath)
            cell.isChecked = true

        }
        
        let name = cell.lblName.text!
        let time = btnTime.titleLabel!.text ?? ""
        let image = cell.vegieImage.image
        let isChecked = cell.isChecked
        
        storeItems(name: name, time: time, image: image, isChecked: isChecked)
    }
}

