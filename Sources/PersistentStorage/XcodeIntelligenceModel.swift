//
//  XcodeIntelligenceModel.swift
//  XCIntelligenceBridge
//
//  Created by treastrain on 2025/08/25.
//

public import Foundation
public import SwiftData

@Model
public final class XcodeIntelligenceModel {
    /// Xcode での Name および Identifier。
    var identifierForXcode: String
    /// モデルプロバイダの識別子。
    public var providerUUID: UUID
    /// ユーザーによって設定されたモデルプロバイダの表示名。
    var providerDisplayName: String
    /// chat.completions リクエストで利用するモデル名。
    public var modelID: String

    public init(
        identifierForXcode: String,
        providerUUID: UUID,
        providerDisplayName: String,
        modelID: String
    ) {
        self.identifierForXcode = identifierForXcode
        self.providerUUID = providerUUID
        self.providerDisplayName = providerDisplayName
        self.modelID = modelID
    }
}
