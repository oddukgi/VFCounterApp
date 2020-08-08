//
//  UIHelper.swift
//  VFCounter
//
//  Created by Sunmi on 2020/07/28.
//  Copyright © 2020 creativeSun. All rights reserved.
//

import UIKit


enum UIHelper {
    
    
   // MARK: CollectionLayout
    static func createSectionHeader() -> NSCollectionLayoutBoundarySupplementaryItem {
        let layoutSectionHeaderSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.93), heightDimension: .estimated(30))
        let layoutSectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: layoutSectionHeaderSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        return layoutSectionHeader
    }
    
    static func createColumnsLayout() -> NSCollectionLayoutSection {
        
       let itemSize = NSCollectionLayoutSize(
        widthDimension: .fractionalWidth(1.0),
        heightDimension: .absolute(200)
       )

       let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
       layoutItem.contentInsets = NSDirectionalEdgeInsets(
          top: 5,
          leading: 5,
          bottom: 5,
          trailing: 5
       )
        
    let layoutGroupSize = NSCollectionLayoutSize(
        widthDimension: .fractionalWidth(0.3),
        heightDimension: .absolute(200)
       )
       let layoutGroup = NSCollectionLayoutGroup.vertical(
          layoutSize: layoutGroupSize,
          subitem: layoutItem,
          count: 2
       )

       let layoutSection = NSCollectionLayoutSection(group: layoutGroup)
       layoutSection.orthogonalScrollingBehavior = .continuous

       layoutSection.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        
       let layoutSectionHeader = createSectionHeader()
       layoutSection.boundarySupplementaryItems = [layoutSectionHeader]

       return layoutSection
    }
    
    // MARK: UIViewController
    static func backToPreviousScreen(_ view: UIViewController){
        if view.navigationController != nil{
            view.navigationController?.popViewController(animated: true)
        }else{
            view.dismiss(animated: true, completion: nil)
        }
    }
}
