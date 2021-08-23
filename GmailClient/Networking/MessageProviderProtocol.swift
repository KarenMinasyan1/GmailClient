//
//  NetworkService.swift
//  GmailClient
//
//  Created by Karen Minasyan on 22.08.21.
//

typealias ResultCallback<T> = (Result<T, NetworkError>) -> Void

protocol MessageProviderProtocol {
    func messageList(userID: String, completion: @escaping ResultCallback<MessagesResponse>)
    func messageInfo(userID: String, messageID: String, completion: @escaping ResultCallback<String>)
}
