//
//  CustomSlider.swift
//  VFCounter
//
//  Created by Sunmi on 2020/08/08.
//  Copyright © 2020 creativeSun. All rights reserved.
//

import UIKit

protocol SliderUpdateDelegate: AnyObject {
    func sliderTouch(value: Float, tag: Int)
    func sliderValueChanged(value: Float, tag: Int)
}


class CustomSlider: UISlider {

    @IBInspectable var trackHeight: CGFloat = 4
    @IBInspectable var thumbRadius: CGFloat = 20

    @discardableResult
    public func isContinuous(_ value: Bool) -> UISlider {
        self.isContinuous = value
        return self
    }

    @discardableResult
    public func minimumTrackTintColor(_ color: UIColor) -> UISlider {
        self.minimumTrackTintColor = color
        return self
    }

    @discardableResult
    public func maximumTrackTintColor(_ color: UIColor) -> UISlider {
        self.maximumTrackTintColor = color
        return self
    }

    @discardableResult
    public func thumbTintColor(_ color: UIColor) -> UISlider {
        self.thumbTintColor = color
        return self
    }

    @discardableResult
    public func values(min: Float = 0, max: Float = 1, current: Float = 0) -> UISlider {
        self.minimumValue = min
        self.maximumValue = max
        self.value = current
        return self
    }
    
    weak var delegate: SliderUpdateDelegate?
    private var step: Float = 1
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    convenience init(step: Float) {
        self.init()
        self.step = step
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Custom thumb view which will be converted to UIImage
     // and set as thumb. You can customize it's colors, border, etc.
     private lazy var thumbView: UIView = {
         let thumb = UIView()
         thumb.backgroundColor = .white//thumbTintColor
         thumb.layer.borderWidth = 0.4
         thumb.layer.borderColor = UIColor.darkGray.cgColor
         return thumb
     }()

     override func awakeFromNib() {
         super.awakeFromNib()
         let thumb = thumbImage(radius: thumbRadius)
         setThumbImage(thumb, for: .normal)
     }

     private func thumbImage(radius: CGFloat) -> UIImage {
         // Set proper frame
         // y: radius / 2 will correctly offset the thumb

         thumbView.frame = CGRect(x: 0, y: radius / 2, width: radius, height: radius)
         thumbView.layer.cornerRadius = radius / 2

         // Convert thumbView to UIImage
         // See this: https://stackoverflow.com/a/41288197/7235585

         let renderer = UIGraphicsImageRenderer(bounds: thumbView.bounds)
         return renderer.image { rendererContext in
             thumbView.layer.render(in: rendererContext.cgContext)
         }
     }
    
    override func trackRect(forBounds bounds: CGRect) -> CGRect {
        // Set custom track height
        // As seen here: https://stackoverflow.com/a/49428606/7235585
        var newRect = super.trackRect(forBounds: bounds)
        newRect.size.height = trackHeight
        return newRect
    }
    
    func configure() {
      addTarget(self, action: #selector(valueChangedSlider(_:)), for: .valueChanged)
      addTarget(self, action: #selector(tocuhSlider(_:)), for: .touchUpInside)
      addTarget(self, action: #selector(tocuhSlider(_:)), for: .touchUpOutside)
      addTarget(self, action: #selector(tocuhSlider(_:)), for: .touchCancel)
    }

    @objc func valueChangedSlider(_ sender: UISlider) {
     
        //round : 소수점 이하 반올림
        let roundedValue = round(sender.value / step) * step
        sender.value = roundedValue
        
        print("Slider Value: \(roundedValue)")      
        delegate?.sliderValueChanged(value: sender.value, tag: sender.tag)
    }
    
    @objc func tocuhSlider(_ sender: UISlider) {
        delegate?.sliderTouch(value: sender.value, tag: sender.tag)
    }
}


