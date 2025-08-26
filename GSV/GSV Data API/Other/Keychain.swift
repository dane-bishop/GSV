//
//  Keychain.swift
//  GSV
//
//  Created by Melanie Bishop on 8/17/25.
//

import Foundation

import SwiftUI
import Security

enum Keychain {
    @discardableResult
    static func save(token: String, account: String = "api_jwt") -> Bool {
        let q: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: account,
            kSecValueData as String: Data(token.utf8)
        ]
        SecItemDelete(q as CFDictionary)
        return SecItemAdd(q as CFDictionary, nil) == errSecSuccess
    }
    static func load(account: String = "api_jwt") -> String? {
        let q: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: account,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        var result: AnyObject?
        let s = SecItemCopyMatching(q as CFDictionary, &result)
        guard s == errSecSuccess, let data = result as? Data else { return nil }
        return String(data: data, encoding: .utf8)
    }
    @discardableResult
    static func delete(account: String = "api_jwt") -> Bool {
        SecItemDelete([kSecClass: kSecClassGenericPassword, kSecAttrAccount: account] as CFDictionary) == errSecSuccess
    }
}


@MainActor
final class SessionStore: ObservableObject {
    @Published var isAuthed = (Keychain.load() != nil)
    
    func login(username: String, password: String) async {
        do {
            isAuthed = true
        } catch {
            isAuthed = false
        }
    }
    
    
    func loginSucceeded(with token: String) {
        Keychain.save(token: token)
        isAuthed = true
    }
    func logout() {
        Keychain.delete()
        isAuthed = false
    }
}

