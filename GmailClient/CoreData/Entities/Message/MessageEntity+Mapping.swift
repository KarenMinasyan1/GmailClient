//
//  MessageEntity+Mapping.swift
//  GmailClient
//
//  Created by Karen Minasyan on 25.08.21.
//

import CoreData

extension MessageEntity {
    func toMessageInfo() -> MessageInfo {
        MessageInfo(id: id, from: sender, subject: subject, body: body)
    }
}

extension MessageInfo {
    func toEntity(in context: NSManagedObjectContext) -> MessageEntity {
        let entity: MessageEntity = .init(context: context)
        entity.id = id
        entity.sender = from
        entity.subject = subject
        entity.body = body
        return entity
    }
}
