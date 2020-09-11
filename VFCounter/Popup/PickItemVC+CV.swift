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
 
    // MARK: Section DataSource
    
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
        if tag == 0 {
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
        
        storeItems(name: name, dateTime: userdate, image: image)
    }
}

extension PickItemVC: MeasurementViewDelegate {


    
}

