//
//  UIApplication+RootView.swift
//  GmailClient
//
//  Created by Karen Minasyan on 24.08.21.
//

import UIKit

extension UIApplication {
    public static func setRootView(_ viewController: UIViewController,
                                   options: UIView.AnimationOptions = .transitionCrossDissolve,
                                   animated: Bool = true,
                                   duration: TimeInterval = 0.3,
                                   completion: (() -> Void)? = nil) {
        guard let window = UIApplication.shared.windows.filter({$0.isKeyWindow}).first else { return }

        if !animated {
            window.rootViewController = viewController
            return
        }

        UIView.transition(with: window, duration: duration, options: options, animations: {
            let oldState = UIView.areAnimationsEnabled
            UIView.setAnimationsEnabled(false)
            window.rootViewController = viewController
            UIView.setAnimationsEnabled(oldState)
        }) { _ in
            completion?()
        }
    }
}
