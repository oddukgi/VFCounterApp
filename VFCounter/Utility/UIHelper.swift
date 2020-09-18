//
//  UIHelper.swift
//  VFCounter
//
//  Created by Sunmi on 2020/07/28.
//  Copyright © 2020 creativeSun. All rights reserved.
//

import UIKit


enum UIHelper {
    static let sectionHeaderElement = "sectionHeaderKind"
    
   // MARK: CollectionLayout
    static func createSectionHeader() -> NSCollectionLayoutBoundarySupplementaryItem {
        let layoutSectionHeaderSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.93), heightDimension: .estimated(30))
        let layoutSectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: layoutSectionHeaderSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        return layoutSectionHeader
    }
    
    static func createColumnsLayout() -> NSCollectionLayoutSection {
        
       let itemSize = NSCollectionLayoutSize(
        widthDimension: .fractionalWidth(1.0),
        heightDimension: .absolute(80)
       )

       let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
       layoutItem.contentInsets = NSDirectionalEdgeInsets(
          top: 3,
          leading: 2,
          bottom: 3,
          trailing: 2
       )
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),heightDimension: .absolute(80))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                             subitem: layoutItem, count: 5)
//        group.interItemSpacing = .fixed(3.5)
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        
//       let sectionHeader = createSectionHeader()
//       section.boundarySupplementaryItems = [sectionHeader]

       return section
    }
    
    static func createHorizontalLayout(titleElemendKind: String) -> UICollectionViewCompositionalLayout {
        let sectionProvider = { (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(SizeManager().getUserItemHeight))
            let item     = NSCollectionLayoutItem(layoutSize: itemSize)
            item.contentInsets = NSDirectionalEdgeInsets(top: SizeManager().itemTopPaddingCV, leading: 0, bottom: 0, trailing: 0)
            
            /// group
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.26), heightDimension: .absolute(SizeManager().getUserItemHeight))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            group.interItemSpacing = .fixed(3)
            group.contentInsets = NSDirectionalEdgeInsets(top: SizeManager().groupTopPaddingCV, leading: 0, bottom: 0, trailing: 0)
            
            let section = NSCollectionLayoutSection(group: group)
            section.orthogonalScrollingBehavior = .continuous
            section.interGroupSpacing = 10
            section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 12, bottom: 0, trailing: 12)

            let titleSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                   heightDimension: .estimated(22))
            let titleSupplementary = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: titleSize,
                elementKind: titleElemendKind,
                alignment: .top)
            section.boundarySupplementaryItems = [titleSupplementary]
            return section
        }
        
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = SizeManager().sectionSpacingForUserItemCV

        let layout = UICollectionViewCompositionalLayout(
            sectionProvider: sectionProvider, configuration: config)
        return layout          
    }

     static func createList() -> UICollectionViewLayout {
           
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 0
           let sectionProvider = UICollectionViewCompositionalLayout(sectionProvider: {
                (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in

            let itemSize = NSCollectionLayoutSize(widthDimension: .estimated(65),
                                                  heightDimension: .absolute(65))
            let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)

            let layoutGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(65))
            let layoutGroup = NSCollectionLayoutGroup.horizontal(layoutSize: layoutGroupSize, subitems: [layoutItem])
            layoutGroup.interItemSpacing = .fixed(3)
            layoutGroup.edgeSpacing = NSCollectionLayoutEdgeSpacing(leading: .fixed(100), top: nil, trailing: nil, bottom: nil)
            
            let section = NSCollectionLayoutSection(group: layoutGroup)
            section.orthogonalScrollingBehavior = .continuous
            let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: NSCollectionLayoutSize(widthDimension: .absolute(65),  heightDimension: .absolute(65)), elementKind: UICollectionView.elementKindSectionHeader,
                alignment: .topLeading,absoluteOffset:.init(x: 0, y: 65))
            sectionHeader.pinToVisibleBounds = true
            section.contentInsets = .init(top: 0, leading: 16, bottom: 0, trailing: 16)
            section.boundarySupplementaryItems = [sectionHeader]
            return section
            
            
            },configuration: config)

            return sectionProvider

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
