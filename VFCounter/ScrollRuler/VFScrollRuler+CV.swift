//
//  VFScrollRuler+CV.swift
//  VFCounter
//
//  Created by Sunmi on 2020/08/03.
//  Copyright © 2020 creativeSun. All rights reserved.
//

import UIKit


extension VFScrollRulerView: UICollectionViewDataSource {
    
    
    func configure<T: CellProtocol>(_ cellType: T.Type, for indexPath: IndexPath) -> T {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellType.reuseIdentifier, for: indexPath) as? T else {
            fatalError("Unable to dequeue \(cellType)")
        }

        return cell
    }

    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2 + stepNum
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
     
        switch indexPath.item {
        case 0:
            return configureCell(HeaderCell.self, value: minValue, for: indexPath)
        case stepNum + 1:
            return configureCell(FooterCell.self, value: maxValue, for: indexPath)
        default:
            return configureCell(CustomCell.self, value: step, for: indexPath)
        }
        
    }
    
    func configureCell<T: CellProtocol>(_ cellType: T.Type, value: Float, for indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = configure(T.self, for: indexPath)
        
        if cellType.reuseIdentifier != "CustomCell" {
            cell.addView(value, rulerUnit, collectionHeight, betweenNum: 0 ,rulerGap: 0, item: 0, minValue: 0)
        } else {
            cell.addView(value, rulerUnit, collectionHeight, betweenNum: betweenNum ,rulerGap: rulerGap,
                         item: indexPath.item, minValue: minValue)
        }
        return cell as! UICollectionViewCell
        
    }

}

/*

 if value == 0 || value <= minValue {
     valueTextField.text = String(minValue)
     perform(#selector(self.didChangedCVValue),with: nil, afterDelay: 0)
 } else if value < maxValue {
     valueTextField.text = String(minValue)
     perform(#selector(self.didChangedCVValue),with: nil, afterDelay: 0)
 }
 
 */

extension VFScrollRulerView: UICollectionViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let value = Int(scrollView.contentOffset.x) / rulerGap
        let totalValue = Float(value) * step + minValue
      
        if scrollByHand {
              if totalValue>=maxValue {
                  valueTextField.text = String(format: "%d", Int(maxValue))
              }else if totalValue <= minValue {
                  valueTextField.text = String(format: "%d", Int(minValue))
              }else{
                  valueTextField.text = String(format: "%d", value * Int(step)+Int(minValue))
              }
        }
        delegate?.yValueChanged(rulerView: self, value: totalValue)
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        if !decelerate {
            
            let value = Int(Float(scrollView.contentOffset.x)/Float(rulerGap))
            self.setRealValueAnimated(realValue: value, animated: true)
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
         let value = Int(Float(scrollView.contentOffset.x)/Float(rulerGap))
        self.setRealValueAnimated(realValue: value, animated: true)
    }
}

extension VFScrollRulerView: UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if indexPath.item == 0 || indexPath.item == stepNum + 1 {
            return CGSize(width: Int(self.frame.size.width/2), height: collectionHeight)
        }
        return CGSize(width: rulerGap*betweenNum, height: collectionHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }

}
extension VFScrollRulerView: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        self.editDone()
        return true
    }
}


/*
 
 func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
     return 0
 }
 
 func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
     return 0
 }
 */
