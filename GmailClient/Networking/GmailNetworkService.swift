//
//  GmailNetworkService.swift
//  GmailClient
//
//  Created by Karen Minasyan on 22.08.21.
//

import Foundation
import GTMAppAuth

final class GmailNetworkService {
    private let authorizer: GTMAppAuthFetcherAuthorization
    private let fetcherService: GTMSessionFetcherService
    private let parser: ParserProtocol

    init(authorizer: GTMAppAuthFetcherAuthorization,
         parser: ParserProtocol) {
        self.authorizer = authorizer
        self.parser = parser
        fetcherService = GTMSessionFetcherService()
        fetcherService.authorizer = authorizer
    }

    func load<T: Decodable>(_ request: URLRequest, completion: @escaping ResultCallback<T>) {
        authorizer.authState.performAction { [weak self] accessToken, _, error in
            guard let self = self else { return }

            if let error = error {
                DispatchQueue.main.async { completion(.failure(.authorization(error: error))) }
                return
            }

            guard let accessToken = accessToken else {
                DispatchQueue.main.async { completion(.failure(.tokenMissing)) }
                return
            }

            var urlRequest = request
            urlRequest.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
            self.fetcherService.fetcher(with: urlRequest).beginFetch { data, error in

                if let error = error {
                    DispatchQueue.main.async { completion(.failure(.responseError(error: error)))}
                    return
                }

                guard let data = data else {
                    DispatchQueue.main.async { completion(.failure(.dataMissing)) }
                    return
                }

                self.parser.decode(data: data, completion: completion)
            }
        }
    }
}
