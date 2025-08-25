//
//  SwiftData+.swift
//  XCIntelligenceBridge
//
//  Created by treastrain on 2025/08/23.
//

public import Foundation
public import SwiftData

extension ModelContainer {
    public static var shared: ModelContainer {
        let schema = Schema([ModelProvider.self, XcodeIntelligenceModel.self])
        let modelConfiguration = ModelConfiguration(schema: schema, groupContainer: .identifier(AppGroup.name), cloudKitDatabase: .none)
        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }
}

extension FetchDescriptor<ModelProvider> {
    public static var modelProviders: Self {
        .init(
            sortBy: [.init(\.name), .init(\.creationDate)]
        )
    }

    public static var enabledModelProviders: Self {
        .init(
            predicate: #Predicate {
                $0.isEnabled
            },
            sortBy: [.init(\.name), .init(\.creationDate)]
        )
    }

    public static func modelProvider(by uuid: UUID) -> Self {
        .init(
            predicate: #Predicate {
                $0.isEnabled && $0.uuid == uuid
            }
        )
    }
}

extension FetchDescriptor<XcodeIntelligenceModel> {
    public static var models: Self {
        .init()
    }

    public static func model(by identifierForXcode: String) -> Self {
        .init(
            predicate: #Predicate {
                $0.identifierForXcode == identifierForXcode
            }
        )
    }
}
