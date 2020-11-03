//
//  VFTabBarController.swift
//  VFCounter
//
//  Created by Sunmi on 2020/07/21.
//  Copyright © 2020 creativeSun. All rights reserved.
//

import UIKit

class VFTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.barTintColor = .white
        tabBar.isTranslucent = false
        UITabBar.appearance().tintColor = ColorHex.darkGreen
        UITabBar.appearance().clipsToBounds = true
        viewControllers = [ createHomeVC(), createChartVC(), createSettings()]
    }

    // MARK: - Child View Controller
    func createHomeVC() -> UINavigationController {
        let homeVC = HomeVC()
        let selectedHomeImg = UIImage(named: "selected home")?.withRenderingMode(.alwaysOriginal) // select image
        let homeImg = UIImage(named: "home")?.withRenderingMode(.alwaysOriginal)
        homeVC.tabBarItem = UITabBarItem(title: "홈", image: homeImg, selectedImage: selectedHomeImg)
        homeVC.tabBarItem.imageInsets = UIEdgeInsets(top: 4, left: 0, bottom: 0, right: 0)
        return UINavigationController(rootViewController: homeVC)
    }

    func createChartVC() -> UINavigationController {
    
        let chartVC = ChartVC()
        let selectedChartImg = UIImage(named: "selected chart")?.withRenderingMode(.alwaysOriginal) // select image
        let chartImg = UIImage(named: "chart")?.withRenderingMode(.alwaysOriginal)
        chartVC.tabBarItem = UITabBarItem(title: "데이터", image: chartImg, selectedImage: selectedChartImg)
        chartVC.tabBarItem.imageInsets = UIEdgeInsets(top: 4, left: 0, bottom: 0, right: 0)
        return UINavigationController(rootViewController: chartVC)
    }
//
    func createSettings() -> UINavigationController {
        let settingsVC = SettingVC()
        let selectedSettingsImg = UIImage(named: "selected setting")?.withRenderingMode(.alwaysOriginal) // select image
        let userImg = UIImage(named: "setting")?.withRenderingMode(.alwaysOriginal)
        settingsVC.tabBarItem = UITabBarItem(title: "설정", image: userImg, selectedImage: selectedSettingsImg)
        settingsVC.tabBarItem.imageInsets = UIEdgeInsets(top: 4, left: 0, bottom: 0, right: 0)
        return UINavigationController(rootViewController: settingsVC)

    }
}
