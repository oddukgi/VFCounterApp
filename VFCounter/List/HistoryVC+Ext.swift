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
              items: SubItems) -> UICollectionViewCell? in
              
              // Get a cell of the desired kind.
              guard let cell = collectionView.dequeueReusableCell(
                  withReuseIdentifier: ListCell.reuseIdentifier,
                  for: indexPath) as? ListCell
                  else {
                      fatalError("Cannot create new cell")
                  }
              
            
            let image = UIImage(data: items.element.image!)
            let amount = Int(items.element.amount)
            let name = items.element.name
            let date = items.element.createdDate?.changeDateTime(format: .dateTime)

            cell.updateContents(image: image, name: name!, amount: amount, date: date!)
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
                
           
                let weekday = snapshot.sectionIdentifiers[indexPath.section]
                
                if !weekday.day.containsWhitespaceAndNewlines() {
                    titleSupplementary.frame = .zero

                }
                else {
                
                    titleSupplementary.lblTitle.text = weekday.day
                    titleSupplementary.layer.borderWidth = 1
                }
                
                return titleSupplementary
                    
                    
            } else {
              fatalError("Cannot create new supplementary")
          }
        }
    }
    
    func updateCell(for indexPath: IndexPath, headerCell: UICollectionReusableView)  {
        
        headerCell.layer.borderColor = UIColor.clear.cgColor
    }
    
    func updateList(flag: Bool = false) {
          
        currentSnapshot = NSDiffableDataSourceSnapshot <Weeks, SubItems>()
        let count = (periodRange == .weekly) ? 7 : 30
        var index = 0
        

        var flag = false
        for var i in 0 ..< count {
  
            index = (i > 6) ? (i / 2) : i

            let weekdayArray = weekDate[index].components(separatedBy: " ")
            let veggieData = DataManager.getList(date: weekdayArray[0], index: 0)
            if veggieData.count > 0 {
               
                flag = true
                let weekday = Weeks(day: weekdayArray[1])
                currentSnapshot.appendSections([weekday])
                currentSnapshot.appendItems(veggieData)
            } else {
                flag = false
            }
            

            let fruitData = DataManager.getList(date: weekdayArray[0], index: 1)
            var weekday = Weeks(day: weekdayArray[1])
            if fruitData.count > 0 {
  
                if flag == true {
                   i += 1
                    weekday = Weeks(day: "")
                }
                
                currentSnapshot.appendSections([weekday])
                currentSnapshot.appendItems(fruitData)

            }
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
//          checkedIndexPath.removeAll()
          updateData()
      }
}
extension HistoryVC: UICollectionViewDelegate {

    
    // 아이템 값 수정 및 삭제
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // 아이템을 선택하면, 홈화면으로 이동
//        let cell = collectionView.cellForItem(at: indexPath) as! VFItemCell
       
//        if checkedIndexPath.isEmpty {
//            cell.selectedItem = true
//            checkedIndexPath.insert(indexPath)
//            cell.selectedIndexPath(indexPath)
//
//        } else {
//            checkedIndexPath.removeAll()
//             OperationQueue.main.addOperation {
//                self.dataSource.apply(self.currentSnapshot, animatingDifferences: false)
//            }
//        }
//
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
