//
//  SplashVC.swift
//  VFCounter
//
//  Created by Sunmi on 2020/10/06.
//  Copyright © 2020 creativeSun. All rights reserved.
//

import UIKit
import Lottie
import SnapKit

class SplashVC: UIViewController {

    var animationView: AnimationView!
    var window: UIWindow!
    
    let defaultSize: CGFloat = 230
   
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupAnimationView()
    }
    
    
    static func instance() -> SplashVC {
        return SplashVC()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        animationView.stop()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setNeedsStatusBarAppearanceUpdate()
    }
    
    
    // MARK: - UI Setup
    
    func setupUI() {
        
        view.backgroundColor = .red
        animationView = AnimationView(name: "food-animation")
        animationView.bounds = CGRect(x: 0, y: 0, width: 215, height: 320)
        animationView.center = view.center
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .playOnce
        view.addSubview(animationView)

    }
    
    
    // MARK: - Setup Animationview
    func setupAnimationView() {
        
       animationView.play(fromFrame: 40, toFrame: 135, completion: {finished in
           UIView.animate(withDuration: 1.5, animations: {
               
               self.animationView.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
               self.animationView.alpha = 0

               self.loadMainVC()
           })
           
       })
    }
    
    func loadMainVC() {     
        self.presentOnRoot(with: VFTabBarController())
    }


}



