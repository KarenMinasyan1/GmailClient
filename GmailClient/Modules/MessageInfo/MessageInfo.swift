//
//  MessageInfo.swift
//  GmailClient
//
//  Created by Karen Minasyan on 23.08.21.
//

import Foundation

struct MessageInfo {
    var from: String
    var subject: String
    var body: String
}

// TODO: -- change
extension MessageInfo {
    static func convert(fullMessage: FullMessageResponse) -> MessageInfo {
        let from = fullMessage.payload?.headers?.first { $0.name == "From" }?.value ?? ""
        let subject = fullMessage.payload?.headers?.first { $0.name == "Subject" }?.value ?? ""
        var body = fullMessage.payload?.parts?.first { $0.mimeType == "text/plain" }?.body?.data ?? ""
        body = body.fromBase64URL() ?? ""
        return MessageInfo(from: from, subject: subject, body: body)
    }
}
