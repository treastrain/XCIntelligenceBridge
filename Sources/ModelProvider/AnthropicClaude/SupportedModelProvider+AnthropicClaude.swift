//
//  SupportedModelProvider+AnthropicClaude.swift
//  XCIntelligenceBridge
//
//  Created by treastrain on 2025/08/25.
//

import Foundation
public import PersistentStorage

extension SupportedModelProvider {
    public nonisolated static let anthropicClaude = SupportedModelProvider(
        id: "com.anthropic.api",
        name: "Anthropic Claude",
        baseURL: URL(string: "https://api.anthropic.com")!,
        apiKeyLabel: "API キー",
        apiKeyHeader: "x-api-key",
        apiKeyValuePrefix: nil,
        httpHeaders: ["anthropic-version": "2023-06-01"],
        v1ModelsURLComponents: URLComponents(string: "/v1/models")!,
        v1ChatCompletionsURLComponents: URLComponents(string: "/v1/chat/completions")!
    )
}
