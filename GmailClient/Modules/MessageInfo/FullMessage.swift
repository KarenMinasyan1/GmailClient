//
//  FullMessage.swift
//  GmailClient
//
//  Created by Karen Minasyan on 23.08.21.
//

struct FullMessageResponse: Codable {
    let historyId: String?
    let id: String?
    let internalDate: String?
    let labelIds: [String]?
    let payload: Payload?
    let sizeEstimate: Int?
    let snippet: String?
    let threadId: String?
}

struct Payload: Codable {
    let body: Body?
    let filename: String?
    let headers: [Header]?
    let mimeType: String?
    let partId: String?
    let parts: [Part]?
}

struct Part: Codable {
    let body: Body?
    let filename: String?
    let headers: [Header]?
    let mimeType: String?
    let partId: String?
}

struct Header: Codable {
    let name: String?
    let value: String?
}

struct Body: Codable {
    let size: Int?
    let data: String?
}
