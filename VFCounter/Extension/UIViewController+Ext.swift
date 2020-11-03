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
    
    func presentAmountWarning(config: ValueConfig, type: String) -> Bool {
        
        switch type {
        
        case "야채":
            if config.sumVeggies == config.maxVeggies, config.sumVeggies > 0 {
                self.presentAlertVC(title: "알림", message: "최대치를 넘었습니다. 아이템을 삭제하세요!", buttonTitle: "OK")
                return true
            }

        default:
            if config.sumFruits == config.maxFruits, config.sumFruits > 0 {
                self.presentAlertVC(title: "알림", message: "최대치를 넘었습니다. 아이템을 삭제하세요!", buttonTitle: "OK")
                return true
            }
        }
        
        return false
    }
}
