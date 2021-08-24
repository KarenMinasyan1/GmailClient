//
//  MessageListViewController.swift
//  GmailClient
//
//  Created by Karen Minasyan on 22.08.21.
//

import UIKit
import GTMAppAuth

final class MessageListViewController: UIViewController {

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
    }

    private func bindViewModel() {
        viewModel.messages.observe(on: self) { [weak self] in self?.applySnapshotWith(ids: $0) }
        viewModel.errorMessage.observe(on: self) { [weak self] in self?.showError(message: $0) }
        viewModel.loading.observe(on: self) { [weak self] in self?.showLoading($0) }
        viewModel.selectMessage.observe(on: self) { [weak self] in self?.showMessageDetails(viewModel: $0) }
    }

    private func showLoading(_ loading: Bool) {
        
    }

    private func showError(message: String) {
        if !message.isEmpty {
            showAlert(message: message)
        }
    }

    private func showMessageDetails(viewModel: MessageDetailsViewModel?) {
        guard let mViewModel = viewModel else { return }
        let viewController = MessageDetailViewController()
        viewController.viewModel = mViewModel
        navigationController?.pushViewController(viewController, animated: true)
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
