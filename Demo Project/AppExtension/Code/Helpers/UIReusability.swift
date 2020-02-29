//
//  UIReusability.swift
//  AppExtension
//
//  Created by Vaibhav Parmar on 11/12/18.
//  Copyright © 2020 Nickelfox. All rights reserved.
//


import Foundation
import UIKit

// MARK: - HeightProvider
protocol HeightProvider {
    var height: CGFloat { get }
}

// MARK: - ReuseIdentifierProvider
protocol ReuseIdentifierProvider {
    var reuseIdentifier: String { get }
}

// MARK: - StaticReuseIdentifierProvider
protocol StaticReuseIdentifierProvider {
    static var reuseIdentifier: String { get }
}

// MARK: - NibNameProvider
protocol NibNameProvider {
    static var nibName: String { get }
}

// MARK: - SegueIdentifierProvider
protocol SegueIdentifierProvider {
    var segueIdentifier: String { get }
}

extension UIView: NibNameProvider {
    static var nibName: String { return String(describing: self).components(separatedBy: ".").last! }
}

extension UIView: StaticReuseIdentifierProvider {
    static var reuseIdentifier: String { return String(describing: self).components(separatedBy: ".").last! }
}

extension UICollectionView {
    func registerCell<T: NibNameProvider & StaticReuseIdentifierProvider>(_ cellType: T.Type) {
        self.register(UINib(nibName: cellType.nibName, bundle: nil), forCellWithReuseIdentifier: cellType.reuseIdentifier)
    }
    
    func registerHeader<T: NibNameProvider & StaticReuseIdentifierProvider>(_ headerType: T.Type) {
        self.register(
            UINib(nibName: headerType.nibName, bundle: nil),
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: headerType.reuseIdentifier)
    }
    
    func registerFooter<T: NibNameProvider & StaticReuseIdentifierProvider>(_ headerType: T.Type) {
        self.register(
            UINib(nibName: headerType.nibName, bundle: nil),
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
            withReuseIdentifier: headerType.reuseIdentifier)
    }
    
    func dequeueCell<T: NibNameProvider & StaticReuseIdentifierProvider>(_ headerType: T.Type, for indexPath: IndexPath) -> T {
        //swiftlint:disable:next force_cast
        let cell = self.dequeueReusableCell(withReuseIdentifier: headerType.reuseIdentifier, for: indexPath) as! T
        return cell
    }
}

extension UITableView {
    func registerCell<T: NibNameProvider & StaticReuseIdentifierProvider>(_ cellType: T.Type) {
        self.register(UINib(nibName: cellType.nibName, bundle: nil), forCellReuseIdentifier: cellType.reuseIdentifier)
    }
    
    func registerHeaderFooter<T: NibNameProvider & StaticReuseIdentifierProvider>(_ headerType: T.Type) {
        self.register(UINib(nibName: headerType.nibName, bundle: nil), forHeaderFooterViewReuseIdentifier: headerType.reuseIdentifier)
    }
    
    func dequeueCell<T: NibNameProvider & StaticReuseIdentifierProvider>(_ headerType: T.Type, for indexPath: IndexPath) -> T {
        //swiftlint:disable:next force_cast
        let cell = self.dequeueReusableCell(withIdentifier: headerType.reuseIdentifier, for: indexPath) as! T
        return cell
    }
    
}
