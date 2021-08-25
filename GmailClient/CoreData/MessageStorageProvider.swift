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
    func messageList(userID: String, completion: @escaping StorageCallback<[String]>)
    func save(messageIds: [String])
    func save(messageInfo: MessageInfo)
    func clearStorage()
}
