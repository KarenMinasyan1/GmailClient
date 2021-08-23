//
//  Parser.swift
//  GmailClient
//
//  Created by Karen Minasyan on 23.08.21.
//

import Foundation

protocol ParserProtocol {
    func decode<T: Decodable>(data: Data, completion: @escaping ResultCallback<T>)
}

struct Parser: ParserProtocol {
    let jsonDecoder = JSONDecoder()

    func decode<T: Decodable>(data: Data, completion: @escaping ResultCallback<T>) {
        do {
            let result: T = try jsonDecoder.decode(T.self, from: data)
            DispatchQueue.main.async { completion(.success(result)) }
        } catch let error {
            DispatchQueue.main.async { completion(.failure(.parserError(error: error))) }
        }
    }
}
