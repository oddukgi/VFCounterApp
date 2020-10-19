//
//  CustomTableView.swift
//  VFCounter
//
//  Created by Sunmi on 2020/10/07.
//  Copyright © 2020 creativeSun. All rights reserved.
//

import UIKit

@objc protocol CustomTableViewDelegate: UITableViewDelegate {
    func tableViewDidTapBelowCells(tableView: UITableView, section: Int)
}

// Outside of tableview cell
// https://www.cocoanetics.com/2010/12/detecting-taps-outside-of-tableview-cells/
class CustomTableView: UITableView {
 
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
       
        let indexPath = self.indexPathForRow(at: point)

        if indexPath != nil {
            let delegate = self.delegate as? CustomTableViewDelegate
            delegate?.tableViewDidTapBelowCells(tableView: self, section: indexPath?.section ?? 0)
        }

        return super.hitTest(point, with: event)
    }
}

/*
 
 override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {

     guard isUserInteractionEnabled else { return nil }
     guard !isHidden else { return nil }
     guard alpha >= 0.01 else { return nil }

     guard self.point(inside: point, with: event) else { return nil }


     // add one of these blocks for each button in our collection view cell we want to actually work
     if  !self.itemEditView.isHidden && self.itemEditView.itemButton[0].point(inside: convert(point, to: itemEditView.itemButton[0]), with: event) {
        return self.itemEditView.itemButton[0]
     }
     if !self.itemEditView.isHidden && self.itemEditView.itemButton[1].point(inside: convert(point, to: itemEditView.itemButton[1]), with: event) {
            return self.itemEditView.itemButton[1]
     }

     return super.hitTest(point, with: event)
 }
 */
