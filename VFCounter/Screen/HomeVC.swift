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

   let topConstraintConstant: CGFloat = DeviceTypes.isiPhoneSE || DeviceTypes.isiPhone8Zoomed ? 16 : 0

   lazy var headerView: UIView = {
      let subview = UIView()
      subview.backgroundColor = UIColor.white
      view.addSubview(subview)
      return subview
    }()

    let dateView = DateView()
    let contentView = UIView()
    let userItemView = UIView()

    deinit {
        removeNotification()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
       // 초기 실행시, 날짜 저장
        setupConstraints()
        setContentView()
        connectTapGesture()
        setupToHideKeyboardOnTapOnView()
        prepareNotificationAddObserver()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }

    // MARK: - notificationCenter
     fileprivate func prepareNotificationAddObserver() {
         NotificationCenter.default.addObserver(self, selector: #selector(self.updateDateTime(_:)),
                                                name: .updateDateTime, object: nil)
     }
    // MARK: action
    @objc fileprivate func updateDateTime(_ notification: Notification) {

        if let userDate = notification.userInfo?["userdate"] as? String {
            dateView.updateDate(userdate: userDate)
        }
    }
    
    func removeNotification() {
        NotificationCenter.default.removeObserver(self, name: .updateDateTime, object: nil)
    }
    
    @objc func dateLabelTapped(_ sender: UITapGestureRecognizer) {
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
        
        if isUpdateCalendar {
            // notification
            NotificationCenter.default.post(name: .selectDateCalendar, object: nil, userInfo: ["selectdate": date])
        }
        
    }
}
