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
        
        collectionView.delegate = self
        collectionView.register(VFItemCell.self, forCellWithReuseIdentifier: VFItemCell.reuseIdentifier)
        collectionView.register(TitleSupplementaryView.self, forSupplementaryViewOfKind: titleElementKind,
                                     withReuseIdentifier: TitleSupplementaryView.reuseIdentifier)
        
    }
    
    func trimmingTime(userTime: String) -> String {
        var time = userTime
        let start = time.index(time.startIndex, offsetBy: 4)
        let end = time.index(time.endIndex, offsetBy: -3)
        let range = start..<end
        time.removeSubrange(range)
        
        return time
    }
    // MARK: create collectionView datasource
    func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<VFItemController.VFCollections, DataType>(collectionView: collectionView) {
            (collectionView: UICollectionView,  indexPath: IndexPath,
            data: DataType) -> UICollectionViewCell? in
            
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
            
//            var dataObject: DataType
//
//            if indexPath.section == 0 {
//                dataObject = self.userData[0][indexPath.row]
//            } else {
//                dataObject = self.userData[1][indexPath.row]
//            }
            let image = UIImage(data: data.image!)
            let amount = Int(data.amount)
            let time = self.trimmingTime(userTime: data.time!)
            cell.updateContents(image: image, time: time, name: data.name!, amount: amount)
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
        currentSnapshot = NSDiffableDataSourceSnapshot <VFItemController.VFCollections, DataType>()
        
        for i in 0..<2 {
            currentSnapshot.appendSections([vfitemController.collections[i]])
            currentSnapshot.appendItems(userData[i]!)
        }
         dataSource.apply(self.currentSnapshot, animatingDifferences: true)
         collectionView.reloadData()
    }
    
    
    func reloadData(section: Int) {
        
        currentSnapshot = NSDiffableDataSourceSnapshot <VFItemController.VFCollections, DataType>()
        
        if section == 0 {
            let veggies = UserDataManager.getEntity(Veggies.self,section: section)
            userData[0]!.append(veggies!)
            userData[0] = UserDataManager.sortEntity(Veggies.self,section: section)!
//
    
        } else {
            let fruits = UserDataManager.getEntity(Fruits.self,section: section)
            userData[1]!.append(fruits!)
            userData[1] = UserDataManager.sortEntity(Fruits.self,section: section)!
        }
    
        for i in 0..<2 {
            currentSnapshot.appendSections([vfitemController.collections[i]])
            currentSnapshot.appendItems(userData[i]!)
        }
        dataSource.apply(self.currentSnapshot, animatingDifferences: true)
    }
           
    
    // MARK: show veggie, fruit dialog
    @objc func addItems(sender: VFButton) {
   
        DispatchQueue.main.async {
            self.tag = sender.tag
            let veggiePickVC = PickItemVC(delegate: self, tag: sender.tag)
            let navController = UINavigationController(rootViewController: veggiePickVC)
            navController.modalPresentationStyle = .fullScreen
            self.present(navController, animated: false)
            
        }
    }
    
    
    
    func visibleIndexPathsToReload(intersecting indexPaths: [IndexPath]) -> [IndexPath] {
    let indexPathsForVisibleRows = collectionView.indexPathsForVisibleItems
      let indexPathsIntersection = Set(indexPathsForVisibleRows).intersection(indexPaths)
      return Array(indexPathsIntersection)
    }

}

extension UserItemVC: PickItemVCProtocol {
    
    func addItems(item: VFItemController.Items) {

        if tag == 0 {
            UserDataManager.createEntity(item: item, tag: 0)
        
        } else {
            UserDataManager.createEntity(item: item, tag: 1)
           
        }
        reloadData(section: tag)
    }

}
extension UserItemVC: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // 아이템을 선택하면, 홈화면으로 이동
        self.collectionView.deselectItem(at: indexPath, animated: true)
//        let cell = collectionView.cellForItem(at: indexPath) as! VFItemCell
        
        // show speechbubble
        
     
  
    }
}
