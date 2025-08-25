//
//  SupportedModelProvider+GitHubModels.swift
//  XCIntelligenceBridge
//
//  Created by treastrain on 2025/08/25.
//

import Foundation
public import PersistentStorage

extension SupportedModelProvider {
    public nonisolated static let githubModels = SupportedModelProvider(
        id: "ai.github.models",
        name: "GitHub Models",
        baseURL: URL(string: "https://models.github.ai/inference")!,
        apiKeyLabel: "トークン",
        apiKeyHeader: "Authorization",
        apiKeyValuePrefix: "Bearer ",
        httpHeaders: [:],
        v1ModelsURLComponents: URLComponents(string: "/models")!,
        v1ChatCompletionsURLComponents: URLComponents(string: "/chat/completions")!
    )
}
