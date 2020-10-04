//
//  VFTextField.swift
//  VFCounter
//
//  Created by Sunmi on 2020/08/10.
//  Copyright © 2020 creativeSun. All rights reserved.
//

import UIKit

class VFTextField: UITextField {

    @discardableResult
    public func cornerRadius(_ cornerRadius: CGFloat) -> UITextField {
        self.layer.cornerRadius = cornerRadius
        return self
    }
    
    @discardableResult
    public func borderWidth(_ borderWidth: CGFloat) -> UITextField {
        self.layer.borderWidth = borderWidth
        return self
    }
    
    @discardableResult
    public func borderColor(_ color: UIColor) -> UITextField {
        self.layer.borderColor = color.cgColor
        return self
    }
    
    @discardableResult
    public func textColor(_ color: UIColor) -> UITextField {
        self.textColor = color
        return self
    }
 
    @discardableResult
    public func tintColor(_ color: UIColor) -> UITextField {
        self.tintColor = color
        return self
    }
    
    @discardableResult
    public func backgroundColor(_ color: UIColor) -> UITextField {
        self.backgroundColor = color
        return self
    }
        
    @discardableResult
    public func placeholderText(_ message: String) -> UITextField {
        self.placeholder = message
        return self
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        textAlignment      = .center
        adjustsFontSizeToFitWidth = true
        autocorrectionType = .no
        returnKeyType      = .done
        minimumFontSize    = 12
        clearButtonMode    = .whileEditing        
    }
    
}
