//
//  SupportedModelProvider+.swift
//  XCIntelligenceBridge
//
//  Created by treastrain on 2025/08/22.
//

import Foundation
public import PersistentStorage

extension SupportedModelProvider: CaseIterable {
    public nonisolated static var allCases: [SupportedModelProvider] {
        [
            // anthropicClaude,
            // githubModels,
            googleGemini,
        ]
        .sorted { $0.name.localizedStandardCompare($1.name) == .orderedAscending }
    }
}

extension SupportedModelProvider {
    public nonisolated init?(by id: String) {
        guard let provider = Self.allCases.first(where: { $0.id == id }) else { return nil }
        self = provider
    }
}
