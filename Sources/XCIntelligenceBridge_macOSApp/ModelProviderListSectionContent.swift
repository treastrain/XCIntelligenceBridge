//
//  ModelProviderListSectionContent.swift
//  XCIntelligenceBridge
//
//  Created by treastrain on 2025/08/22.
//

import Keychain
import ModelProvider
import PersistentStorage
import SwiftData
import SwiftUI

struct ModelProviderListSectionContent: View {
    @Query(.modelProviders) private var providers: [ModelProvider]
    @State private var selectedProvider: ModelProvider?
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        ForEach(providers) { provider in
            HStack {
                LabeledContent(provider.name) {
                    if !hasAPIKey(provider: provider) {
                        Text("再設定が必要")
                    } else if !provider.isEnabled {
                        Text("無効")
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                Button("詳細", systemImage: "info.circle") {
                    selectedProvider = provider
                }
                .font(.title3)
                .labelStyle(.iconOnly)
                .buttonStyle(.plain)
                .foregroundStyle(.secondary)
            }
        }
        .sheet(item: $selectedProvider) {
            ModelProviderView(provider: $0)
        }
    }

    private func hasAPIKey(provider: ModelProvider) -> Bool {
        (try? Keychain.current.get(uuid: provider.uuid)) != nil
    }
}
