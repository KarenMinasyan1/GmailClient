//
//  MessageDetailsViewController.swift
//  GmailClient
//
//  Created by Karen Minasyan on 22.08.21.
//

import UIKit

final class MessageDetailsViewController: UIViewController {

    private let scrollView = UIScrollView()
    private let stackView = UIStackView()
    private let senderLabel = UILabel()
    private let subjectLabel = UILabel()
    private let bodyLabel = UILabel()

    var viewModel: MessageDetailsViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        configureHierarhies()
        setupUI()
        bindViewModel()
        viewModel.viewInitialLoad()
    }

    private func bindViewModel() {
        viewModel.messageInfo.observe(on: self) { [weak self] in self?.setupMessageInfo($0) }
        viewModel.errorMessage.observe(on: self) { [weak self] in self?.showError(message: $0) }
    }

    private func configureHierarhies() {
        view.addSubviewWithLayoutToBounds(subView: scrollView)
        scrollView.addSubview(stackView)

        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true

        stackView.addArrangedSubview(senderLabel)
        stackView.addArrangedSubview(subjectLabel)
        stackView.addArrangedSubview(bodyLabel)

        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        stackView.spacing = 16
        stackView.axis = .vertical
    }

    private func setupUI() {
        view.backgroundColor = .systemBackground
        senderLabel.font = .italicSystemFont(ofSize: 16)
        subjectLabel.font = .boldSystemFont(ofSize: 16)
        bodyLabel.font = .systemFont(ofSize: 14)
        senderLabel.numberOfLines = 0
        subjectLabel.numberOfLines = 0
        bodyLabel.numberOfLines = 0
    }

    private func setupMessageInfo(_ messageInfo: MessageInfo?) {
        guard let info = messageInfo else { return }
        senderLabel.text = info.from
        subjectLabel.text = info.subject
        bodyLabel.text = info.body
    }

    private func showError(message: String) {
        if !message.isEmpty {
            showAlert(message: message) { [weak self] _ in
                self?.navigationController?.popViewController(animated: true)
            }
        }
    }
}

