//
//  UIViewController+Helper.swift
//  AppExtension
//
//  Created by Vaibhav Parmar on 11/12/18.
//  Copyright © 2020 Nickelfox. All rights reserved.
//


import Foundation
import SafariServices
import FLUtilities
import AnyErrorKit

// MARK: Safari Services
extension UIViewController {
    func openLink(urlString: String?) {
        guard let urlString = urlString, let url = URL(string: urlString) else { return }
        self.openURL(url: url)
    }
    
    func openURL(url: URL) {
        let safariVC = SFSafariViewController(url: url)
        self.present(safariVC, animated: true, completion: nil)
    }
}


// MARK: AlertView
extension UIViewController {
    
    func handleError(_ error: AnyError) {
        let title = "Oops!"
                
        let ok = "OK"
        self.showAlert(
            title: title,
            message: error.message,
            actionInterfaceList: [
                ActionInterface(title: ok)
            ],
            handler: { _ in
              
        })
    }
    
    func showSuccessAlert(title: String, message: String) {
        let okTitle = "Ok"
        self.showAlert(title: title,
                       message: message,
                       actionInterfaceList: [ActionInterface(title: okTitle)]) { _ in
                        
        }
    }
}
