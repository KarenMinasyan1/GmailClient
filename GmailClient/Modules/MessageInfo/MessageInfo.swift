//
//  MessageInfo.swift
//  GmailClient
//
//  Created by Karen Minasyan on 23.08.21.
//

struct MessageInfo {
    var id: String
    var from: String
    var subject: String
    var body: String
}

extension MessageInfo {
    init(fullMessage: FullMessageResponse) {
        id = fullMessage.id ?? ""
        from = fullMessage.payload?.headers?.first { $0.name == "From" }?.value ?? ""
        subject = fullMessage.payload?.headers?.first { $0.name == "Subject" }?.value ?? ""
        body = fullMessage.payload?.parts?.first { $0.mimeType == "text/plain" }?.body?.data ?? ""
        body = body.fromBase64URL() ?? ""
    }
}
