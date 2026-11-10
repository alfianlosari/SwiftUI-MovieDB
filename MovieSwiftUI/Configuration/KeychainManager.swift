//
//  KeychainManager.swift
//  MovieSwiftUI
//
//  Created by Azhar Ghurab on 21/05/1448 AH.
//  Copyright © 1448 AH Alfian Losari. All rights reserved.
//


import Foundation
import Security

final class KeychainManager {

    static let shared = KeychainManager()

    private init() {}

    // MARK: - Keys

    enum Key: String {
        case guestSessionId = "guest_session_id"
        case sessionId = "session_id"
    }

    private let service = "MovieSwiftUI.Authentication"

    // MARK: - Save

    @discardableResult
    func save(
        _ value: String,
        for key: Key
    ) -> Bool {

        guard let data = value.data(using: .utf8) else {
            return false
        }

        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: key.rawValue
        ]

        SecItemDelete(query as CFDictionary)

        var attributes = query

        attributes[kSecValueData as String] = data

        attributes[kSecAttrAccessible as String] =
            kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly

        let status = SecItemAdd(
            attributes as CFDictionary,
            nil
        )

        return status == errSecSuccess
    }

    // MARK: - Read

    func read(for key: Key) -> String? {

        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: key.rawValue,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]

        var result: CFTypeRef?

        let status = SecItemCopyMatching(
            query as CFDictionary,
            &result
        )

        guard status == errSecSuccess,
              let data = result as? Data else {
            return nil
        }

        return String(data: data, encoding: .utf8)
    }

    // MARK: - Delete

    @discardableResult
    func delete(for key: Key) -> Bool {

        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: key.rawValue
        ]

        let status = SecItemDelete(
            query as CFDictionary
        )

        return status == errSecSuccess ||
               status == errSecItemNotFound
    }

    // MARK: - Clear Authentication

    func clearAll() {
        delete(for: .guestSessionId)
        delete(for: .sessionId)
    }
}
