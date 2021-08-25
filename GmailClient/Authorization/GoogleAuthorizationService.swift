//
//  GoogleAuthorizationService.swift
//  GmailClient
//
//  Created by Karen Minasyan on 21.08.21.
//

import AppAuth
import GTMAppAuth

final class GoogleAuthorizationService: AuthorizationService {

    // Add your clientID and redirectURI
    private let clientID = ""
    private let redirectURI = ""

    private let issuer = "https://accounts.google.com"
    static let authorizerKey = "google_authorizer_key"

    var authorizer: GTMAppAuthFetcherAuthorization?
    var currentAuthorizationFlow: OIDExternalUserAgentSession?

    func presentAuthorizationIn(viewController: UIViewController,
                                completion: @escaping ResultCallback<MessageProvider>) {
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

            self.currentAuthorizationFlow = OIDAuthState.authState(byPresenting: request, presenting: viewController) { [weak self] authState, error in
                guard let self = self else { return }
                if let error = error {
                    print(error) // No need to handle the error (User cancel error)
                    return
                }

                let authorizer = GTMAppAuthFetcherAuthorization(authState: authState!)
                self.saveState(authorizer: authorizer)
                self.authorizer = authorizer
                let networkService = GmailNetworkService(authorizer: authorizer, parser: Parser())
                let provider = GmailMessageProvider(userID: authorizer.userID!, networkService: networkService)
                completion(.success(provider))
            }
        }
    }

    private func saveState(authorizer: GTMAppAuthFetcherAuthorization) {
        if authorizer.canAuthorize() {
            GTMAppAuthFetcherAuthorization.save(authorizer, toKeychainForName: Self.authorizerKey)
        }
    }

    static func removeState() {
        GTMAppAuthFetcherAuthorization.removeFromKeychain(forName: Self.authorizerKey)
    }
}
