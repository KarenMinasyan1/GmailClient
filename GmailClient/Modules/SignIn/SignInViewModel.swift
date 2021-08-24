//
//  SignInViewModel.swift
//  GmailClient
//
//  Created by Karen Minasyan on 23.08.21.
//

import Foundation
import AppAuth
import GTMAppAuth

protocol SignInViewModelInput {
    func didSelectSignIn()
    func authStateResponse(authState: OIDAuthState?, error: Error?)
}

protocol SignInViewModelOutput {
    var authSuccess: Observable<MessageListViewModel?> { get }
    var authRequest: Observable<OIDAuthorizationRequest?> { get }
    var errorMessage: Observable<String> { get }
}

protocol SignInViewModel: SignInViewModelInput, SignInViewModelOutput {}

final class DefaultSignInViewModel: SignInViewModel {

    let authService: GoogleAuthorizationService

    // Output

    var authSuccess: Observable<MessageListViewModel?> = Observable(nil)
    var authRequest: Observable<OIDAuthorizationRequest?> = Observable(nil)
    var errorMessage: Observable<String> = Observable("")

    init(authService: GoogleAuthorizationService) {
        self.authService = authService
    }

    // Input

    func didSelectSignIn() {
        authService.authorizationRequest { [weak self] (result: Result<OIDAuthorizationRequest, NetworkError>) in
            guard let self = self else { return }
            switch result {
            case let .success(request):
                self.authRequest.value = request
            case let .failure(error):
                self.errorMessage.value = "Authorization error"
                print(error.localizedDescription)
            }
        }
    }

    func authStateResponse(authState: OIDAuthState?, error: Error?) {
        if let error = error {
            self.errorMessage.value = "Authorization error"
            print(error.localizedDescription)
            return
        }

        guard let authState = authState else {
            self.errorMessage.value = "Authorization error"
            return
        }

        let authorizer = GTMAppAuthFetcherAuthorization(authState: authState)
        self.authService.saveState(authorizer: authorizer)
        
        let networkService = GmailNetworkService(authorizer: authorizer, parser: Parser())
        let gmailMessageProvider = GmailMessageProvider(networkService: networkService)
        let viewModel = DefaultMessageListViewModel(messageProvider: gmailMessageProvider,
                                                    userID: authorizer.userID!)
        authSuccess.value = viewModel
    }
}
