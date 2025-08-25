//
//  AddGitHubModelsModelProviderView.swift
//  XCIntelligenceBridge
//
//  Created by treastrain on 2025/08/22.
//

import Keychain
import PersistentStorage
import SwiftData
public import SwiftUI

public struct AddGitHubModelsModelProviderView: View {
    let onCompletion: () -> Void
    @State private var token = ""
    @State private var displayName = SupportedModelProvider.githubModels.name
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext

    public init(onCompletion: @escaping () -> Void) {
        self.onCompletion = onCompletion
    }

    public var body: some View {
        VStack {
            Text(SupportedModelProvider.githubModels.name)
                .font(.title.bold())
            Form {
                Section(
                    content: {
                        SecureField(
                            SupportedModelProvider.githubModels.apiKeyLabel,
                            text: $token
                        )
                    },
                    footer: {
                        Text("トークンには **models:read** 権限が付与されている必要があります。")
                    }
                )
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
                            apiKey: token
                        )
                        let provider = ModelProvider(
                            supportID: SupportedModelProvider.githubModels.id,
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
                .disabled(token.isEmpty || displayName.isEmpty)
            }
        }
        .padding()
    }
}
