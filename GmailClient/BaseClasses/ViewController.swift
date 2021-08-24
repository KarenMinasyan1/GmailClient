//
//  ViewController.swift
//  GmailClient
//
//  Created by Karen Minasyan on 24.08.21.
//

import UIKit

class ViewController: UIViewController {

    func showError(message: String) {
        if !message.isEmpty {
            showAlert(message: message)
        }
    }

    func showAlert(title: String = "", message: String, preferredStyle: UIAlertController.Style = .alert, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        present(alert, animated: true, completion: completion)
    }
}
