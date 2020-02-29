//
//  UIView+Helper.swift
//  AppExtension
//
//  Created by Vaibhav Parmar on 11/12/18.
//  Copyright © 2020 Nickelfox. All rights reserved.
//


import UIKit

extension UIView {
	
	@IBInspectable var borderWidth: CGFloat {
		get {
			return 1.0
		} set {
			self.layer.borderWidth = newValue
		}
	}
	
	@IBInspectable var borderColor: UIColor {
		get {
			return UIColor.black
		} set {
			self.layer.borderColor = newValue.cgColor
		}
	}
	
	@IBInspectable var cornerRadius: CGFloat {
		get {
			return 1.0
		} set {
			self.layer.cornerRadius = newValue
			self.layer.masksToBounds = true
		}
	}
	
    @IBInspectable var shadowColor: UIColor {
        get {
            return UIColor.clear
        } set {
            self.layer.masksToBounds = false
            self.layer.shadowColor = newValue.cgColor
        }
    }
    
    @IBInspectable var shadowRadius: CGFloat {
        get {
            return self.layer.shadowRadius
        } set {
            self.layer.shadowRadius = newValue
            self.layer.masksToBounds = false
        }
    }
    
    @IBInspectable var shadowOffset: CGSize {
        get {
            return self.layer.shadowOffset
        } set {
            self.layer.shadowOffset = newValue
            self.layer.masksToBounds = false
        }
    }
    
    @IBInspectable var shadowOpacity: Float {
        get {
            return self.layer.shadowOpacity
        } set {
            self.layer.shadowOpacity = newValue
            self.layer.masksToBounds = false
        }
    }

	func flipView() {
        let transitionOptions: UIView.AnimationOptions = [.transitionFlipFromRight, .showHideTransitionViews]
		
		UIView.transition(with: self, duration: 1.0, options: transitionOptions, animations: {
			self.isHidden = true
		}, completion: nil)
		
		UIView.transition(with: self, duration: 1.0, options: transitionOptions, animations: {
			self.isHidden = false
		}, completion: nil)
	}

}
