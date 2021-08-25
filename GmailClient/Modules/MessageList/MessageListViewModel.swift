//
//  MessageListViewModel.swift
//  GmailClient
//
//  Created by Karen Minasyan on 23.08.21.
//

import Foundation

protocol MessageListViewModelInput {
    func viewDidLoad()
    func didSelectItem(at index: Int)
    func logoutTap()
}

protocol MessageListViewModelOutput {
    var messages: Observable<[String]> { get }
    var selectMessage: Observable<MessageDetailsViewModel?> { get }
    var errorMessage: Observable<String> { get }
    var logout: Observable<Bool> { get }
    var loading: Observable<Bool> { get }
}

protocol MessageListViewModel: MessageListViewModelInput, MessageListViewModelOutput {}

final class DefaultMessageListViewModel: MessageListViewModel {

    private let provider: MessageProvider
    private let userID: String

    // Output

    var messages: Observable<[String]> = Observable([])
    var selectMessage: Observable<MessageDetailsViewModel?> = Observable(nil)
    var errorMessage: Observable<String> = Observable("")
    var logout: Observable<Bool> = Observable(false)
    var loading: Observable<Bool> = Observable(false)

    init(messageProvider: MessageProvider,
         userID: String) {
        self.provider = messageProvider
        self.userID = userID
    }

    // Input

    func viewDidLoad() {
        loadMessageList()
    }

    func didSelectItem(at index: Int) {
        let viewModel = DefaultMessageDetailsViewModel(messageProvider: provider,
                                                       storageProvider: CoreDataMessageStorageProvider(),
                                                       messageID: messages.value[index],
                                                       userID: userID)
        selectMessage.value = viewModel
    }

    func logoutTap() {
        GoogleAuthorizationService.removeState()
        logout.value = true
    }

    // Private

    private func loadMessageList() {
        provider.messageList(userID: userID) { [weak self] (result: Result<MessagesResponse, NetworkError>) in
            guard let self = self else { return }
            switch result {
            case .success(let messagesResponse):
                self.messages.value = messagesResponse.messages.map({ $0.id })
            case .failure(let error):
                print(error.localizedDescription)
                self.errorMessage.value = "Can't load messages"
            }
        }
    }
}
