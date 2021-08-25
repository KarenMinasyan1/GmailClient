//
//  MessageDetailsViewModel.swift
//  GmailClient
//
//  Created by Karen Minasyan on 23.08.21.
//

import Foundation

protocol MessageDetailsViewModelInput {
    func viewDidLoad()
}

protocol MessageDetailsViewModelOutput {
    var messageInfo: Observable<MessageInfo?> { get }
    var errorMessage: Observable<String> { get }
    var loading: Observable<Bool> { get }
}

protocol MessageDetailsViewModel: MessageDetailsViewModelInput, MessageDetailsViewModelOutput {}

final class DefaultMessageDetailsViewModel: MessageDetailsViewModel {

    private let storageProvider: MessageStorageProvider
    private let networkProvider: MessageProvider
    private let messageID: String
    private let userID: String

    // Output

    var messageInfo: Observable<MessageInfo?> = Observable(nil)
    var errorMessage: Observable<String> = Observable("")
    var loading: Observable<Bool> = Observable(false)

    init(messageProvider: MessageProvider,
         storageProvider: MessageStorageProvider,
         messageID: String,
         userID: String) {
        self.networkProvider = messageProvider
        self.storageProvider = storageProvider
        self.messageID = messageID
        self.userID = userID
    }

    // Input

    func viewDidLoad() {
        loadMessage()
    }

    // Private

    private func loadMessage() {
        storageProvider.message(id: messageID) { [weak self] (result: Result<MessageInfo, CoreDataStorageError>) in
            guard let self = self else { return }
            switch result {
            case .success(let message):
                self.messageInfo.value = message
            case .failure(let error):
                print(error.localizedDescription)
                // If message is missing in storage load from network
                self.loadMessageFromNetwork()
            }
        }
    }

    private func loadMessageFromNetwork() {
        networkProvider.messageInfo(userID: userID, messageID: messageID) { [weak self] (result: Result<FullMessageResponse, NetworkError>) in
            guard let self = self else { return }
            switch result {
            case .success(let fullMessage):
                let messageInfo = MessageInfo.convert(fullMessage: fullMessage)
                self.messageInfo.value = messageInfo
                // Save message in storage
                self.storageProvider.save(messageInfo: messageInfo)
            case .failure(let error):
                self.errorMessage.value = error.localizedDescription
                print(error)
            }
        }
    }
}
