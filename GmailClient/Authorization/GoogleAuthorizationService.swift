//
//  GoogleAuthorizationService.swift
//  GmailClient
//
//  Created by Karen Minasyan on 21.08.21.
//

import AppAuth
import GTMAppAuth

@objc final class GoogleAuthorizationService: NSObject, AuthorizationService {
    private let issuer = "https://accounts.google.com"
    private let clientID = "65055114135-qercr5c15qgkrpc0be47rgsmjq8a6c47.apps.googleusercontent.com"
    private let redirectURI = "com.googleusercontent.apps.65055114135-qercr5c15qgkrpc0be47rgsmjq8a6c47:/oauthredirect"
    private let authorizerKey = "authorizer_key" // TODO move

    var authorizer: GTMAppAuthFetcherAuthorization? = nil

    var userID: String? {
        authorizer?.userID
    }

    func signInWithPresentingViewCotroller(_ vc: UIViewController,
                                           completion: @escaping (Error?) -> Void) {
        let issuerURL = URL(string: issuer)!
        let redirectURIURL = URL(string: redirectURI)!
        
        OIDAuthorizationService.discoverConfiguration(forIssuer: issuerURL) { [weak self] configuration, error in
            guard let configuration = configuration, let self = self else {
                // TODO: -handle error
                completion(error!)
                print(" OIDServiceConfiguration is nil")
                print(error.debugDescription)
                return
            }

            let request = OIDAuthorizationRequest(configuration: configuration,
                                                  clientId: self.clientID,
                                                  scopes: [OIDScopeProfile, "https://mail.google.com/"],
                                                  redirectURL: redirectURIURL,
                                                  responseType: OIDResponseTypeCode,
                                                  additionalParameters: nil)

            // TODO: - remove from appDelegate
            let appDelegate = (UIApplication.shared.delegate as? AppDelegate)

//            appDelegate?.currentAuthorizationFlow = OIDAuthState.authState(byPresenting: request,
//                                   externalUserAgent: self,
//                                   callback: { [weak self] authState, error in
//                                    guard let self = self else { return }
//                                    if let authState = authState {
//                                        self.authorizer = GTMAppAuthFetcherAuthorization(authState: authState)
//                                        print("Success: AccessToken\(self.authorizer!.authState.lastTokenResponse?.accessToken ?? "")")
//                                        completion(nil)
//                                    } else {
//                                        // TODO: -handle error
//                                        completion(error!)
//                                        print("Error: \(error.debugDescription)")
//                                    }
//                                   })

            appDelegate?.currentAuthorizationFlow =
                OIDAuthState.authState(byPresenting: request,
                                       presenting: vc,
                                       callback: { [weak self] authState, error in
                                        guard let self = self else { return }
                                        if let authState = authState {
                                            self.authorizer = GTMAppAuthFetcherAuthorization(authState: authState)
                                            print("Success: AccessToken\(self.authorizer!.authState.lastTokenResponse?.accessToken ?? "")")
                                            completion(nil)
                                        } else {
                                            // TODO: -handle error
                                            completion(error!)
                                            print("Error: \(error.debugDescription)")
                                        }
                                       })
        }
    }

    func saveState() {
        if let authorizer = authorizer,
           authorizer.canAuthorize() {
            GTMAppAuthFetcherAuthorization.save(authorizer, toKeychainForName: authorizerKey)
        }
    }

    func removeState() {
        GTMAppAuthFetcherAuthorization.removeFromKeychain(forName: authorizerKey)
    }
}

extension GoogleAuthorizationService: OIDExternalUserAgent {
    func present(_ request: OIDExternalUserAgentRequest, session: OIDExternalUserAgentSession) -> Bool {
        true
    }
    
    func dismiss(animated: Bool, completion: @escaping () -> Void) {
        print("Karen -- dismiss")
    }
}
