//
//  ModelsRequest.swift
//  XCIntelligenceBridge
//
//  Created by treastrain on 2025/08/21.
//

import Foundation
import ModelProvider
import PersistentStorage
import SwiftData

public nonisolated struct ModelsRequest: Sendable {
    public init() {}

    public func response() async throws -> ModelsResponse {
        let providers = try await modelProviders()
        try await deleteAllModels()
        let decoder = JSONDecoder()
        return try await withThrowingTaskGroup { group in
            for provider in providers {
                group.addTask {
                    let url = provider.v1ModelsURL
                    let request = provider.urlRequest(url)
                    let (data, response) = try await URLSession.shared.data(for: request)
                    let httpResponse = response as! HTTPURLResponse
                    guard (200..<300).contains(httpResponse.statusCode) else { throw URLError(.badServerResponse) }
                    let providedModels = try decoder.decode(ModelsResponse.self, from: data).data
                    var models: [Model] = []
                    for model in providedModels {
                        let nameForXcode = ModelName.name(for: model.id) ?? model.id
                        let identifierForXcode = "\(provider.displayName) - \(nameForXcode)"
                        let modelForXcode = XcodeIntelligenceModel(
                            identifierForXcode: identifierForXcode,
                            providerUUID: provider.uuid,
                            providerDisplayName: provider.displayName,
                            modelID: model.id
                        )
                        try await save(model: modelForXcode)
                        models.append(Model(id: identifierForXcode))
                    }
                    return models
                }
            }
            let models = try await group.reduce(into: [Model]()) { $0.append(contentsOf: $1) }
            return ModelsResponse(data: models)
        }
    }
}

extension ModelsRequest {
    private func modelProviders() throws -> [APIRequestableModelProvider] {
        let container = ModelContainer.shared
        let enabledModelProviders = try container.mainContext.fetch(.enabledModelProviders)
        return try enabledModelProviders.compactMap { try APIRequestableModelProvider(from: $0) }
    }

    private func save(model: XcodeIntelligenceModel) throws {
        let container = ModelContainer.shared
        container.mainContext.insert(model)
        try container.mainContext.save()
    }

    private func deleteAllModels() throws {
        let container = ModelContainer.shared
        try container.mainContext.delete(model: XcodeIntelligenceModel.self)
    }
}
