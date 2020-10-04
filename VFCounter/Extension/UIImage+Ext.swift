//
//  UIImage+Ext.swift
//  DrinkCounter
//
//  Created by Sunmi on 2020/07/14.
//  Copyright © 2020 creativeSun. All rights reserved.
//

import UIKit


extension UIImage {
    
    // 이미지 배경을 투명하게 바꾸는 함수
    func imageByMakingWhiteBackgroundTransparent() -> UIImage? {

         let image = UIImage(data: self.jpegData(compressionQuality: 1.0)!)!
         let rawImageRef: CGImage = image.cgImage!
        // 색상 입히기
         let colorMasking: [CGFloat] = [222, 255, 222, 255, 222, 255]
         UIGraphicsBeginImageContext(image.size)            // 비트맵 이미지 생성

         let maskedImageRef = rawImageRef.copy(maskingColorComponents: colorMasking)
         UIGraphicsGetCurrentContext()?.translateBy(x: 0.0,y: image.size.height)
         UIGraphicsGetCurrentContext()?.scaleBy(x: 1.0, y: -1.0)
         UIGraphicsGetCurrentContext()?.draw(maskedImageRef!, in: CGRect.init(x: 0, y: 0, width: image.size.width, height: image.size.height))
         let result = UIGraphicsGetImageFromCurrentImageContext();
         UIGraphicsEndImageContext();
         return result

     }
    
    func transparentImageBackgroundToWhite(color: UIColor) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        let imageRect: CGRect = CGRect(x: 0.0, y: 0.0, width: self.size.width, height: self.size.height)
        let ctx: CGContext = UIGraphicsGetCurrentContext()!
        // Draw a white background (for white mask)
        ctx.setFillColor(color.cgColor)
      //  ctx.setFillColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        ctx.fill(imageRect)
        // Apply the source image's alpha
        self.draw(in: imageRect, blendMode: .normal, alpha: 1.0)
        let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
    
   func resized(toWidth width: CGFloat) -> UIImage? {
       let canvasSize = CGSize(width: width, height: CGFloat(ceil(width/size.width * size.height)))
       UIGraphicsBeginImageContextWithOptions(canvasSize, false, scale)
       defer { UIGraphicsEndImageContext() }
       draw(in: CGRect(origin: .zero, size: canvasSize))
       return UIGraphicsGetImageFromCurrentImageContext()
   }

    func getImageWithColor(color: UIColor, size: CGSize) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        color.setFill()
        UIRectFill(rect)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
}


// MARK: Create watermark text
// refer to : https://stackoverflow.com/a/41524358

