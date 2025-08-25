//
//  ModelProvider.swift
//  XCIntelligenceBridge
//
//  Created by treastrain on 2025/08/22.
//

public import Foundation
public import SwiftData

@Model
public final class ModelProvider {
    public var supportID: String
    public var name: String
    @Attribute(.unique) public var uuid: UUID
    var creationDate: Date
    public var isEnabled: Bool

    public init(
        supportID: String,
        name: String,
        uuid: UUID,
        creationDate: Date,
        isEnabled: Bool
    ) {
        self.supportID = supportID
        self.name = name
        self.uuid = uuid
        self.creationDate = creationDate
        self.isEnabled = isEnabled
    }
}
