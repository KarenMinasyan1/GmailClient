//
//  MessageListViewController.swift
//  GmailClient
//
//  Created by Karen Minasyan on 22.08.21.
//

import UIKit
import GTMAppAuth

final class MessageListViewController: ViewController {

    var viewModel: MessageListViewModel!

    // TableView
    private var tableView = UITableView()
    private var dataSource: UITableViewDiffableDataSource<Int, String>!
    private static let cellReuseID = "reuse_id"

    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        configureDataSource()
        bindViewModel()
        viewModel.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(logOutTap))
    }

    private func bindViewModel() {
        viewModel.messages.observe(on: self) { [weak self] in self?.applySnapshotWith(ids: $0) }
        viewModel.errorMessage.observe(on: self) { [weak self] in self?.showError(message: $0) }
        viewModel.selectMessage.observe(on: self) { [weak self] in self?.showMessageDetails(viewModel: $0) }
        viewModel.logout.observe(on: self) { [weak self] in self?.logoutAction(viewModel: $0) }
    }

    private func showMessageDetails(viewModel: MessageDetailsViewModel?) {
        guard let mViewModel = viewModel else { return }
        let viewController = MessageDetailsViewController()
        viewController.viewModel = mViewModel
        navigationController?.pushViewController(viewController, animated: true)
    }

    @objc private func logOutTap() {
        let alertController = UIAlertController(title: "Are you sure you want to logout?", message: nil, preferredStyle: .actionSheet)

        let logoutAction = UIAlertAction(title: "Logout", style: .destructive) { _ in
            self.viewModel.logoutTap()
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)

        alertController.addAction(logoutAction)
        alertController.addAction(cancelAction)

        present(alertController, animated: true, completion: nil)
    }

    func logoutAction(viewModel: SignInViewModel?) {
        if let viewModel = viewModel {
            let viewController = SignInViewController()
            viewController.authService = GoogleAuthorizationService()
            viewController.viewModel = viewModel
            UIApplication.setRootView(viewController)
        }
    }
}

// MARK: - UITableView DataSource

private extension MessageListViewController {
    func configureTableView() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: Self.cellReuseID)
        tableView.delegate = self
        view.addSubviewWithLayoutToBounds(subView: tableView)
    }

    func configureDataSource() {
        dataSource = UITableViewDiffableDataSource<Int, String>(tableView: tableView, cellProvider: { tableView, indexPath, messageID in
            let cell = tableView.dequeueReusableCell(withIdentifier: Self.cellReuseID, for: indexPath)
            cell.textLabel?.text = "\(indexPath.row + 1). \(messageID)"
            return cell
        })
    }

    func applySnapshotWith(ids: [String]) {
        var snapshot = NSDiffableDataSourceSnapshot<Int, String>()
        snapshot.appendSections([0])
        snapshot.appendItems(ids)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
}

// MARK: - UITableView Delegate

extension MessageListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.didSelectItem(at: indexPath.row)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
