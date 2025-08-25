//
//  SupportedModelProvider+GoogleGemini.swift
//  XCIntelligenceBridge
//
//  Created by treastrain on 2025/08/25.
//

import Foundation
public import PersistentStorage

extension SupportedModelProvider {
    public nonisolated static let googleGemini = SupportedModelProvider(
        id: "com.googleapis.generativelanguage",
        name: "Google Gemini",
        baseURL: URL(string: "https://generativelanguage.googleapis.com")!,
        apiKeyLabel: "API キー",
        apiKeyHeader: "Authorization",
        apiKeyValuePrefix: "Bearer ",
        httpHeaders: [:],
        v1ModelsURLComponents: URLComponents(string: "/v1beta/openai/models")!,
        v1ChatCompletionsURLComponents: URLComponents(string: "/v1beta/openai/chat/completions")!
    )
}
