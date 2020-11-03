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

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(80))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                             subitem: layoutItem, count: 5)
//        group.interItemSpacing = .fixed(3.5)
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)

       return section
    }

    static func createHorizontalLayout(titleElemendKind: String = "", isHeader: Bool = true, isPaddingForSection: Bool = false, nKind: Int = 0) -> UICollectionViewCompositionalLayout {
        let sectionProvider = { (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                  heightDimension: .absolute(SizeManager().getUserItemHeight))

            let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
            layoutItem.contentInsets = NSDirectionalEdgeInsets(
               top: 3,
               leading: 2,
               bottom: 3,
               trailing: 2
            )

            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(SizeManager().getUserItemHeight))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                                  subitem: layoutItem, count: 5)
            let section = NSCollectionLayoutSection(group: group)
            section.orthogonalScrollingBehavior = .continuous
            
            //8, left: 9, bottom: 9, right: 9)
            if isPaddingForSection {
                
                if nKind == 0 {
                    section.contentInsets = SizeManager().getSectionEdgeInsects()
                } else {
                    section.contentInsets = SizeManager().getListEdgeInsects()
                }
            } else {
                section.contentInsets = NSDirectionalEdgeInsets(top: 6, leading: 10, bottom: 6, trailing: 10)
            }

            if isHeader {
                var titleSize: NSCollectionLayoutSize!
             
                if nKind == 1 {
                    titleSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.1),
                                                       heightDimension: .estimated(0.1))
                } else {
                    titleSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                       heightDimension: .estimated(28))
                }
                
                let titleSupplementary = NSCollectionLayoutBoundarySupplementaryItem(
                    layoutSize: titleSize,
                    elementKind: titleElemendKind,
                    alignment: .top)

                section.boundarySupplementaryItems = [titleSupplementary]
            }
            return section
        }

        let config = UICollectionViewCompositionalLayoutConfiguration()
        let layout = UICollectionViewCompositionalLayout(
            sectionProvider: sectionProvider, configuration: config)
        return layout
    }
    
    static func createFlowLayout() -> UICollectionViewFlowLayout {
        
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = SizeManager().getSectionInsectFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 2
        layout.minimumLineSpacing = 3
        
        let screenWidth = UIScreen.main.bounds.inset(by: layout.sectionInset).width
        let cellsPerRow: CGFloat = 5
        
        // iphone SE : 44
        let cellWidth = min(
            230,
            floor((screenWidth - ((cellsPerRow - 1) * layout.minimumInteritemSpacing)) / cellsPerRow)
        )
        layout.itemSize = .init(
            width: cellWidth,
            height: ceil(cellWidth * (6 / 5))
        )
        
        return layout
    }
}
