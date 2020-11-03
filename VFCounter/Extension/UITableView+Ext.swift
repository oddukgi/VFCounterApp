//
//  UITableView+Ext.swift
//  VFCounter
//
//  Created by Sunmi on 2020/10/24.
//  Copyright © 2020 creativeSun. All rights reserved.
//

import UIKit

// This code refers to
extension UITableView {
    
    func dequeueCell<T: UITableViewCell>(indexPath: IndexPath) -> T? {
        return self.dequeueReusableCell(withIdentifier: String(describing: T.self), for: indexPath) as? T
    }
    
    func hasRowAtIndexPath(indexPath: IndexPath) -> Bool {
        return indexPath.section < self.numberOfSections && indexPath.row < self.numberOfRows(inSection: indexPath.section)
    }

    func scrollToTop(animated: Bool, section: Int) {
        let indexPath = IndexPath(row: 0, section: section)
        if self.hasRowAtIndexPath(indexPath: indexPath) {
            self.scrollToRow(at: indexPath, at: .top, animated: animated)
        }
    }
}
