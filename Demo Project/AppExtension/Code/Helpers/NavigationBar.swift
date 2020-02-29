//
//  NavigationBar.swift
//  AppExtension
//
//  Created by Vaibhav Parmar on 11/12/18.
//  Copyright © 2020 Nickelfox. All rights reserved.
//


import Foundation
import FLUtilities

private let barTintColor = UIColor.green
private let backImage: UIImage?  = nil

class NavigationBar: UINavigationBar {
	
	override func awakeFromNib() {
		super.awakeFromNib()
		if let backImage = backImage {
			self.backIndicatorImage = backImage
			self.backIndicatorTransitionMaskImage = backImage
		}
		self.barTintColor = barTintColor
		self.tintColor = UIColor.white
		self.applyShadow(apply: true)
	}
	
}

extension UINavigationBar {
    
    func removeShadowImage() {
        self.isTranslucent = false
        self.shadowImage = nil
        self.setBackgroundImage(nil, for: .default)
    }
}
