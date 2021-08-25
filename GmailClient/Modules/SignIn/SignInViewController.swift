//
//  SignInViewController.swift
//  GmailClient
//
//  Created by Karen Minasyan on 21.08.21.
//

import UIKit
import GTMAppAuth

final class SignInViewController: ViewController {

    var viewModel: SignInViewModel!
    var authService: AuthorizationService!

    private let signInButton = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        setupSignInButton()
    }

    private func bindViewModel() {
        viewModel.errorMessage.observe(on: self) { [weak self] in self?.showError(message: $0) }
        viewModel.authSuccess.observe(on: self) { [weak self] in self?.showMessageListVC(viewModel: $0) }
    }

    private func setupSignInButton() {
        view.addSubviewWithLayoutToCenter(subView: signInButton)
        signInButton.setImage(UIImage(named: "google_sign_in"), for: .normal)
        signInButton.addTarget(self, action: #selector(signInAction), for: .touchUpInside)
    }

    // MARK: - Actions

    @objc private func signInAction(_ sender: Any) {
        authService.presentAuthorizationIn(viewController: self) { [weak self] (result: Result<MessageProvider, NetworkError>) in
            self?.viewModel.authStateResponse(result: result)
        }
    }

    private func showMessageListVC(viewModel: MessageListViewModel?) {
        guard let viewModel = viewModel else { return }
        let viewController = MessageListViewController()
        viewController.viewModel = viewModel
        let navController = UINavigationController(rootViewController: viewController)
        navController.modalPresentationStyle = .fullScreen
        present(navController, animated: true)
    }
}

