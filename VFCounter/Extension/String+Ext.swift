//
//  String+Ext.swift
//  VFCounter
//
//  Created by Sunmi on 2020/08/03.
//  Copyright © 2020 creativeSun. All rights reserved.
//

import UIKit

extension String {
    func format(_ arguments: CVarArg...) -> String {
        let args = arguments.map {
            if let arg = $0 as? Int { return String(arg) }
            if let arg = $0 as? Float { return String(arg) }
            if let arg = $0 as? Double { return String(arg) }
            if let arg = $0 as? Int64 { return String(arg) }
            if let arg = $0 as? String { return String(arg) }
//            if let arg = $0 as? Character { return String(arg) }
            
            return "(null)"
            } as [CVarArg]
        
        return String.init(format: self, arguments: args)
    }
    
   

    /// Generates a `UIImage` instance from this string using a specified
    /// attributes and size.
    ///
    /// - Parameters:
    ///     - attributes: to draw this string with. Default is `nil`.
    ///     - size: of the image to return.
    /// - Returns: a `UIImage` instance from this string using a specified
    /// attributes and size, or `nil` if the operation fails.
    func image(withAttributes attributes: [NSAttributedString.Key: Any]? = nil, size: CGSize? = nil) -> UIImage? {
        let size = size ?? (self as NSString).size(withAttributes: attributes)
        return UIGraphicsImageRenderer(size: size).image { _ in
            (self as NSString).draw(in: CGRect(origin: .zero, size: size),
                                    withAttributes: attributes)
        }
    }

    func imageWith(fontSize: CGFloat = 10, width: CGFloat = 20, height: CGFloat = 20, textColor: UIColor = .black) -> UIImage? {
         let frame = CGRect(x: 0, y: 0, width: width, height: height)
         let nameLabel = UILabel(frame: frame)
         nameLabel.textAlignment = .center
         nameLabel.backgroundColor = .clear
         nameLabel.textColor = textColor
         nameLabel.font = UIFont.systemFont(ofSize: fontSize)
         nameLabel.text = self
         UIGraphicsBeginImageContext(frame.size)
          if let currentContext = UIGraphicsGetCurrentContext() {
             nameLabel.layer.render(in: currentContext)
             let nameImage = UIGraphicsGetImageFromCurrentImageContext()
             return nameImage
          }
          return nil
    }


}
