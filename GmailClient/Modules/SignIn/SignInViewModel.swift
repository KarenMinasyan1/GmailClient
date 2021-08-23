//
//  SignInViewModel.swift
//  GmailClient
//
//  Created by Karen Minasyan on 23.08.21.
//

import Foundation

protocol SignInViewModelInput {
    func didSelectSignIn()
}

protocol SignInViewModelOutput {
    var authSuccess: Observable<MessageListViewModel>? { get }
    var errorMessage: Observable<String?> { get }
    var loading: Observable<Bool> { get }
}

protocol SignInViewModel: SignInViewModelInput, SignInViewModelOutput {}

final class DefaultSignInViewModel: SignInViewModel {

    private let provider: MessageProviderProtocol
    private let userID: String

    // Output

    var authSuccess: Observable<MessageListViewModel>? = nil
    var errorMessage: Observable<String?> = Observable(nil)
    var loading: Observable<Bool> = Observable(false)

    init(messageProvider: MessageProviderProtocol,
         userID: String) {
        self.provider = messageProvider
        self.userID = userID
    }

    // Input

    func didSelectSignIn() {
        
    }
}
