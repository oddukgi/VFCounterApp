//
//  HomeVC.swift
//  VFCounter
//
//  Created by Sunmi on 2020/07/21.
//  Copyright © 2020 creativeSun. All rights reserved.
//

import UIKit
import CoreLocation

class HomeVC: UIViewController {

   lazy var headerView: UIView = {
      let subview = UIView()
      subview.backgroundColor = UIColor.white
      view.addSubview(subview)
      return subview
    }()

    let dateView = DateView()
    let contentView = UIView()
    let userItemView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        setupConstraints()
        setContentView()
        connectTapGesture()
        setupToHideKeyboardOnTapOnView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }

    @objc func dateLabelTapped(_ sender: UITapGestureRecognizer) {
        
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
       
        var dateTxt = dateView.dateLabel.text!
        var shortDate = String(dateTxt.split(separator: " ").first!)
        var date = shortDate.changeDateTime(format: .date)

        DispatchQueue.main.async {
            let calendarVC = CalendarVC(date: date)
            calendarVC.modalPresentationStyle  = .overFullScreen
            calendarVC.modalTransitionStyle    = .crossDissolve
            calendarVC.view.layoutIfNeeded() //avoid Snapshotting error
            calendarVC.delegate = self
            self.present(calendarVC, animated: true)
        }
    }

    func connectTapGesture() {
        let labelTap = UITapGestureRecognizer(target: self, action: #selector(self.dateLabelTapped(_:)))
        dateView.dateLabel.isUserInteractionEnabled = true
        dateView.dateLabel.addGestureRecognizer(labelTap)
    }
}

extension HomeVC: CalendarVCDelegate {
    func updateDate(date: Date, isUpdateCalendar: Bool) {
        let newDate = date.changeDateTime(format: .date)
        dateView.updateDate(userdate: newDate)
        
    }
}
