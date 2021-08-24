//
//  AuthorizationService.swift
//  GmailClient
//
//  Created by Karen Minasyan on 22.08.21.
//

import UIKit

// TODO:-- Remove
protocol AuthorizationService {
    func signInWithPresentingViewCotroller(_ vc: UIViewController,
                                           completion: @escaping (Error?) -> Void)
    func saveState()
    func removeState()
    var userID: String? { get }
}
