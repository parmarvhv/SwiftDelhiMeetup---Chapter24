//
//  ImageView.swift
//  AppExtension
//
//  Created by Vaibhav Parmar on 11/12/18.
//  Copyright © 2020 Nickelfox. All rights reserved.
//


import Foundation
import UIKit
import Kingfisher

public class ImageView: UIImageView {
	
    let activity = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.whiteLarge)
	
	public override func awakeFromNib() {
		super.awakeFromNib()
		self.addSubview(self.activity)
	}
	
	public override func layoutSubviews() {
		super.layoutSubviews()
		self.activity.frame = self.bounds
	}
    
    public func setImageFromUrl(url: URL,
                                placeHolder: UIImage? = nil,
                                options: KingfisherOptionsInfo? = nil) {
        self.image = placeHolder
        
        var kfOptions: KingfisherOptionsInfo = [.transition(ImageTransition.fade(1))]
        if let options = options {
            kfOptions.append(contentsOf: options)
        }
        
        self.kf.setImage(with: url,
                         placeholder: placeHolder,
                         options: kfOptions,
                         progressBlock: nil) { _ in
        }
    }
	
	private func startLoader() {
		activity.isHidden = false
		activity.startAnimating()
	}
	
	private func stopLoader() {
		activity.isHidden = true
		activity.stopAnimating()
	}
}
