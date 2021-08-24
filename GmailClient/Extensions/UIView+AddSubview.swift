//
//  UIView+AddSubview.swift
//  GmailClient
//
//  Created by Karen Minasyan on 24.08.21.
//

import UIKit

extension UIView {
    func addSubviewWithLayoutToBounds(subView: UIView, insets: UIEdgeInsets = .zero) {
        addSubview(subView)
        addConstraintToBounds(subView: subView, insets: insets)
    }

    func addSubviewWithLayoutToCenter(subView: UIView) {
        addSubview(subView)
        subView.translatesAutoresizingMaskIntoConstraints = false
        subView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        subView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }

    func insertSubviewWithLayoutToBounds(subview: UIView,
                                         at index: Int,
                                         insets: UIEdgeInsets = .zero) {
        insertSubview(subview, at: index)
        addConstraintToBounds(subView: subview, insets: insets)
    }

    private func addConstraintToBounds(subView: UIView, insets: UIEdgeInsets) {
        subView.translatesAutoresizingMaskIntoConstraints = false
        subView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: insets.left).isActive = true
        subView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -insets.right).isActive = true
        subView.topAnchor.constraint(equalTo: topAnchor, constant: insets.top).isActive = true
        subView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -insets.bottom).isActive = true
    }
}
