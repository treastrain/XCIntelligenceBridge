//
//  ModelProviderView.swift
//  XCIntelligenceBridge
//
//  Created by treastrain on 2025/08/23.
//

import Keychain
import ModelProvider
import PersistentStorage
import SwiftData
import SwiftUI

struct ModelProviderView: View {
    var provider: ModelProvider
    @State private var isEnabled = false
    @State private var apiKey = ""
    @State private var isDisabledFormEditing = true
    @State private var displayName = ""
    @State private var isPresentedRecommendRefreshInXcodeAlert = false
    @State private var isPresentedDeleteAlert = false
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        VStack {
            if let supportedProvider {
                Text(supportedProvider.name)
                    .font(.title.bold())
                Form {
                    Section {
                        Toggle("Xcode に表示", isOn: $isEnabled)
                    }
                    Section {
                        SecureField(
                            supportedProvider.apiKeyLabel,
                            text: $apiKey
                        )
                        .textContentType(.oneTimeCode)
                    }
                    Section {
                        TextField("表示名", text: $displayName)
                    }
                }
                .formStyle(.grouped)
                .disabled(isDisabledFormEditing)
                Divider()
            }
            HStack {
                Button("このモデルプロバイダを削除…") {
                    isPresentedDeleteAlert = true
                }
                Spacer()
                Button("キャンセル", role: .cancel) {
                    dismiss()
                }
                .disabled(supportedProvider == nil)
                Button("OK", role: .confirm) {
                    do {
                        try Keychain.current.updateOrAdd(
                            displayName: displayName,
                            uuid: provider.uuid,
                            apiKey: apiKey
                        )
                        let needsPresentingAlert = (provider.isEnabled != isEnabled || provider.name != displayName)
                        provider.isEnabled = isEnabled
                        provider.name = displayName
                        if needsPresentingAlert {
                            isPresentedRecommendRefreshInXcodeAlert = true
                        } else {
                            dismiss()
                        }
                    } catch {
                    }
                }
                .buttonStyle(.borderedProminent)
                .disabled(supportedProvider == nil || apiKey.isEmpty || displayName.isEmpty)
            }
        }
        .padding()
        .onAppear {
            isEnabled = provider.isEnabled
            do {
                apiKey = try Keychain.current.get(uuid: provider.uuid)
            } catch {
            }
            displayName = provider.name
            Task { isDisabledFormEditing = false }  // Workaround for disable autofocus on text fields
        }
        .alert(
            "Xcode の設定からモデルの再読み込みが必要です",
            isPresented: $isPresentedRecommendRefreshInXcodeAlert,
            actions: {
                Button("OK", role: .confirm) {
                    dismiss()
                }
                .buttonStyle(.borderedProminent)
            },
            message: {
                Text("Xcode の Intelligence の設定から XCIntelligenceBridge を一度無効にしてから再度有効にし、モデル一覧を再読み込みしてください。")
            }
        )
        .alert(
            "\"\(provider.name)\"のモデルプロバイダを削除してもよろしいですか？",
            isPresented: $isPresentedDeleteAlert,
            actions: {
                Button("キャンセル", role: .cancel) {
                    isPresentedDeleteAlert = false
                }
                Button("削除", role: .destructive) {
                    do {
                        try Keychain.current.remove(uuid: provider.uuid)
                        modelContext.delete(provider)
                        dismiss()
                    } catch {
                    }
                }
            },
            message: {
                Text("このモデルプロバイダによって提供されるモデルが Xcode のアシスタントから利用できなくなります。")
            }
        )
    }

    private var supportedProvider: SupportedModelProvider? {
        SupportedModelProvider(by: provider.supportID)
    }
}
