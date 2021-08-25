//
//  CoreDataStack.swift
//  GmailClient
//
//  Created by Karen Minasyan on 25.08.21.
//

import CoreData

enum CoreDataStorageError: Error {
    case dataMissing
    case readError(Error)
    case saveError(Error)
    case deleteError(Error)
}

final class CoreDataStack: NSObject {

    static let shared = CoreDataStack()
    private override init() {}

    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "GmailClient")
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                assertionFailure("CoreDataStorage Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()

    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                assertionFailure("CoreDataStorage Unresolved error \(error), \((error as NSError).userInfo)")
            }
        }
    }

    func clear() {
        // Get a reference to a NSPersistentStoreCoordinator
        let storeContainer = persistentContainer.persistentStoreCoordinator

        // Delete each existing persistent store
        for store in storeContainer.persistentStores {
            try? storeContainer.destroyPersistentStore(at: store.url!, ofType: store.type, options: nil)
        }

        // Re-create the persistent container
        persistentContainer = NSPersistentContainer(name: "GmailClient")

        // Calling loadPersistentStores will re-create the
        // persistent stores
        persistentContainer.loadPersistentStores { _, error in
            if let error = error as NSError? {
                assertionFailure("CoreDataStorage Unresolved error \(error), \(error.userInfo)")
            }
        }
    }
    
    func performBackgroundTask(_ block: @escaping (NSManagedObjectContext) -> Void) {
        persistentContainer.performBackgroundTask(block)
    }
}
