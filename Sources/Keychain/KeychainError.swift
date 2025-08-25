//
//  KeychainError.swift
//  XCIntelligenceBridge
//
//  Created by treastrain on 2025/08/25.
//

import Foundation
public import Security

public struct KeychainError: Error {
    public var status: OSStatus

    public var localizedDescription: String {
        SecCopyErrorMessageString(status, nil) as String? ?? "Unknown error."
    }
}
