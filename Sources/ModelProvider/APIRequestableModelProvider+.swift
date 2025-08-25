//
//  APIRequestableModelProvider+.swift
//  XCIntelligenceBridge
//
//  Created by treastrain on 2025/08/24.
//

import Foundation
import Keychain
public import PersistentStorage

extension APIRequestableModelProvider {
    public init?(from provider: ModelProvider) throws {
        guard let supportedModelProvider = SupportedModelProvider(by: provider.supportID) else { return nil }
        let apiKey = try Keychain.current.get(uuid: provider.uuid)
        self.init(
            uuid: provider.uuid,
            displayName: provider.name,
            urlRequest: {
                var request = URLRequest(url: $0)
                let apiKeyValue = supportedModelProvider.apiKeyValuePrefix.map { $0 + apiKey } ?? apiKey
                request.addValue(apiKeyValue, forHTTPHeaderField: supportedModelProvider.apiKeyHeader)
                supportedModelProvider.httpHeaders.forEach { request.addValue($1, forHTTPHeaderField: $0) }
                return request
            },
            v1ModelsURL: supportedModelProvider.v1ModelsURL,
            v1ChatCompletionsURL: supportedModelProvider.v1ChatCompletionsURL
        )
    }
}
