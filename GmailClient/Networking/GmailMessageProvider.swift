//
//  GmailRequest.swift
//  GmailClient
//
//  Created by Karen Minasyan on 22.08.21.
//

import Foundation

final class GmailMessageProvider: MessageProviderProtocol {
    private let networkService: GmailNetworkService

    init(networkService: GmailNetworkService) {
        self.networkService = networkService
    }

    func messageList(userID: String, completion: @escaping ResultCallback<MessagesResponse>) {
        let request = GmailRequestProvider.messageList(userID: userID).request
        networkService.load(request) { (result: Result<MessagesResponse, NetworkError>) in
            completion(result)
        }
    }

    func messageInfo(userID: String, messageID: String, completion: @escaping ResultCallback<FullMessageResponse>) {
        let request = GmailRequestProvider.messageInfo(userID: userID, messageID: messageID).request
        networkService.load(request) { (result: Result<FullMessageResponse, NetworkError>) in
            completion(result)
        }
    }
}

struct URLRequestProvider {
    static func request(host: String,
                        path: String,
                        scheme: String = "https",
                        httpMethod: String = "GET",
                        queryItems: [URLQueryItem]? = nil,
                        body: Data? = nil,
                        httpHeaders: [String: String]? = nil) -> URLRequest {
        var urlComponents = URLComponents()
        urlComponents.host = host
        urlComponents.scheme = scheme
        urlComponents.path = path
        urlComponents.queryItems = queryItems
        guard let url = urlComponents.url else {
            preconditionFailure("Invalid url components")
        }

        var request = URLRequest(url: url)
        request.httpMethod = httpMethod
        request.httpBody = body

        httpHeaders?.forEach { key, value in
            request.setValue(value, forHTTPHeaderField: key)
        }

        return request
    }
}

 enum GmailRequestProvider {
     case messageList(userID: String)
     case messageInfo(userID: String, messageID: String)
     
    var host: String {
        "www.googleapis.com"
    }

    var path: String {
        switch self {
        case let .messageList(userID):
            return "/gmail/v1/users/\(userID)/messages"
        case let .messageInfo(userID, messageID):
            return "/gmail/v1/users/\(userID)/messages/\(messageID)"
        }
    }

    var request: URLRequest {
        URLRequestProvider.request(host: host, path: path)
    }
 }
