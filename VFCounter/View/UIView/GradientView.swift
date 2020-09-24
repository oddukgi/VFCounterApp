//
//  GradientView.swift
//  DrinkCounter
//
//  Created by Sunmi on 2020/07/15.
//  Copyright © 2020 creativeSun. All rights reserved.
//

// GradientView URL: https://github.com/JNGApura/anansi/blob/b19f4202d0c7eac85fd5b8845508a22ac8221c63/anansi/SupportFiles/Helpers/Extensions/UIView%2B.swift
import UIKit

typealias GradientPoints = (startPoint: CGPoint, endPoint: CGPoint)

enum GradientOrientation {
    case topRightBottomLeft
    case topLeftBottomRight
    case horizontal
    case vertical
    
    var startPoint : CGPoint {
        return points.startPoint
    }
    
    var endPoint : CGPoint {
        return points.endPoint
    }
    
    var points : GradientPoints {
        get {
            switch(self) {
            case .topRightBottomLeft:
                return (CGPoint(x: 0.0,y: 1.0), CGPoint(x: 1.0,y: 0.0))
            case .topLeftBottomRight:
                return (CGPoint(x: 0.0,y: 0.0), CGPoint(x: 1.0,y: 1.0))
            case .horizontal:
                return (CGPoint(x: 0.0,y: 0.5), CGPoint(x: 1.0,y: 0.5))
            case .vertical:
                return (CGPoint(x: 0.0,y: 0.0), CGPoint(x: 0.0,y: 1.0))
            }
        }
    }
}

class GradientView: UIView {
    
    let gradient = CAGradientLayer()
    
    func applyGradient(withColours colours: [UIColor], locations: [NSNumber]? = nil) -> Void {
        
        gradient.frame = self.bounds
        gradient.colors = colours.map { $0.cgColor }
        gradient.locations = locations
        self.layer.insertSublayer(gradient, at: 0)
    }
    
    func applyGradient(withColours colours: [UIColor], gradientOrientation orientation: GradientOrientation, cornerRadius: CGFloat = 0) -> Void {
                
        gradient.frame = self.bounds
        gradient.colors = colours.map { $0.cgColor }
        gradient.startPoint = orientation.startPoint
        gradient.endPoint = orientation.endPoint
        self.layer.insertSublayer(gradient, at: 0)
        self.layer.cornerRadius = 20
        self.clipsToBounds = true
        
    }
}

extension UIView {
    
    func createViewWithBackgroundColor(_ color: UIColor) -> UIView {
        
        let v = UIView()
        v.backgroundColor = color
        return v
    }
    
    func createSpecialViewWithBackgroundColor(_ color: UIColor) -> UIView {
        
        let v = UIView()
        v.backgroundColor = color
        v.layer.cornerRadius = 8.0
        v.clipsToBounds = true
        return v
    }
    
    func shake() {
        
        let a = CABasicAnimation(keyPath: "position")
        a.duration = 0.1
        a.repeatCount = 2
        a.autoreverses = true
        a.fromValue = NSValue(cgPoint: CGPoint(x: self.center.x - 8 / 2.0, y: self.center.y))
        a.toValue = NSValue(cgPoint: CGPoint(x: self.center.x + 8 / 2.0, y: self.center.y))
        
        self.layer.add(a, forKey: "position")
    }
    
    func dropShadow(scale: Bool = true) {
        
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.2
        layer.shadowOffset = CGSize(width: -3, height: 1)
        layer.shadowRadius = 3
        
        layer.shadowPath = UIBezierPath(rect: bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
        
    }
}

extension UIViewController {
    
    func createViewWithBackgroundColor(_ color: UIColor) -> UIView {
        
        let v = UIView()
        v.backgroundColor = color
        return v
    }
}
