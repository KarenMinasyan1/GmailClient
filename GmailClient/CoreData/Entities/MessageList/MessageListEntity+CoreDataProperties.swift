//
//  MessageListEntity+CoreDataProperties.swift
//  GmailClient
//
//  Created by Karen Minasyan on 25.08.21.
//
//

import Foundation
import CoreData


extension MessageListEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MessageListEntity> {
        return NSFetchRequest<MessageListEntity>(entityName: "MessageListEntity")
    }

    @NSManaged public var ids: [String]

}

extension MessageListEntity : Identifiable {

}
