//
//  MessageEntity+CoreDataProperties.swift
//  GmailClient
//
//  Created by Karen Minasyan on 25.08.21.
//
//

import Foundation
import CoreData


extension MessageEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MessageEntity> {
        NSFetchRequest<MessageEntity>(entityName: "MessageEntity")
    }

    @NSManaged public var id: String
    @NSManaged public var subject: String
    @NSManaged public var body: String
    @NSManaged public var sender: String

}

extension MessageEntity : Identifiable {

}
