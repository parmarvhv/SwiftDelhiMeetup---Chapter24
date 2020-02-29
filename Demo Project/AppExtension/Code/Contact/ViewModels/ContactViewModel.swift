//
//  ContactViewModel.swift
//  AppExtension
//
//  Created by Vaibhav Parmar on 27/02/20.
//  Copyright © 2020 Nickelfox. All rights reserved.
//

import Foundation
import ReactiveSwift
import Model

protocol ContactViewModelProtocol: BaseViewModelProtocol {
    func showOpenSettingsAlert()
}

class ContactViewModel {
    
    var view: ContactViewModelProtocol
    var loading = MutableProperty<Bool>(false)
    var disposable = CompositeDisposable([])
    var sectionModels = MutableProperty<[SectionModel]>([])
    
    init(_ view: ContactViewModelProtocol) {
        self.view = view
        self.requestContactAccess()
        self.disposable += DataModel.shared.phoneBookSyncd.producer.startWithValues { success in
            if success {
                ContactsUtility.shared.getContacts { contacts in
                    self.prepareModels(for: contacts)
                }
            }
        }
    }
    
    deinit {
        self.disposable.dispose()
    }
    
    private func prepareModels(for contacts: [Contact]) {
        self.sectionModels.value = [SectionModel(cellModels: contacts.map {
            ContactTableCellModel(name: $0.name ?? "")
        })]
    }
    
    func requestContactAccess() {
        if ContactsUtility.shared.isAccessAuthorised {
            ContactsUtility.shared.syncPhoneBook()
            return
        }
        
        ContactsUtility.shared.requestedForAccess { isSuccess in
            if !isSuccess { self.view.showOpenSettingsAlert() }
        }
    }
    
}

// MARK: ContactViewControllerProtocol
extension ContactViewModel: ContactViewControllerProtocol {
    
    var sectionCount: Int {
        return self.sectionModels.value.count
    }
    
    func rowsCount(at section: Int) -> Int {
        return self.sectionModels.value[section].cellModels.count
    }
    
    func cellModel(at indexPath: IndexPath) -> Any {
        return self.sectionModels.value[indexPath.section].cellModels[indexPath.row]
    }
    
}
