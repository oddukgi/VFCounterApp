//
//  UIViewController+Ext.swift
//  VFCounter
//
//  Created by Sunmi on 2020/08/08.
//  Copyright © 2020 creativeSun. All rights reserved.
//

import UIKit



extension UIViewController {
  
    func presentAlertOnMainThread(title: String, message: String, buttonTitle: String) {
        
        DispatchQueue.main.async {
            let alertVC = GFAlertVC(title: title, message: message, buttonTitle: buttonTitle)
            alertVC.modalPresentationStyle  = .overFullScreen
            alertVC.modalTransitionStyle    = .crossDissolve
            alertVC.view.layoutIfNeeded() //avoid Snapshotting error
            self.present(alertVC, animated: true)
        }
    }
}
