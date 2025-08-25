//
//  ModelsResponse.swift
//  XCIntelligenceBridge
//
//  Created by treastrain on 2025/08/23.
//

import Foundation

public nonisolated struct ModelsResponse: Codable, Sendable {
    public let data: [Model]
}

extension ModelsResponse {
    public var jsonString: String {
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        let data = try! encoder.encode(self)
        return String(data: data, encoding: .utf8)!
    }
}
