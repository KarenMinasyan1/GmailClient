//
//  AuthorizationService.swift
//  GmailClient
//
//  Created by Karen Minasyan on 25.08.21.
//

import UIKit

protocol AuthorizationService {
    func presentAuthorizationIn(viewController: UIViewController,
                                completion: @escaping ResultCallback<MessageProvider>)
    static func removeState()
}
