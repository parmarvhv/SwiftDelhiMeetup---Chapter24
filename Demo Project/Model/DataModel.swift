//
//  DataModel.swift
//  Model
//
//  Created by Vaibhav Parmar on 27/02/20.
//  Copyright © 2020 Nickelfox. All rights reserved.
//

import Foundation
import ReactiveSwift

struct DataModelKey {
    static let contactSyncd = "ContactSyncd"
}

public class DataModel {
    
    public static let shared = DataModel()
    private let userDefaults = UserDefaults.standard
    private let disposable = CompositeDisposable()
    
    init() {
        self.disposable += self.phoneBookSyncd.producer.startWithValues { newValue in
            DataModel.contactSyncd = newValue
        }
    }
    
    public var isContactSyncInProgress: Bool = false
    
    public var phoneBookSyncd = MutableProperty<Bool>(DataModel.contactSyncd)
    
}

extension DataModel {
    
    private static var contactSyncd: Bool {
        get {
            return UserDefaults.standard.bool(forKey: DataModelKey.contactSyncd)
        } set {
            UserDefaults.standard.set(newValue, forKey: DataModelKey.contactSyncd)
            UserDefaults.standard.synchronize()
        }
    }
    
}
