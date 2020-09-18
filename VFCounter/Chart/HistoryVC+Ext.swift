//
//  HistoryVC+Ext.swift
//  VFCounter
//
//  Created by Sunmi on 2020/09/18.
//  Copyright © 2020 creativeSun. All rights reserved.
//

import UIKit

extension HistoryVC {
     // MARK: create collectionView datasource
      
      func configureDataSource() {
          dataSource = UICollectionViewDiffableDataSource<Weeks, SubItems>(collectionView: collectionView) {
              (collectionView: UICollectionView,  indexPath: IndexPath,
              data: SubItems) -> UICollectionViewCell? in
              
              // Get a cell of the desired kind.
              guard let cell = collectionView.dequeueReusableCell(
                  withReuseIdentifier: ListCell.reuseIdentifier,
                  for: indexPath) as? ListCell
                  else {
                      fatalError("Cannot create new cell")
                  }
              

              cell.layer.cornerRadius = 10
              cell.layer.borderWidth = 1
              cell.layer.borderColor = ColorHex.lightlightGrey.cgColor
              
//              let image = UIImage(data: data.image!)
//              let amount = Int(data.amount)
//
//              print("\(data.name!) \(data.createdDate!)")
//              let dateTime = data.createdDate?.changeDateTime(format: .dateTime)

//              cell.updateContents(image: image,name: data.name!, amount: amount, date: dateTime!)
//              cell.selectedItem = self.checkedIndexPath.contains(indexPath)

              return cell

          }
          
      }
    
      
      func configureTitleDataSource() {
          dataSource.supplementaryViewProvider = { [weak self]
              (collectionView: UICollectionView, kind: String, indexPath: IndexPath) -> UICollectionReusableView? in
              guard let self = self, let snapshot = self.currentSnapshot else { return nil }
              // Get a supplementary view of the desired kind.
              if let titleSupplementary = collectionView.dequeueReusableSupplementaryView(
                  ofKind: kind,
                  withReuseIdentifier: SectionHeader.reuseIdentifier,
                  for: indexPath) as? SectionHeader {
                  
                titleSupplementary.layer.borderWidth = 1
                  let weekday = snapshot.sectionIdentifiers[indexPath.section]
//                  titleSupplementary.delegate = self
                  titleSupplementary.lblTitle.text = weekday.day
                  return titleSupplementary
            } else {
              fatalError("Cannot create new supplementary")
          }
        }
    }
    func updateList(flag: Bool = true) {
          
        currentSnapshot = NSDiffableDataSourceSnapshot <Weeks, SubItems>()
        let count = (periodRange == .weekly) ? 14 : 30
        
        var index = 0
        
        
        
        for i in 0 ..< count {
      
            currentSnapshot.appendSections([setting.weekDays()[i]])
            

            let sectionIdentifier = currentSnapshot.sectionIdentifiers[i]
            index = (i > 6) ? (i / 2) : i
            if i % 2 == 0 {
                currentSnapshot.appendItems(DataManager.getVeggies(date: weekDate[index]))
            }
            
            
//            else {
//                currentSnapshot.appendItems(DataManager.weekItems[1](weekDate[index]))
//            }
           
        }
        
        self.dataSource.apply(self.currentSnapshot, animatingDifferences: flag)
//          reloadRing(date: stringDate)
      }

      func reloadRing(date: String) {
//      
//          dataManager.getSumItems(date: date) { (veggieSum, fruitSum) in
//              self.circularView.updateValue(amount: Int(veggieSum), tag: 0)
//              self.circularView.updateValue(amount: Int(fruitSum), tag: 1)
//          }
      }
      
      func hideItemView() {
          checkedIndexPath.removeAll()
          updateData()
      }
}
extension HistoryVC: UICollectionViewDelegate {
    
    // 아이템 값 수정 및 삭제
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // 아이템을 선택하면, 홈화면으로 이동
        let cell = collectionView.cellForItem(at: indexPath) as! VFItemCell
       
        if checkedIndexPath.isEmpty {
            cell.selectedItem = true
            checkedIndexPath.insert(indexPath)
            cell.selectedIndexPath(indexPath)
            
        } else {
            checkedIndexPath.removeAll()
             OperationQueue.main.addOperation {
                self.dataSource.apply(self.currentSnapshot, animatingDifferences: false)
            }
        }
        
    }
}

// MARK: - Protocol Extension
/*

extension HistoryVC: PickItemVCProtocol {
    
    func addItems(item: VFItemController.Items) {

        if !item.name.isEmpty {
            stringDate = String(item.date.split(separator: " ").first!)
            NotificationCenter.default.post(name: .updateDateTime, object: nil, userInfo: ["userdate": stringDate])
            dataManager.createEntity(item: item, tag: tag)
            updateData()
        }
      
    }
    
    func updateItems(item: VFItemController.Items, time: Date?) {
        var DataType: DataType.Type!
        tag == 0 ? (DataType = Veggies.self) : (DataType = Fruits.self)
        
        self.hideItemView()
        OperationQueue.main.addOperation {
            self.updateData(flag: false)
        }
        
        dataManager.modfiyEntity(item: item, originTime: time!, DataType)
      
        let date = item.entityDT?.changeDateTime(format: .selectedDT)
        let newDate = date!.replacingOccurrences(of: "-", with: ".").components(separatedBy: " ")
        
        NotificationCenter.default.post(name: .updateDateTime, object: nil, userInfo: ["userdate": newDate[0]])
    }

}
*/
extension HistoryVC: ItemCellDelegate {
    func deleteSelectedItem(item: Int, section: Int) {
        
    }
    

    func updateSelectedItem(item: VFItemController.Items, index: Int) {
        // display PickItemVC
        DispatchQueue.main.async {
//            let itemPickVC = PickItemVC(delegate: self, tag: index)
//
//            itemPickVC.items = item.copy() as? VFItemController.Items
//            let navController = UINavigationController(rootViewController: itemPickVC)
//            self.present(navController, animated: true)
        }
    }
    
    

    
}
