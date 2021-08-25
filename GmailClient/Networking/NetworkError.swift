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

extension NetworkError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .authorization, .tokenMissing:
            return "Authentication error"
        case .invalidRequest, .dataMissing, .responseError:
            return "Unable to load data"
        default:
            return "Oops! something went wrong"
        }
    }
}
