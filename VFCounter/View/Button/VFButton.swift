//
//  VFButton.swift
//  VFCounter
//
//  Created by Sunmi on 2020/07/21.
//  Copyright © 2020 creativeSun. All rights reserved.
//

import UIKit

class VFButton: UIButton {

    private let targetSize = CGSize(width: 29.0, height: 29.0)

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(backgroundColor: UIColor, title: String) {
        self.init(frame: .zero)
        self.backgroundColor = backgroundColor
        self.setTitle(title, for: .normal)
    }
    
    
    // MARK: Tap Area
    override func setImage(_ image: UIImage?, for state: UIControl.State) {
        guard let image = image else { return }
        self.contentMode = .scaleAspectFit
        super.setImage(image, for: state)
    }
    
    override var alignmentRectInsets: UIEdgeInsets {
        contentEdgeInsets
    }

    // MARK: - custom method    
    private func configure() {
    
        titleLabel!.font = UIFont.preferredFont(forTextStyle: .headline)
        setTitleColor(ColorHex.greyBlue, for: .normal)
    }
    
    func set(backgroundColor: UIColor, title: String = "") {
        self.backgroundColor = backgroundColor
        if !title.isEmpty {
            setTitle(title, for: .normal)
        }
    }
    
    // MARK: ◀︎ (Left Triangle)
    func setLeftTriangle(){
        let heightWidth = (frame.size.width / 2) - 5
        let path = CGMutablePath()

        path.move(to: CGPoint(x: heightWidth/2, y: 0))
        path.addLine(to: CGPoint(x:0, y: heightWidth/2))
        path.addLine(to: CGPoint(x:heightWidth/2, y:heightWidth))
        path.addLine(to: CGPoint(x:heightWidth/2, y:0))

        let shape = CAShapeLayer()
        shape.path = path
        shape.fillColor = ColorHex.darkGreen.cgColor
        self.layer.backgroundColor = UIColor.clear.cgColor
        self.layer.insertSublayer(shape, at: 0)
    }
       
    // MARK: ▶︎ (Right Triangle)
    func setRightTriangle(){
        let heightWidth = (frame.size.width / 2) - 5   //you can use triangleView.frame.size.height
        let path = CGMutablePath()

        path.move(to: CGPoint(x: heightWidth/2, y: 0))
        path.addLine(to: CGPoint(x:heightWidth, y: heightWidth/2))
        path.addLine(to: CGPoint(x:heightWidth/2, y:heightWidth))
        path.addLine(to: CGPoint(x:heightWidth/2, y:0))

        let shape = CAShapeLayer()
        shape.path = path
        shape.fillColor =  ColorHex.darkGreen.cgColor
        self.layer.backgroundColor = UIColor.clear.cgColor
        self.layer.insertSublayer(shape, at: 0)
    }
    
    func addImage(imageName: String, size: CGFloat = 0.0) {
        var image = UIImage(named: imageName)?.imageByMakingWhiteBackgroundTransparent()
        
        if size > 0 {
            image = image?.resized(toWidth: 18)
        }
        self.setImage(image, for: .normal)
    }

    func makeCircle(borderColor: UIColor, borderWidth: CGFloat,name: String ) {
    
        layer.cornerRadius = 0.5 * self.bounds.size.width
        layer.borderColor = borderColor.cgColor
        clipsToBounds = true
        let image = UIImage(named: name)?.transparentImageBackgroundToWhite(color: ColorHex.iceBlue)
        
        self.setImage(image, for: .normal)
    }
    
    func setShadow() {
//        layer.shadowColor = UIColor.darkGray.cgColor
//        layer.shadowOffset = CGSize(width: 0, height: 1.5)
//        layer.shadowRadius = 1.0
//        layer.shadowOpacity = 0.7
//        layer.masksToBounds = false
         setRadiusWithShadow()
    }
    
    func setFont(clr: UIColor, font: UIFont) {
         titleLabel!.font = font
         setTitleColor(clr, for: .normal)
    } 
}
