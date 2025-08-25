//
//  SupportedModelProvider.swift
//  XCIntelligenceBridge
//
//  Created by treastrain on 2025/08/22.
//

public import Foundation

public nonisolated struct SupportedModelProvider: Identifiable, Equatable, Sendable {
    public let id: String
    public let name: String
    let baseURL: URL
    public let apiKeyLabel: LocalizedStringResource
    public let apiKeyHeader: String
    public let apiKeyValuePrefix: String?
    public let httpHeaders: [String: String]
    let v1ModelsURLComponents: URLComponents
    let v1ChatCompletionsURLComponents: URLComponents

    public var v1ModelsURL: URL {
        v1ModelsURLComponents.url(relativeTo: baseURL)!
    }

    public var v1ChatCompletionsURL: URL {
        v1ChatCompletionsURLComponents.url(relativeTo: baseURL)!
    }

    public init(
        id: String,
        name: String,
        baseURL: URL,
        apiKeyLabel: LocalizedStringResource,
        apiKeyHeader: String,
        apiKeyValuePrefix: String?,
        httpHeaders: [String: String],
        v1ModelsURLComponents: URLComponents,
        v1ChatCompletionsURLComponents: URLComponents
    ) {
        self.id = id
        self.name = name
        self.baseURL = baseURL
        self.apiKeyLabel = apiKeyLabel
        self.apiKeyHeader = apiKeyHeader
        self.apiKeyValuePrefix = apiKeyValuePrefix
        self.httpHeaders = httpHeaders
        self.v1ModelsURLComponents = v1ModelsURLComponents
        self.v1ChatCompletionsURLComponents = v1ChatCompletionsURLComponents
    }
}
