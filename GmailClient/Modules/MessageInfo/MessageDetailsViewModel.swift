//
//  MessageDetailsViewModel.swift
//  GmailClient
//
//  Created by Karen Minasyan on 23.08.21.
//

import Foundation

import Foundation

protocol MessageDetailsViewModelInput {
    func viewDidLoad()
}

protocol MessageDetailsViewModelOutput {
    var testData: Observable<String> { get }
    var errorMessage: Observable<String?> { get }
    var loading: Observable<Bool> { get }
}

protocol MessageDetailsViewModel: MessageDetailsViewModelInput, MessageDetailsViewModelOutput {}

final class DefaultMessageDetailsViewModel: MessageDetailsViewModel {

    private let provider: MessageProviderProtocol
    private let messageID: String
    private let userID: String

    // Output

    var testData: Observable<String> = Observable("")
    var errorMessage: Observable<String?> = Observable(nil)
    var loading: Observable<Bool> = Observable(false)

    init(messageProvider: MessageProviderProtocol,
         messageID: String,
         userID: String) {
        self.provider = messageProvider
        self.messageID = messageID
        self.userID = userID
    }

    // Input

    func viewDidLoad() {
        loadMessage()
    }

    // Private

    private func loadMessage() {
        provider.messageInfo(userID: userID, messageID: messageID) { [weak self] (result: Result<String, NetworkError>) in
            guard let self = self else { return }
            switch result {
            case .success(let stringValue):
                self.testData.value = stringValue
                print(stringValue)
            case .failure(let error):
                self.errorMessage.value = "Failed to load message" // TODO- better handle
                print(error.localizedDescription)
            }
        }
    }
}
