//
//  CustomTableView.swift
//  VFCounter
//
//  Created by Sunmi on 2020/10/07.
//  Copyright © 2020 creativeSun. All rights reserved.
//

import UIKit

class CustomTableView: UITableView {

    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {

       
        guard let path = self.indexPathForRow(at: point) else {

            NotificationCenter.default.post(name: .touchOutsideTableView, object: nil,
                                            userInfo: ["hideEditView": true])
            return nil
        }
        

        NotificationCenter.default.post(name: .touchOutsideTableView, object: nil,
                                        userInfo: [  "hideEditView": false,
                                                     "indexPath": path ])

        return super.hitTest(point, with: event)
    }

}
