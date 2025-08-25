//
//  Keychain.swift
//  XCIntelligenceBridge
//
//  Created by treastrain on 2025/08/23.
//

public import Foundation
import Security
import SwiftUI

public nonisolated struct Keychain: Sendable {
    let accessGroup: String
    let labelPrefix = "XCIntelligenceBridge"

    public init() {
        let appIdentifierPrefix = Bundle.main.object(forInfoDictionaryKey: "AppIdentifierPrefix") as! String
        accessGroup = "\(appIdentifierPrefix)jp.tret.XCIntelligenceBridge"
    }

    func add(
        account: String,
        password: String,
        labelSuffix: String
    ) throws(KeychainError) {
        let password = password.data(using: String.Encoding.utf8)!
        let label = "\(labelPrefix) (\(labelSuffix))"
        let attributes =
            [
                kSecClass: kSecClassGenericPassword,
                kSecAttrAccount: account,
                kSecAttrAccessGroup: accessGroup,
                kSecValueData: password,
                kSecAttrLabel: label,
            ] as [String: Any]
        let status = SecItemAdd(attributes as CFDictionary, nil)
        guard status == errSecSuccess else { throw KeychainError(status: status) }
    }

    func get(account: String) throws(KeychainError) -> (account: String, password: String) {
        let query =
            [
                kSecClass: kSecClassGenericPassword,
                kSecMatchLimit: kSecMatchLimitOne,
                kSecReturnAttributes: true,
                kSecAttrAccount: account,
                kSecAttrAccessGroup: accessGroup,
                kSecReturnData: true,
            ] as [String: Any]
        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        guard status == errSecSuccess else { throw KeychainError(status: status) }
        guard let existingItem = item as? [String: Any], let passwordData = existingItem[kSecValueData as String] as? Data,
            let password = String(data: passwordData, encoding: String.Encoding.utf8), let account = existingItem[kSecAttrAccount as String] as? String
        else { throw KeychainError(status: errSecInternalError) }
        return (account, password)
    }

    func update(
        account: String,
        password: String,
        labelSuffix: String
    ) throws(KeychainError) {
        let query =
            [
                kSecClass: kSecClassGenericPassword,
                kSecAttrAccount: account,
                kSecAttrAccessGroup: accessGroup,
            ] as [String: Any]
        let password = password.data(using: String.Encoding.utf8)!
        let label = "\(labelPrefix) (\(labelSuffix))"
        let attributesToUpdate =
            [
                kSecAttrAccount: account,
                kSecValueData: password,
                kSecAttrLabel: label,
            ] as [String: Any]
        let status = SecItemUpdate(query as CFDictionary, attributesToUpdate as CFDictionary)
        guard status == errSecSuccess else { throw KeychainError(status: status) }
    }

    func remove(account: String) throws(KeychainError) {
        let query =
            [
                kSecClass: kSecClassGenericPassword,
                kSecAttrAccount: account,
                kSecAttrAccessGroup: accessGroup,
            ] as [String: Any]
        let status = SecItemDelete(query as CFDictionary)
        guard status == errSecSuccess else { throw KeychainError(status: status) }
    }
}

extension Keychain {
    public func add(
        displayName: String,
        uuid: UUID,
        apiKey: String
    ) throws(KeychainError) {
        try add(account: uuid.uuidString, password: apiKey, labelSuffix: displayName)
    }

    public func get(uuid: UUID) throws(KeychainError) -> String {
        let (account, password) = try get(account: uuid.uuidString)
        guard account == uuid.uuidString else { throw KeychainError(status: errSecInternalError) }
        return password
    }

    public func update(
        displayName: String,
        uuid: UUID,
        apiKey: String
    ) throws(KeychainError) {
        try update(account: uuid.uuidString, password: apiKey, labelSuffix: displayName)
    }

    public func updateOrAdd(
        displayName: String,
        uuid: UUID,
        apiKey: String
    ) throws(KeychainError) {
        do {
            try update(displayName: displayName, uuid: uuid, apiKey: apiKey)
        } catch {
            if error.status == errSecItemNotFound {
                try add(displayName: displayName, uuid: uuid, apiKey: apiKey)
            } else {
                throw error
            }
        }
    }

    public func remove(uuid: UUID) throws(KeychainError) {
        try remove(account: uuid.uuidString)
    }
}

extension Keychain {
    @TaskLocal public static var current = Keychain()
}
