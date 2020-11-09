//
//  EditableListDataSource.swift
//  VFCounter
//
//  Created by Sunmi on 2020/10/31.
//  Copyright © 2020 creativeSun. All rights reserved.
//

import UIKit

final class EditableListDataSource<S: Hashable, I: Hashable>: UITableViewDiffableDataSource<S, I> {
    
    var titleForSection: ((Int) -> String?)?
    var subcategorys: ((Int) -> Int?)?

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.titleForSection?(section)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.subcategorys?(section) ?? 0
    }
    
}
