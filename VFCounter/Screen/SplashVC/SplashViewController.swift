//
//  SplashViewController.swift
//  VFCounter
//
//  Created by Sunmi on 2020/10/06.
//  Copyright © 2020 creativeSun. All rights reserved.
//

import UIKit
import Lottie

class SplashViewController: UIViewController {

    @IBOutlet weak var animationView: AnimationView!
    var window: UIWindow!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.edgesForExtendedLayout = .all

        setupUI()
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    static func instance() -> SplashViewController {
        return SplashViewController()
    }

    func setupUI() {

        view.backgroundColor = .white
        animationView.backgroundColor = .white
        animationView.loopMode = .playOnce
        animationView.play { [weak self] finished in

            guard let self = self else { return }
             if finished {
                 self.loadMainVC()
             }
         }
         UIView.animate(withDuration: 1) {
             self.animationView.alpha = 1
         }
    }

    func loadMainVC() {

        self.presentOnRoot(with: VFTabBarController())
    }

}
