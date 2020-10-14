//
//  UIViewController+Ext.swift
//  VFCounter
//
//  Created by Sunmi on 2020/08/08.
//  Copyright © 2020 creativeSun. All rights reserved.
//

import UIKit

extension UIViewController {

    func presentAlertVC(title: String, message: String, buttonTitle: String) {

        DispatchQueue.main.async {
            let alertConroller = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let okAction = UIAlertAction(title: buttonTitle, style: .default, handler: nil)
            alertConroller.addAction(okAction)
            self.present(alertConroller, animated: true, completion: nil)
        }
    }

    func setupToHideKeyboardOnTapOnView() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(UIViewController.dismissKeyboard))

        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
