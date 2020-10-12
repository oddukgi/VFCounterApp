//
//  UITextView+Ext.swift
//  VFCounter
//
//  Created by Sunmi on 2020/09/27.
//  Copyright © 2020 creativeSun. All rights reserved.
//

import UIKit

extension UITextView {

    private class PlaceholderLabel: UILabel { }

    private var placeholderLabel: PlaceholderLabel {
        if let label = subviews.compactMap({ $0 as? PlaceholderLabel }).first {
            return label
        } else {
            let label = PlaceholderLabel(frame: .zero)
            label.font = font
            addSubview(label)
            resizePlaceholder()
            observeProperties()
            return label
        }
    }

    private func observeProperties() {
        let observingKeys = ["frame", "bounds"]
        for key in observingKeys {
            addObserver(self, forKeyPath: key, options: [.new], context: nil)
        }
    }

    //  swiftlint:disable:next block_based_kvo
    public override func observeValue(
        forKeyPath keyPath: String?,
        of object: Any?,
        change: [NSKeyValueChangeKey: Any]?,
        context: UnsafeMutableRawPointer?
    ) {
        resizePlaceholder()
    }

    private func resizePlaceholder() {
        let lineFragmentPadding = textContainer.lineFragmentPadding
        let xPos: CGFloat = lineFragmentPadding + textContainerInset.left

        print("lineFragmentPadding: \(lineFragmentPadding)")
        print("textContainerInset.left: \(textContainerInset.left)")
        print("x: \(xPos)")

        let yPos: CGFloat = textContainerInset.top
        let width: CGFloat = bounds.width - xPos - lineFragmentPadding - textContainerInset.right
        let height: CGFloat = placeholderLabel.sizeThatFits(CGSize(width: width, height: 0)).height
        placeholderLabel.frame = CGRect(x: xPos, y: yPos, width: width, height: height)
    }

    @IBInspectable
    public var placeholder: String {
        get {
            return subviews.compactMap({ $0 as? PlaceholderLabel }).first?.text ?? ""
        }
        set {
            let placeholderLabel = self.placeholderLabel
            placeholderLabel.text = newValue
            placeholderLabel.numberOfLines = 0
            resizePlaceholder()
            textStorage.delegate = self
        }
    }

    @IBInspectable
    public var placeholderColor: UIColor? {
        get {
            return placeholderLabel.textColor
        }
        set {
            placeholderLabel.textColor = newValue
        }
    }
}

extension UITextView: NSTextStorageDelegate {
    public func textStorage(
        _ textStorage: NSTextStorage,
        didProcessEditing editedMask: NSTextStorage.EditActions,
        range editedRange: NSRange,
        changeInLength delta: Int
    ) {
        if editedMask.contains(.editedCharacters) {
            placeholderLabel.isHidden = !text.isEmpty
        }
    }
}
