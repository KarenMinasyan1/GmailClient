//
//  SignInViewController.swift
//  GmailClient
//
//  Created by Karen Minasyan on 21.08.21.
//

import UIKit
import AppAuth

final class SignInViewController: ViewController {

    var viewModel: SignInViewModel!

    private let signInButton = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        setupSignInButton()
    }

    private func bindViewModel() {
        viewModel.authRequest.observe(on: self) { [weak self] in self?.presentAuthorizationRequest($0) }
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
        viewModel.didSelectSignIn()
    }

    private func presentAuthorizationRequest(_ request: OIDAuthorizationRequest?) {
        guard let request = request else { return }
        let appDelegate = (UIApplication.shared.delegate as? AppDelegate)

        appDelegate?.currentAuthorizationFlow =
        OIDAuthState.authState(byPresenting: request, presenting: self) { [weak self] state, error in
            self?.viewModel.authStateResponse(authState: state, error: error)
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

