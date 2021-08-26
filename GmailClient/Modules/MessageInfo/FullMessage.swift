//
//  FullMessage.swift
//  GmailClient
//
//  Created by Karen Minasyan on 23.08.21.
//

struct FullMessageResponse: Codable {
    let id: String?
    let payload: Payload?

}

struct Payload: Codable {
    let headers: [Header]?
    let parts: [Part]?
}

struct Part: Codable {
    let body: Body?
    let mimeType: String?
}

struct Header: Codable {
    let name: String?
    let value: String?
}

struct Body: Codable {
    let data: String?
}
