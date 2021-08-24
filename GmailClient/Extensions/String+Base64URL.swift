//
//  String+Base64.swift
//  GmailClient
//
//  Created by Karen Minasyan on 23.08.21.
//

import Foundation

extension String {
    func fromBase64URL() -> String? {
        var base64 = self
            .replacingOccurrences(of: "-", with: "+")
            .replacingOccurrences(of: "_", with: "/")
        if base64.count % 4 != 0 {
            base64.append(String(repeating: "=", count: 4 - base64.count % 4))
        }
        if let data = Data(base64Encoded: base64) {
            return String(data: data, encoding: .utf8)
        }
        return nil
    }
}
