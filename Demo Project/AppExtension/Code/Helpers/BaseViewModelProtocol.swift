//
//  BaseViewModelProtocol.swift
//  AppExtension
//
//  Created by Vaibhav Parmar on 27/02/20.
//  Copyright © 2020 Nickelfox. All rights reserved.
//

import Foundation
import FLUtilities
import AnyErrorKit
import Model

protocol BaseViewModelProtocol: class {
    func showAlert(message: String)
}

extension UIViewController: BaseViewModelProtocol {
    
    func showAlert(message: String) {
        self.showAlert(message: message) {
        }
    }
    
    func showAlert(title: String? = nil, message: String?, actionTitle: String = "Ok", actionBlock: @escaping (() -> Void)) {
        let list = [ActionInterface(title: actionTitle)]
        self.showAlert(
            title: title,
            message: message,
            actionInterfaceList: list) { actionInterface in
                if actionInterface.title == actionTitle {
                    actionBlock()
                }
        }
    }
    
}
