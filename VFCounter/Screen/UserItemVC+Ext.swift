//
//  UserItemVC+Ext.swift
//  VFCounter
//
//  Created by Sunmi on 2020/07/24.
//  Copyright © 2020 creativeSun. All rights reserved.
//

import UIKit
import SnapKit


extension UserItemVC {
    
// MARK: create collectionView layout
    
    func createLayout() -> UICollectionViewCompositionalLayout {
        let sectionProvider = { (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(SizeManager().getUserItemHeight))
            let item     = NSCollectionLayoutItem(layoutSize: itemSize)
            item.contentInsets = NSDirectionalEdgeInsets(top: 14, leading: 0, bottom: 0, trailing: 0)
            
            /// group
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.26), heightDimension: .absolute(SizeManager().getUserItemHeight))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            group.interItemSpacing = .fixed(3)
//            group.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 0, bottom: 0, trailing: 0)
          
            let section = NSCollectionLayoutSection(group: group)
            section.orthogonalScrollingBehavior = .continuous
            section.interGroupSpacing = 5
            section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 12, bottom: 0, trailing: 12)

            let titleSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                   heightDimension: .estimated(22))
            let titleSupplementary = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: titleSize,
                elementKind: self.titleElementKind,
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
    
    // 384 X 104 , item : 74 X 73
    func configureHierarchy() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collectionView.backgroundColor = ColorHex.iceBlue
        view.addSubview(collectionView)

        let tabBarHeight = tabBarController?.tabBar.bounds.size.height ?? 0
        let padding = (view.bounds.height - height) - tabBarHeight
        collectionView.snp.makeConstraints { make in
          //  make.top.equalTo(view).offset(height)
            make.top.equalTo(circularView.snp.bottom).offset(8)
            make.leading.trailing.equalTo(view)
            make.height.equalTo(padding)
        }
        collectionView.register(VFItemCell.self, forCellWithReuseIdentifier: VFItemCell.reuseIdentifier)
        collectionView.register(TitleSupplementaryView.self, forSupplementaryViewOfKind: titleElementKind,
                                     withReuseIdentifier: TitleSupplementaryView.reuseIdentifier)
    }
    
    // MARK: create collectionView datasource
    func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<VFItemController.VFCollections, VFItemController.Items>(collectionView: collectionView) {
            (collectionView: UICollectionView,  indexPath: IndexPath,
            collections: VFItemController.Items) -> UICollectionViewCell? in
            
            // Get a cell of the desired kind.
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: VFItemCell.reuseIdentifier,
                for: indexPath) as? VFItemCell
                else {
                    fatalError("Cannot create new cell")
                }

            cell.layer.cornerRadius = 10
            cell.layer.borderWidth = 1
            cell.layer.borderColor = ColorHex.lightlightGrey.cgColor
            
            cell.updateContents(image: collections.image, time: collections.time, name: collections.name, amount: collections.amount)
            // Return the cell.
            return cell

        }
        
    }
    func configureTitleDataSource() {
        dataSource.supplementaryViewProvider = { [weak self]
            (collectionView: UICollectionView, kind: String, indexPath: IndexPath) -> UICollectionReusableView? in
            guard let self = self, let snapshot = self.currentSnapshot else { return nil }
            
            // get a supplementary view of each section
            if let titleSupplementary = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: TitleSupplementaryView.reuseIdentifier, for: indexPath) as? TitleSupplementaryView {
                
                // create section's title and subtitle
                let category = snapshot.sectionIdentifiers[indexPath.section]
                
                titleSupplementary.btnPlus.tag = indexPath.section
                titleSupplementary.btnPlus.addTarget(self, action: #selector(self.addItems(sender:)), for: .touchUpInside)
                titleSupplementary.updateTitles(title: category.title, subtitle: category.subtitle)
                
                return titleSupplementary
            } else {
                fatalError("Cannot create new supplementary")
            }
        }
    }
    
    func updateData() {
        currentSnapshot = NSDiffableDataSourceSnapshot <VFItemController.VFCollections, VFItemController.Items>()
        vfitemController.collections.forEach {
             let collection = $0
             currentSnapshot.appendSections([collection])
             currentSnapshot.appendItems(collection.item)
         }
         dataSource.apply(currentSnapshot, animatingDifferences: true)
        
        // NotificationCenter Item 보내기 ( AlarmSettingVC)
    }
    
    // MARK: show vegie, fruit dialog
    @objc func addItems(sender: VFButton) {
   
        DispatchQueue.main.async {
            self.tag = sender.tag
            let vegiePickVC = PickItemVC(delegate: self, tag: sender.tag)
            let navController = UINavigationController(rootViewController: vegiePickVC)
            navController.modalPresentationStyle = .fullScreen
            self.present(navController, animated: false)
            
        }
    }
}

extension UserItemVC: PickItemVCProtocol {
    
    func displayPickItems(name: String, time: String, image: UIImage?, amount: Int) {
        
        let item = VFItemController.Items(name: name, time: time, image: image, amount: amount)
        tag == 0 ? vfitemController.collections[0].item.append(item) : vfitemController.collections[1].item.append(item)
        updateData()
    }

}
