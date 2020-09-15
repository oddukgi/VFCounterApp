//
//  UIView+Ext.swift
//  DrinkCounter
//
//  Created by Sunmi on 2020/07/01.
//  Copyright © 2020 CreativeSuns. All rights reserved.
//

import UIKit


extension UIView {
    
    func pinToEdges(of superview: UIView) {
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: superview.topAnchor),
            leadingAnchor.constraint(equalTo: superview.leadingAnchor),
            trailingAnchor.constraint(equalTo: superview.trailingAnchor),
            bottomAnchor.constraint(equalTo: superview.bottomAnchor)
        ])
    }
    
    func updateLayoutSize( topPadding: CGFloat = 0, leadingPadding: CGFloat = 0,
                           trailingPadding: CGFloat = 0, bottomPadding: CGFloat = 0,of superview: UIView) {
      
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: superview.topAnchor, constant: topPadding),
            leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: topPadding),
            trailingAnchor.constraint(equalTo: superview.trailingAnchor,constant: topPadding),
            bottomAnchor.constraint(equalTo: superview.bottomAnchor,constant: topPadding)
        ])
    }
    
    func addSubViews(_ views: UIView...) {
        for view in views { addSubview(view) }
    } 
    
    // MARK: Shadow Effect
    func setRadiusWithShadow(_ radius: CGFloat? = nil, shadowColor: UIColor = UIColor.darkGray) { // this method adds shadow to right and bottom side of button
        self.layer.cornerRadius = radius ?? self.frame.width / 2
        self.layer.shadowColor = shadowColor.cgColor
        self.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        self.layer.shadowRadius = 1.0
        self.layer.shadowOpacity = 0.7
        self.layer.masksToBounds = false
    }

    func setAllSideShadow(shadowShowSize: CGFloat = 1.0) { // this method adds shadow to allsides
        let shadowSize : CGFloat = shadowShowSize
        let shadowPath = UIBezierPath(rect: CGRect(x: -shadowSize / 2,
                                                   y: -shadowSize / 2,
                                                   width: self.frame.size.width + shadowSize,
                                                   height: self.frame.size.height + shadowSize))
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.darkGray.withAlphaComponent(0.8).cgColor
        self.layer.shadowOffset = CGSize(width: 0.8, height: 0.8)
        self.layer.shadowOpacity = 0.5
        self.layer.shadowPath = shadowPath.cgPath
    }
    
    
    func roundCorners(radius: CGFloat) {
        layer.cornerRadius = radius
        self.clipsToBounds = true
    }
}

/// convert uiview to uiimage
extension UIView {
    
    // Using a function since `var image` might conflict with an existing variable
       // (like on `UIImageView`)
       func asImage() -> UIImage {
           if #available(iOS 10.0, *) {
               let renderer = UIGraphicsImageRenderer(bounds: bounds)
               return renderer.image { rendererContext in
                   layer.render(in: rendererContext.cgContext)
               }
           } else {
               UIGraphicsBeginImageContext(self.frame.size)
               self.layer.render(in:UIGraphicsGetCurrentContext()!)
               let image = UIGraphicsGetImageFromCurrentImageContext()
               UIGraphicsEndImageContext()
               return UIImage(cgImage: image!.cgImage!)
           }
       }
    
    var safeTopAnchor: NSLayoutYAxisAnchor {
        if #available(iOS 11.0, *) {
            return self.safeAreaLayoutGuide.topAnchor
        }
        return self.topAnchor
    }
}
