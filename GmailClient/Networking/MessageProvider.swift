//
//  NetworkService.swift
//  GmailClient
//
//  Created by Karen Minasyan on 22.08.21.
//

typealias ResultCallback<T> = (Result<T, NetworkError>) -> Void

protocol MessageProvider {
    func messageList(completion: @escaping ResultCallback<MessagesResponse>)
    func messageInfo(messageID: String, completion: @escaping ResultCallback<FullMessageResponse>)
    var userID: String { get }
}
