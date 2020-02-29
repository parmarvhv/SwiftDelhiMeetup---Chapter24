//
//  UITextField+Helper.swift
//  AppExtension
//
//  Created by Vaibhav Parmar on 11/12/18.
//  Copyright © 2020 Nickelfox. All rights reserved.
//


import UIKit

extension UITextField {
    @IBInspectable var placeholderColor: UIColor? {
        get {
            return self.placeholderColor
        }
        set {
            guard let placeholder = self.placeholder,
                let placeholderColor = newValue else { return }
            let foregroundAttribute = [NSAttributedString.Key.foregroundColor: placeholderColor]
            self.attributedPlaceholder = NSAttributedString(string: placeholder,
                                                            attributes: foregroundAttribute)
        }
    }
}
