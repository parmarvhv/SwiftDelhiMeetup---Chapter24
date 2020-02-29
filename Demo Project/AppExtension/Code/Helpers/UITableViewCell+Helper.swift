//
//  UITableViewCell+Helper.swift
//  AppExtension
//
//  Created by Vaibhav Parmar on 11/12/18.
//  Copyright © 2020 Nickelfox. All rights reserved.
//


import UIKit

extension UITableViewCell {
    var tableView: UITableView? {
        var view: UIView = self
        while let superview = view.superview {
            view = superview
            if let tableView = view as? UITableView {
                return tableView
            }
        }
        return nil
    }
}
