//
//  CoreDataManager.swift
//  Model
//
//  Created by Vaibhav Parmar on 27/02/20.
//  Copyright © 2020 Nickelfox. All rights reserved.
//

import Foundation
import CoreData

public let context = CoreDataManager.shared.bGManagedObjectContext

class CoreDataManager {
    static let dbName = "AppExtensionCoreDataModel"
    static let contact = "Contact"
    static let shared = CoreDataManager()
    
    lazy var applicationDocumentsDirectory: URL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named in the application's documents Application Support directory.
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return urls.last!
    }()
    
    private lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = Bundle.main.url(forResource: CoreDataManager.dbName, withExtension: "momd")!
        return NSManagedObjectModel(contentsOf: modelURL)!
    }()

    
    private lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.appendingPathComponent("\(CoreDataManager.dbName).sqlite")
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            // Configure automatic migration.
            let options = [ NSMigratePersistentStoresAutomaticallyOption: true, NSInferMappingModelAutomaticallyOption: true ]
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: options)
        } catch {
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data" as AnyObject?
            dict[NSLocalizedFailureReasonErrorKey] = failureReason as AnyObject?
            
            dict[NSUnderlyingErrorKey] = error as NSError
            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            abort()
        }
        
        return coordinator
    }()
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        
        var managedObjectContext: NSManagedObjectContext?
        managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext?.parent = self.bGManagedObjectContext
        managedObjectContext?.automaticallyMergesChangesFromParent = true
        return managedObjectContext!
    }()
    
    lazy var bGManagedObjectContext: NSManagedObjectContext = {
       
        let taskContext = self.persistentContainer.newBackgroundContext()
        taskContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        taskContext.undoManager = nil
        return taskContext
        
    }()
    
    lazy var privateManagedObjectContext: NSManagedObjectContext = {
        
        var managedObjectContext: NSManagedObjectContext?
        if #available(iOS 10.0, *) {
            managedObjectContext = self.persistentContainer.viewContext
        } else {
            // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
            let coordinator = self.persistentStoreCoordinator
            managedObjectContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
            managedObjectContext?.persistentStoreCoordinator = coordinator
            
        }
        return managedObjectContext!
    }()
    
    // iOS-10
    @available(iOS 10.0, *)
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        //let container = NSPersistentContainer(name: CoreDataManager.dbName)
        let container = CoreDataManagerPersistantContainer(name: CoreDataManager.dbName)
//        let container = NSPersistentContainer(name: CoreDataManager.dbName)
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        container.viewContext.undoManager = nil
        container.viewContext.shouldDeleteInaccessibleFaults = true
        container.viewContext.automaticallyMergesChangesFromParent = true

        print("URL----> \(self.applicationDocumentsDirectory)")
        return container
    }()
    
    func getContacts() -> NSArray? {
        let contacts = self.getObjectsforEntity(entity: CoreDataManager.contact,
                                                taskContext: CoreDataManager.shared.bGManagedObjectContext)
        if let contacts = contacts as? NSArray {
            return contacts
        }
        return nil
    }
    
    func getObjectsforEntity(entity: String,
                             taskContext: NSManagedObjectContext) -> AnyObject {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult> (entityName: entity)
        fetchRequest.returnsObjectsAsFaults = false
        
        do {
            let result = try taskContext.fetch(fetchRequest)
            
            return result as AnyObject
        } catch {
            let fetchError = error as NSError
            print(fetchError)
            return nil as [AnyObject]? as AnyObject
        }
    }

    func createContact() -> AnyObject? {
        return self.createObjectForEntity(entityName: CoreDataManager.contact,
                                   taskContext: CoreDataManager.shared.bGManagedObjectContext)
    }
    
    func createObjectForEntity(entityName: String,
                               taskContext: NSManagedObjectContext) -> AnyObject? {
        if entityName.isEmpty { return nil }
        let entityDescription = NSEntityDescription.entity(forEntityName: entityName, in: taskContext)
        let createdObject = NSManagedObject(entity: entityDescription!, insertInto: taskContext)
        return createdObject as AnyObject
    }
    
    // MARK: Delete Object
    func deleteObject(object: NSManagedObject) {
        CoreDataManager.shared.bGManagedObjectContext.delete(object)
        self.saveContextInBG()
    }

    // MARK: - Core Data Saving support
    func saveContextInBG() {
        do {
            if self.bGManagedObjectContext.hasChanges {
                try self.bGManagedObjectContext.save()
            }
        } catch {
            print(error)
        }
    }
    
    func saveContext() {
        
        managedObjectContext.perform {
            do {
                if self.managedObjectContext.hasChanges {
                    try self.managedObjectContext.save()
                }
            } catch {
                let saveError = error as NSError
                print("Unable to Save Changes of Managed Object Context")
                print("\(saveError), \(saveError.localizedDescription)")
            }
            
            self.privateManagedObjectContext.perform {
                do {
                    if self.privateManagedObjectContext.hasChanges {
                        try self.privateManagedObjectContext.save()
                    }
                } catch {
                    let saveError = error as NSError
                    print("Unable to Save Changes of Private Managed Object Context")
                    print("\(saveError), \(saveError.localizedDescription)")
                }
            }
            
        }
    }
}


class CoreDataManagerPersistantContainer: NSPersistentContainer {
    
    override class func defaultDirectoryURL() -> URL {
        
        
        #if DEBUG || DEV || STAGING
        let appGroup = "group.com."
        #elseif RELEASE
        let appGroup = "group.com.xxxx.xxxxx"
        #endif
        
        //let appGroup = Bundle.main.infoDictionary?["APP_GROUP"] as! String
        var storeUrl = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: appGroup)
        storeUrl = storeUrl?.appendingPathComponent("\(CoreDataManager.dbName).sqlite")
        return storeUrl!
    }
    
}
