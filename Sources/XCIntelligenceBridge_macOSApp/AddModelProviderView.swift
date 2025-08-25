//
//  AddModelProviderView.swift
//  XCIntelligenceBridge
//
//  Created by treastrain on 2025/08/22.
//

import ModelProvider
import PersistentStorage
import SwiftUI

struct AddModelProviderView: View {
    @State private var selectedProvider: SupportedModelProvider?
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack {
            Text("モデルプロバイダを追加")
                .font(.title.bold())
            Form {
                Section("プロバイダを選択") {
                    ForEach(SupportedModelProvider.allCases) { provider in
                        Button(
                            action: { selectedProvider = provider },
                            label: {
                                Text(provider.name)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                        )
                        .buttonStyle(.borderless)
                    }
                }
            }
            .formStyle(.grouped)
            Divider()
            HStack {
                Spacer()
                Button("キャンセル", role: .cancel) {
                    dismiss()
                }
            }
        }
        .padding()
        .sheet(item: $selectedProvider) {
            switch $0 {
            case .anthropicClaude:
                AddAnthropicClaudeModelProviderView(
                    onCompletion: {
                        dismiss()
                    }
                )
            case .githubModels:
                AddGitHubModelsModelProviderView(
                    onCompletion: {
                        dismiss()
                    }
                )
            case .googleGemini:
                AddGoogleGeminiModelProviderView(
                    onCompletion: {
                        dismiss()
                    }
                )
            default:
                EmptyView()
            }
        }
    }
}
