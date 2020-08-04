//
//  VFScrollRulerView.swift
//  VFCounter
//
//  Created by Sunmi on 2020/08/03.
//  Copyright © 2020 creativeSun. All rights reserved.
//

import UIKit

fileprivate let textRulerFont  = NanumSquareRound.regular.style(sizeOffset: 11)
fileprivate let rulerLineColor = RulerColor.lineColor

fileprivate let rulerLong        = 40
fileprivate let rulerShort       = 30

fileprivate let textColorWhiteAlpha: CGFloat = 1.0

// MARK: draw triangle
class VFTriangleView: UIView {

    var triangleColor: UIColor?
    let triangleWidth    = 16
    override func draw(_ rect: CGRect) {
        UIColor.clear.set()
        UIRectFill(self.bounds)
        
        let context = UIGraphicsGetCurrentContext()!
        
        context.beginPath()
        context.move(to: CGPoint.init(x: 0, y: 0))
        context.addLine(to: CGPoint(x: triangleWidth, y: 0))
        context.addLine(to: CGPoint(x: triangleWidth/2, y: triangleWidth/2))
        context.setLineCap(CGLineCap.butt)
        context.setLineJoin(CGLineJoin.bevel)
        context.closePath()
        
        triangleColor?.setFill()
        triangleColor?.setStroke()
        
        context.drawPath(using: CGPathDrawingMode.fillStroke)
    }
}

class VFRulerView: UIView {
    var minValue: Float = 0.0
    var maxValue: Float = 0.0
    var unit: String = ""
    var step: Float = 0.0
    var betweenNumber = 0
    let rulerGap         = 12
    
    override func draw(_ rect: CGRect) {
        let startX: CGFloat = 0
        let lineCenterX     = CGFloat(rulerGap)
        let shortLineY      = rect.size.height - CGFloat(rulerLong)
        let longLineY       = rect.size.height - CGFloat(rulerShort)
        let topY: Int   = 0
     
        let context = UIGraphicsGetCurrentContext()!
        context.setLineWidth(1)
        context.setLineCap(CGLineCap.butt)
        context.setStrokeColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 1.0)
        
        for i in 0...betweenNumber {
            print(i)
            
            let x = Int(lineCenterX) * i
            context.move(to: CGPoint(x: x, y: topY))
 
            if i % betweenNumber == 0 {
                let num = Float(i) * step + minValue
                print("Unit: \(unit)")
                
                let newNum = Int(num)
                var numStr = String("%@%@").format(newNum, unit)
                
                if num > 1000000 {
                    numStr = String("%@%@").format(num/1000,unit)
                }
                
                print(i, step, minValue)
                
                let attribute: Dictionary = [NSAttributedString.Key
                    .font: textRulerFont, NSAttributedString.Key.foregroundColor: UIColor(white: textColorWhiteAlpha, alpha: 1.0)]
                
                
                let width = numStr.boundingRect(with: CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude),
                               options: NSStringDrawingOptions.usesLineFragmentOrigin,
                               attributes: attribute,context: nil).size.width
                
                
                numStr.draw(in: CGRect(x: startX + lineCenterX * CGFloat(i) - (width/2), y: longLineY + 10, width: width, height: 14), withAttributes: attribute)
                
                context.addLine(to: CGPoint.init(x: startX + lineCenterX * CGFloat(i), y: longLineY))
                
            }else{
                context.addLine(to: CGPoint.init(x: startX + lineCenterX * CGFloat(i), y: shortLineY))
            }
            
            context.strokePath()

        }
    }
    
}


class VFHeaderRulerView: UIView {
    var headerMinValue = 0
    var headerUnit = ""
    
    override func draw(_ rect: CGRect) {
        let longLineY = rect.size.height - CGFloat(rulerShort)
        let context = UIGraphicsGetCurrentContext()!
        context.setStrokeColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 1.0)
        context.setLineWidth(1.0)
        context.setLineCap(CGLineCap.butt)
        
        context.move(to: CGPoint(x: rect.size.width, y: 0))
        var numStr: NSString = NSString(format: "%d%@", headerMinValue,headerUnit)
        
        if headerMinValue > 1000000 {
            numStr = NSString(format:"%d%@", headerMinValue/10000, headerUnit)
        }
        
         let attribute:Dictionary = [NSAttributedString.Key.font:textRulerFont,
                                     NSAttributedString.Key.foregroundColor:UIColor(white: textColorWhiteAlpha, alpha: 1.0)]
        
        let width = numStr.boundingRect(with: CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude), options: NSStringDrawingOptions(rawValue: 0), attributes: attribute, context: nil).size.width
        
        let xPos = rect.size.width - (width/2)
        let yPos = longLineY + 10
        numStr.draw(in: CGRect(x: xPos, y: yPos, width: width, height: 14), withAttributes: attribute)
        
        context.addLine(to: CGPoint(x: rect.size.width, y: longLineY))
        context.strokePath()
        
    }
}

class VFFooterRulerView: UIView {
    var footerMaxValue = 0
    var footerUnit = ""
    
    override func draw(_ rect: CGRect) {
        let longLineY = Int(rect.size.height) - rulerShort
        let context = UIGraphicsGetCurrentContext()!
        context.setStrokeColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 1.0)
        context.setLineWidth(1.0)
        context.setLineCap(CGLineCap.butt)
        context.move(to: CGPoint(x: 0, y: 0))
        
        var numStr: NSString = NSString(format: "%d%@", footerMaxValue, footerUnit)
        if footerMaxValue > 1000000 {
            numStr = NSString(format: "%d%@", footerMaxValue/10000, footerUnit)
        }
        
        let attribute:Dictionary = [NSAttributedString.Key.font:textRulerFont,NSAttributedString.Key.foregroundColor:UIColor.init(white: textColorWhiteAlpha, alpha: 1.0)]
        let width = numStr.boundingRect(with: CGSize.init(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude), options: NSStringDrawingOptions(rawValue: 0), attributes: attribute, context: nil).size.width
        numStr.draw(in: CGRect.init(x: -(width/2), y: CGFloat(longLineY+10), width: width, height:CGFloat(14)), withAttributes: attribute)
        context.addLine(to: CGPoint.init(x: 0, y: longLineY))
        context.strokePath()
    }
}
