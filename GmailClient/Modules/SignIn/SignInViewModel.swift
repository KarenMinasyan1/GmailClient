//
//  SignInViewModel.swift
//  GmailClient
//
//  Created by Karen Minasyan on 23.08.21.
//

import Foundation

protocol SignInViewModelInput {
    func authStateResponse(result: Result<MessageProvider, NetworkError>)
}

protocol SignInViewModelOutput {
    var authSuccess: Observable<MessageListViewModel?> { get }
    var errorMessage: Observable<String> { get }
}

protocol SignInViewModel: SignInViewModelInput, SignInViewModelOutput {}

final class DefaultSignInViewModel: SignInViewModel {

    // Output

    var authSuccess: Observable<MessageListViewModel?> = Observable(nil)
    var errorMessage: Observable<String> = Observable("")

    // Input

    func authStateResponse(result: Result<MessageProvider, NetworkError>) {
        switch result {
        case .success(let provider):
            let viewModel = DefaultMessageListViewModel(messageProvider: provider,
                                                        storageProvider: CoreDataMessageStorageProvider(),
                                                        userID: provider.userID)
            authSuccess.value = viewModel
        case .failure(let error):
            errorMessage.value = error.localizedDescription
        }
    }
}
