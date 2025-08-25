//
//  Model.swift
//  XCIntelligenceBridge
//
//  Created by treastrain on 2025/08/16.
//

import Foundation

public nonisolated struct Model: Identifiable, Codable, Sendable {
    public let id: String

    enum CodingKeys: String, CodingKey {
        case id
    }
}
