//
//  AppUtility.swift
//  AppExtension
//
//  Created by Vaibhav Parmar on 11/12/18.
//  Copyright © 2020 Nickelfox. All rights reserved.
//


import Foundation

struct AppUtility {
	static var appVersion: String {
        if let appVersion = Bundle.main
            .infoDictionary!["CFBundleShortVersionString"] as? String {
            return appVersion
        }
        return ""
	}
}
