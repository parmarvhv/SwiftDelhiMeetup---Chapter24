//
//  Storyboards.swift
//  AppExtension
//
//  Created by Vaibhav Parmar on 11/12/18.
//  Copyright © 2020 Nickelfox. All rights reserved.
//


import Foundation
import FLUtilities

enum Storyboard: String {
    case main = "Main"
    
    var name: String {
        return self.rawValue
    }
}

extension UIViewController {
    static var storyboardId: String {
        return self.className()
    }
}
