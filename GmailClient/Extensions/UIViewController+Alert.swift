//
//  UIViewController+Alert.swift
//  GmailClient
//
//  Created by Karen Minasyan on 23.08.21.
//

import UIKit

extension UIViewController {
    func showAlert(title: String = "", message: String, preferredStyle: UIAlertController.Style = .alert, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        present(alert, animated: true, completion: completion)
    }
}
