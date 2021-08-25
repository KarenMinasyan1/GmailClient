//
//  GoogleAuthorizationService.swift
//  GmailClient
//
//  Created by Karen Minasyan on 21.08.21.
//

import AppAuth
import GTMAppAuth

final class GoogleAuthorizationService {
    private let issuer = "https://accounts.google.com"
    private let clientID = "65055114135-qercr5c15qgkrpc0be47rgsmjq8a6c47.apps.googleusercontent.com"
    private let redirectURI = "com.googleusercontent.apps.65055114135-qercr5c15qgkrpc0be47rgsmjq8a6c47:/oauthredirect"
    static let authorizerKey = "google_authorizer_key"

    var authorizer: GTMAppAuthFetcherAuthorization?

    func authorizationRequest(completion: @escaping ResultCallback<OIDAuthorizationRequest>) {
        let issuerURL = URL(string: issuer)!
        let redirectURIURL = URL(string: redirectURI)!

        OIDAuthorizationService.discoverConfiguration(forIssuer: issuerURL) { [weak self] configuration, error in
            guard let configuration = configuration, let self = self else {
                completion(.failure(.invalidRequest))
                return
            }

            if let error = error {
                completion(.failure(.authorization(error: error)))
                return
            }

            let request = OIDAuthorizationRequest(configuration: configuration,
                                                  clientId: self.clientID,
                                                  scopes: [OIDScopeProfile, "https://mail.google.com/"],
                                                  redirectURL: redirectURIURL,
                                                  responseType: OIDResponseTypeCode,
                                                  additionalParameters: nil)
            completion(.success(request))
        }
    }

    func saveState(authorizer: GTMAppAuthFetcherAuthorization) {
        if authorizer.canAuthorize() {
            GTMAppAuthFetcherAuthorization.save(authorizer, toKeychainForName: Self.authorizerKey)
        }
    }

    static func removeState() {
        GTMAppAuthFetcherAuthorization.removeFromKeychain(forName: Self.authorizerKey)
    }
}
