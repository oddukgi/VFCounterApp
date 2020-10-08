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

   func configureDataSource() {

        dataSource = UICollectionViewDiffableDataSource<Section, PickItems.Element>(collectionView:collectionView,cellProvider: { (collectionView, indexPath, items) -> UICollectionViewCell? in
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PickItemCell.reuseIdentifier, for: indexPath)as! PickItemCell
        // 선택한 아이템을 다른 곳에 담기
        cell.contentView.backgroundColor = ColorHex.iceBlue
        cell.contentView.layer.cornerRadius = 10
        cell.setRadiusWithShadow(10)
        
        // veggie, fruit
        cell.set(items.image, items.name)
    
        // cell.set(veggies.image, veggies.name)
        cell.isChecked = self.checkedIndexPath.contains(indexPath)
        
        return cell
    })
   }
       
    func updateData() {
        currentSnapshot = NSDiffableDataSourceSnapshot<Section, PickItems.Element>()
       
        currentSnapshot.appendSections([.main])
        if datemodel.tag == 0 {
            currentSnapshot.appendItems(pickItems.collections.first!.elements)
      
        } else {
            currentSnapshot.appendItems(pickItems.collections.last!.elements)
        }
        
        updateCollectionView()
    }

    func storeItems(name: String, dateTime: String, image: UIImage?) {
        pickItems.item.name  = name
        pickItems.item.image = image
        pickItems.item.dateTime = dateTime
    }
    
    func updateCollectionView() {
    
         OperationQueue.main.addOperation {
            self.dataSource.apply(self.currentSnapshot, animatingDifferences: false)
        }
    
    }
    
    func configureSegmentControl() {
        
        kindSegmentControl = UISegmentedControl(items: ["야채", "과일"])
        kindSegmentControl.selectedSegmentIndex = 0
        
        let width = 100
        view.addSubview(kindSegmentControl)
        
        kindSegmentControl.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
            make.trailing.equalTo(view).offset(-20)
            make.width.equalTo(width)
            make.height.equalTo(30)
        }
    
        // Style the Segmented Control
        kindSegmentControl.layer.cornerRadius = 5.0  // Don't let background bleed
        kindSegmentControl.backgroundColor = ColorHex.iceBlue
        kindSegmentControl.tintColor = ColorHex.lightBlue

            // Add target action method
        kindSegmentControl.addTarget(self, action: #selector(changedIndexSegment), for: .valueChanged)
    }
    
    @objc func changedIndexSegment(sender: UISegmentedControl) {

        switch sender.selectedSegmentIndex {
        case 0:
            datemodel.tag = 0
            
        default:
            datemodel.tag = 1

        }
        updateNaviTitle(to: datemodel.tag)
        updateData()
      }
}

extension PickItemVC: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        self.collectionView.deselectItem(at: indexPath, animated: true)
        let cell = collectionView.cellForItem(at: indexPath) as! PickItemCell
     
        checkedIndexPath.removeAll()
        cell.isChecked = false

        updateCollectionView()
        checkedIndexPath.insert(indexPath)
        cell.isChecked = true    
   
        let name = cell.lblName.text!      
        let image = cell.veggieImage.image
        
        storeItems(name: name, dateTime: datemodel.date, image: image)
    }
}


