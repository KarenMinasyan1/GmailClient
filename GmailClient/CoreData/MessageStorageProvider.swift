//
//  MessageResponseStorage.swift
//  GmailClient
//
//  Created by Karen Minasyan on 25.08.21.
//

import Foundation

typealias StorageCallback<T> = (Result<T, CoreDataStorageError>) -> Void

protocol MessageStorageProvider {
    func message(id: String, completion: @escaping StorageCallback<MessageInfo>)
    func save(messageInfo: MessageInfo)
}

import CoreData

final class CoreDataMessageStorageProvider: MessageStorageProvider {

    private let coreDataStack = CoreDataStack.shared
    
    func message(id: String, completion: @escaping StorageCallback<MessageInfo>) {
        coreDataStack.performBackgroundTask { context in
            do {
                let fetchRequest: NSFetchRequest = MessageEntity.fetchRequest()
                fetchRequest.predicate = NSPredicate(format: "id == %@", id)

                guard let entity = try context.fetch(fetchRequest).first else {
                    completion(.failure(.dataMissing))
                    return
                }

                completion(.success(entity.toMessageInfo()))
            } catch {
                completion(.failure(CoreDataStorageError.readError(error)))
            }
        }
    }

    func save(messageInfo: MessageInfo) {
        coreDataStack.performBackgroundTask { context in
            do {
                _ = messageInfo.toEntity(in: context)
                try context.save()
            } catch {
                debugPrint("Unresolved error \(error), \((error as NSError).userInfo)")
            }
        }
    }
}
