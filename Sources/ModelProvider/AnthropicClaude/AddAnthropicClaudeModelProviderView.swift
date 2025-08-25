//
//  AddAnthropicClaudeModelProviderView.swift
//  XCIntelligenceBridge
//
//  Created by treastrain on 2025/08/22.
//

import Keychain
import PersistentStorage
import SwiftData
public import SwiftUI

public struct AddAnthropicClaudeModelProviderView: View {
    let onCompletion: () -> Void
    @State private var xAPIKey = ""
    @State private var displayName = SupportedModelProvider.anthropicClaude.name
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext

    public init(onCompletion: @escaping () -> Void) {
        self.onCompletion = onCompletion
    }

    public var body: some View {
        VStack {
            Text(SupportedModelProvider.anthropicClaude.name)
                .font(.title.bold())
            Form {
                Section {
                    SecureField(
                        SupportedModelProvider.anthropicClaude.apiKeyLabel,
                        text: $xAPIKey
                    )
                }
                Section {
                    TextField("表示名", text: $displayName)
                }
            }
            .formStyle(.grouped)
            HStack {
                Spacer()
                Button("キャンセル", role: .cancel) {
                    dismiss()
                }
                Button("OK", role: .confirm) {
                    do {
                        let uuid = UUID()
                        try Keychain.current.add(
                            displayName: displayName,
                            uuid: uuid,
                            apiKey: xAPIKey
                        )
                        let provider = ModelProvider(
                            supportID: SupportedModelProvider.anthropicClaude.id,
                            name: displayName,
                            uuid: uuid,
                            creationDate: .now,
                            isEnabled: true
                        )
                        modelContext.insert(provider)
                        dismiss()
                        onCompletion()
                    } catch {
                    }
                }
                .buttonStyle(.borderedProminent)
                .disabled(xAPIKey.isEmpty || displayName.isEmpty)
            }
        }
        .padding()
    }
}
