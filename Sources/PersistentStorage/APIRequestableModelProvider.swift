//
//  APIRequestableModelProvider.swift
//  XCIntelligenceBridge
//
//  Created by treastrain on 2025/08/24.
//

public import Foundation
import Keychain

public nonisolated struct APIRequestableModelProvider: Sendable {
    public let uuid: UUID
    public let displayName: String
    public let urlRequest: @Sendable (_ url: URL) -> URLRequest
    public let v1ModelsURL: URL
    public let v1ChatCompletionsURL: URL

    public init(
        uuid: UUID,
        displayName: String,
        urlRequest: @Sendable @escaping (_: URL) -> URLRequest,
        v1ModelsURL: URL,
        v1ChatCompletionsURL: URL
    ) {
        self.uuid = uuid
        self.displayName = displayName
        self.urlRequest = urlRequest
        self.v1ModelsURL = v1ModelsURL
        self.v1ChatCompletionsURL = v1ChatCompletionsURL
    }
}
