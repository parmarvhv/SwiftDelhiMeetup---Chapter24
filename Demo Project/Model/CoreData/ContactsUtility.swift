//
//  ContactsUtility.swift
//  Model
//
//  Created by Vaibhav Parmar on 27/02/20.
//  Copyright © 2020 Nickelfox. All rights reserved.
//

import Foundation
import Contacts
import ContactsUI
import ReactiveSwift

public class PhonebookContact: NSObject {
    public var name: String?
    public var phone: String?
    
    public init(name: String?, phone: String?) {
        self.name = name
        self.phone = phone
    }
}

public class ContactsUtility: NSObject {
    
    let contactStore = CNContactStore()
    let contactList = NSMutableArray()
    public static let shared = ContactsUtility()
    var disposable = CompositeDisposable([])
    
    private override init() {
        super.init()
    }
    
    deinit {
        self.disposable.dispose()
    }
    
    public var isAccessAuthorised: Bool {
        return CNContactStore.authorizationStatus(for: .contacts) == .authorized
    }
    
    func getContact() -> [CNContact] {
        var results: [CNContact] = []
        let keyToContactFetch = [CNContactGivenNameKey as CNKeyDescriptor,
                                 CNContactFamilyNameKey as CNKeyDescriptor,
                                 CNContactPhoneNumbersKey as CNKeyDescriptor]
        
        let fetchRequest = CNContactFetchRequest(keysToFetch: keyToContactFetch)
        fetchRequest.sortOrder = CNContactSortOrder.userDefault
        do {
            try self.contactStore.enumerateContacts(with: fetchRequest, usingBlock: { (contact, _) in
                print(contact.phoneNumbers.first?.value ?? "no")
                results.append(contact)
            })
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        return results
    }
    
    /// The method request asks for permission to access contacts
    public func requestedForAccess(completion: @escaping (_ granted: Bool) -> Void) {
        
        switch CNContactStore.authorizationStatus(for: .contacts) {
        case .authorized: completion(true)
        case .denied: completion(false)
        case .notDetermined, .restricted:
            self.contactStore.requestAccess(for: .contacts) { (granted, _) in
                DispatchQueue.main.async {
                    if granted {
                        self.addPhoneBookUpdatedObserver()
                        self.syncPhoneBook()
                    }
                    completion(granted)
                }
            }
        @unknown default: completion(false)
        }
    }
    
    public func syncPhoneBook() {
        DataModel.shared.isContactSyncInProgress = false
        self.syncPhoneBookContactsWithLocalDB { success in
            
            if !success { return }
            
            DataModel.shared.phoneBookSyncd.value = success
            
            if let contactList = CoreDataManager.shared.getContacts() as? [Contact] {
                let phoneNumbers = contactList.map { $0.phone ?? "" }.filter { !$0.isEmpty }
                //self.disposable += self.syncContactsAction.apply(phoneNumbers).start()
            }
        }
    }
    
    public func syncPhoneBookContactsWithLocalDB(completion: @escaping (_ success: Bool) -> Void) {
        
        if DataModel.shared.isContactSyncInProgress { return completion(false) }
        DataModel.shared.isContactSyncInProgress = true
        
        self.contactDictonaryList { _ in
            DispatchQueue.global(qos: .background).async {
                
                guard let contactList = CoreDataManager.shared.getContacts() else { completion(false); return }
                
                // swiftlint:disable:next empty_count
                guard contactList.count > 0 else {
                    //Save all new contact in db
                    self.saveNewContactInDb(self.contactList) { success in
                        completion(success)
                    }
                    return
                }
                
                //Check for require update contact in db
                let tempContactList = self.contactList
                for contact in contactList {
                    if let cdContact = contact as? Contact {
                        if let phone = cdContact.phone, !phone.isEmpty {
                            let filteredContacts = self.contactList.filter({ contact in
                                if let contact = contact as? PhonebookContact {
                                    return contact.phone == phone
                                }
                                return false
                            })
                            
                            // swiftlint:disable:next empty_count
                            if filteredContacts.count > 0,
                                let filteredContact = filteredContacts.first as? PhonebookContact {
                                //Update contact if it was updated in contact directory
                                if filteredContact.name != cdContact.name {
                                    cdContact.name = filteredContact.name ?? ""
                                    CoreDataManager.shared.saveContextInBG()
                                    print("Contact Updated from db: \(cdContact.description)")
                                }
                                tempContactList.remove(filteredContacts.first as Any)
                                
                            } else {
                                // This contact is not available in new contact list i.e this
                                // contact is deleted from contact directory so we need to delete from db.
                                print("Contact deleted from db: \(cdContact.description)")
                                CoreDataManager.shared.deleteObject(object: cdContact)
                            }
                        }
                    }
                }
                // swiftlint:disable:next empty_count
                if tempContactList.count > 0 {
                    // After sync new contact list with local db there are still contacts avalilabe
                    // i.e. there are newly added contacts
                    print("New Added contacts \(tempContactList.description)")
                    self.saveNewContactInDb(tempContactList) { success in
                        completion(success)
                    }
                } else {
                    print("No new contact added")
                    completion(true)
                }
            }
        }
        
    }
    
    func saveNewContactInDb(_ contacts: NSMutableArray,
                            completion: @escaping (_ success: Bool) -> Void) {
        DispatchQueue.global(qos: .background).async {
            for newContact in contacts {
                if let tempContact = newContact as? PhonebookContact,
                    let contact = CoreDataManager.shared.createContact() as? Contact {
                    contact.name = tempContact.name ?? ""
                    contact.phone = tempContact.phone
                }
                CoreDataManager.shared.saveContextInBG()
            }
            completion(true)
        }
    }
    
    func contactDictonaryList(completion: @escaping (_ dictionaryList: NSMutableArray) -> Void) {
        self.contactList.removeAllObjects()
        
        DispatchQueue.global(qos: .background).async {
            self.requestedForAccess { granted in
                guard granted else { completion([]); return }
                for contact in self.getContact() {
                    for tempContact: CNLabeledValue in contact.phoneNumbers {
                        
                        if contact.givenName.lowercased() == "spam" || contact.givenName
                            .lowercased() == "identified as spam" {
                            continue
                        }
                        
                        let finalNumber = self.digitsForPhone(tempContact)
                        if !finalNumber.isEmpty {
                            let dict = PhonebookContact(name: "\(contact.givenName) \(contact.familyName)",
                                phone: finalNumber)
                            self.contactList.add(dict)
                        }
                    }
                }
                completion(self.contactList)
            }
        }
        
    }
        
    /// The method gives plain numbers (without masking) from Phone Book phone number
    func digitsForPhone(_ phoneNumber: CNLabeledValue<CNPhoneNumber>) -> String {
        if var strPhoneNumber = (phoneNumber.value as CNPhoneNumber).value(forKey: "digits")! as? String {
            if strPhoneNumber.first == "0" {
                let index = strPhoneNumber.index(strPhoneNumber.startIndex, offsetBy: 1)
                strPhoneNumber = String(strPhoneNumber[index...])
            }
            return strPhoneNumber
        }
        return ""
    }
    
    public func addPhoneBookUpdatedObserver() {
        if !self.isAccessAuthorised { return }
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.syncPhoneBookWithDB),
                                               name: NSNotification.Name.CNContactStoreDidChange,
                                               object: nil)
    }
    
    @objc func syncPhoneBookWithDB() {
        self.syncPhoneBook()
    }
    
    public func getContacts(completion: @escaping (_ contacts: [Contact]) -> Void) {
        if let contacts = CoreDataManager.shared.getContacts() as? [Contact] {
            completion(contacts)
        }
    }
    
    public func getName(for phone: String) -> String {
        
        if let coreDataContacts = CoreDataManager.shared.getContacts()
            as? [Contact] {
            let contacts = coreDataContacts.filter { $0.phone != nil }
            let filteredContacts = contacts.filter { $0.phone!.contains(phone) }
            return filteredContacts.first?.name ?? phone
        }
        return phone
    }
    
}
