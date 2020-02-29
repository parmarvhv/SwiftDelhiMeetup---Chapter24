//
//  CollectionViewCell.swift
//  AppExtension
//
//  Created by Vaibhav Parmar on 11/12/18.
//  Copyright © 2020 Nickelfox. All rights reserved.
//


import UIKit

class CollectionViewCell: UICollectionViewCell {

	var item: Any? {
		didSet {
			self.configure(self.item)
		}
	}
	
    weak var delegate: NSObjectProtocol?
	
	func configure(_ item: Any?) {
		
	}
	
}

class CollectionReusableView: UICollectionReusableView {
	
	var item: Any? {
		didSet {
			self.configure(self.item)
		}
	}
	
    weak var delegate: NSObjectProtocol?
	
	func configure(_ item: Any?) {
		
	}
	
}
