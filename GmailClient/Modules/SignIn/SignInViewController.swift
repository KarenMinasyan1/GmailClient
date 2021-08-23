//
//  SignInViewController.swift
//  GmailClient
//
//  Created by Karen Minasyan on 21.08.21.
//

import UIKit

class SignInViewController: UIViewController {

    var authService: GoogleAuthorizationService! // TODO: AuthorizationService

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    // MARK: - Actions

    @IBAction private func signInAction(_ sender: Any) {
        authService.signInWithPresentingViewCotroller(self) { [weak self] error in
            guard let self = self else { return }
            if let error = error {
                print(error.localizedDescription)
            } else {
                self.authService.saveState()
                self.showMessageListVC()
            }
        }
    }

    @IBAction func testRequestAction(_ sender: Any) {
    }

    private func showMessageListVC() {
        let viewController = MessageListViewController()
        let networkService = GmailNetworkService(authorizer: authService.authorizer!, parser: Parser())
        let gmailMessageProvider = GmailMessageProvider(networkService: networkService)
        
        let viewModel = DefaultMessageListViewModel(messageProvider: gmailMessageProvider,
                                                    userID: authService.userID!)
        viewController.viewModel = viewModel
        navigationController?.pushViewController(viewController, animated: true)
    }
}

