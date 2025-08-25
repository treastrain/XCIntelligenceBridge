//
//  ParseableAppStorageKey.swift
//  XCIntelligenceBridge
//
//  Created by treastrain on 2025/08/24.
//

public import Foundation
public import SwiftUI

public nonisolated enum ParseableAppStorageKey: String, Sendable {
    case bridgeServerPort
    case launchAppStartsBridgeServer
}

extension AppStorage {
    public init(
        key: ParseableAppStorageKey,
        defaultValue: Value,
        store: UserDefaults? = nil
    ) where Value == Bool {
        self.init(wrappedValue: defaultValue, key.rawValue, store: store)
    }
}

extension ParseableAppStorage {
    public init(
        key: ParseableAppStorageKey,
        defaultValue: F.FormatInput,
        format: F,
        store: UserDefaults? = nil
    ) where F.FormatOutput == String {
        self.init(key: key.rawValue, format: format, defaultValue: defaultValue, store: store)
    }
}
