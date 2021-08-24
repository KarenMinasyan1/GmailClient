//
//  NetworkError.swift
//  GmailClient
//
//  Created by Karen Minasyan on 23.08.21.
//

import Foundation

enum NetworkError: Error {
    case invalidRequest
    case dataMissing
    case tokenMissing
    case responseError(error: Error)
    case parserError(error: Error)
    case authorization(error: Error)
}
