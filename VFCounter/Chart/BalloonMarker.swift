//
//  BalloonMarker.swift
//  ChartsDemo
//
//  Copyright 2015 Daniel Cohen Gindi & Philipp Jahoda
//  A port of MPAndroidChart for iOS
//  Licensed under Apache License 2.0
//
//  https://github.com/danielgindi/Charts
//

import Foundation
import Charts
#if canImport(UIKit)
    import UIKit
#endif

open class BalloonMarker: MarkerImage
{
    @objc open var color: UIColor
    @objc open var arrowSize = CGSize(width: 15, height: 11)
    @objc open var font: UIFont
    @objc open var textColor: UIColor
    @objc open var insets: UIEdgeInsets
    @objc open var minimumSize = CGSize()

    fileprivate var label: String?
    fileprivate var _labelSize: CGSize = CGSize()
    fileprivate var _paragraphStyle: NSMutableParagraphStyle?
    fileprivate var _drawAttributes = [NSAttributedString.Key: Any]()
    let shadowColor = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 0.5)

    @objc public init(color: UIColor, font: UIFont, textColor: UIColor, insets: UIEdgeInsets) {
        self.color = color
        self.font = font
        self.textColor = textColor
        self.insets = insets

        _paragraphStyle = NSParagraphStyle.default.mutableCopy() as? NSMutableParagraphStyle
        _paragraphStyle?.alignment = .center
        super.init()
    }

    open override func offsetForDrawing(atPoint point: CGPoint) -> CGPoint {
        var offset = self.offset
        var size = self.size

        if size.width == 0.0 && image != nil {
            size.width = image!.size.width
        }
        if size.height == 0.0 && image != nil {
            size.height = image!.size.height
        }

        let width = size.width
        let height = size.height
        let padding: CGFloat = 8.0

        var origin = point
        origin.x -= width / 2
        origin.y -= height

        if origin.x + offset.x < 0.0 {
            offset.x = -origin.x + padding
        } else if let chart = chartView,
            origin.x + width + offset.x > chart.bounds.size.width {
            offset.x = chart.bounds.size.width - origin.x - width - padding
        }

        if origin.y + offset.y < 0 {
            offset.y = height + padding
        } else if let chart = chartView,
            origin.y + height + offset.y > chart.bounds.size.height {
            offset.y = chart.bounds.size.height - origin.y - height - padding
        }

        return offset
    }

    // rounded ballonmarker
    // this code comes from https://github.com/danielgindi/Charts/issues/3276
    open override func draw(context: CGContext, point: CGPoint) {
        guard let label = label else { return }

        let offset = self.offsetForDrawing(atPoint: point)
        let size = self.size

        var rect = CGRect(
            origin: CGPoint(
                x: point.x + offset.x,
                y: point.y + offset.y),
            size: size)
        rect.origin.x -= size.width / 2.0
        rect.origin.y -= size.height

        context.saveGState()
        context.setFillColor(color.cgColor)

        setShadow(context: context, color: shadowColor, width: 0, height: 2, blur: 3.0)

        if offset.y > 0 {

            context.beginPath()
            let rect2 = CGRect(x: rect.origin.x, y: rect.origin.y + arrowSize.height, width: rect.size.width, height: rect.size.height - arrowSize.height)
            let clipPath = UIBezierPath(roundedRect: rect2, cornerRadius: 5.0).cgPath
            context.addPath(clipPath)
            context.closePath()
            context.fillPath()

            // arraow vertex
            context.beginPath()
            let p1 = CGPoint(x: rect.origin.x + rect.size.width / 2.0 - arrowSize.width / 2.0, y: rect.origin.y + arrowSize.height + 1)
            context.move(to: p1)

            context.addLine(to: CGPoint(x: p1.x + arrowSize.width, y: p1.y))
            context.addLine(to: CGPoint(x: point.x, y: point.y))
            context.addLine(to: p1)

            context.fillPath()
            setShadow(context: context, color: .clear)

        } else {
            context.beginPath()
            let rect2 = CGRect(x: rect.origin.x, y: rect.origin.y, width: rect.size.width, height: rect.size.height - arrowSize.height)
            let clipPath = UIBezierPath(roundedRect: rect2, cornerRadius: 5.0).cgPath
            context.addPath(clipPath)
            context.closePath()
            context.fillPath()

            // arraow vertex
            context.beginPath()
            let p1 = CGPoint(x: rect.origin.x + rect.size.width / 2.0 - arrowSize.width / 2.0, y: rect.origin.y + rect.size.height - arrowSize.height - 1)
            context.move(to: p1)
            context.addLine(to: CGPoint(x: p1.x + arrowSize.width, y: p1.y))
            context.addLine(to: CGPoint(x: point.x, y: point.y))
            context.addLine(to: p1)

            context.fillPath()
            setShadow(context: context, color: shadowColor, width: 0, height: 2, blur: 3.0)

        }

        if offset.y > 0 {
            rect.origin.y += self.insets.top + arrowSize.height
        } else {
            rect.origin.y += self.insets.top
        }

        rect.size.height -= self.insets.top + self.insets.bottom
        UIGraphicsPushContext(context)
        label.draw(in: rect, withAttributes: _drawAttributes)
        UIGraphicsPopContext()
        context.restoreGState()
    }

    open override func refreshContent(entry: ChartDataEntry, highlight: Highlight) {
        let value = Int(entry.y)
        setLabel(String("\(value) g"))
    }

    @objc open func setLabel(_ newLabel: String) {
        label = newLabel

        let shadow = NSShadow()
        shadow.shadowColor = UIColor.white

        _drawAttributes.removeAll()
        _drawAttributes[.font] = self.font
        _drawAttributes[.paragraphStyle] = _paragraphStyle
        _drawAttributes[.foregroundColor] = self.textColor
        _drawAttributes[.shadow] = shadow   // remove font shadow

        _labelSize = label?.size(withAttributes: _drawAttributes) ?? CGSize.zero

        var size = CGSize()
        size.width = _labelSize.width + self.insets.left + self.insets.right
        size.height = _labelSize.height + self.insets.top + self.insets.bottom
        size.width = max(minimumSize.width, size.width)
        size.height = max(minimumSize.height, size.height)

        self.size = size
    }

    func setShadow(context: CGContext, color: UIColor, width: CGFloat = 0,
                   height: CGFloat = 0, blur: CGFloat = 0) {

        // set shadow
        let shadowColor = color
        context.setShadow(
        offset: CGSize(width: 0, height: 2),
        blur: blur,
        color: shadowColor.cgColor)
    }
}
