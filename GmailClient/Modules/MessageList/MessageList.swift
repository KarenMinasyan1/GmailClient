//
//  MessageList.swift
//  GmailClient
//
//  Created by Karen Minasyan on 23.08.21.
//

struct MessagesResponse: Codable {
    let messages: [Message]
}

struct Message: Codable {
    let id: String
    let threadId: String
}
