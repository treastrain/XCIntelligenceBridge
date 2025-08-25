//
//  BridgeServerView.swift
//  XCIntelligenceBridge
//
//  Created by treastrain on 2025/08/24.
//

import IntelligenceBridgeServer
import PersistentStorage
import SwiftUI

import enum Network.NWEndpoint
import class Network.NetworkListener

struct BridgeServerView: View {
    @ParseableAppStorage(
        key: .bridgeServerPort,
        defaultValue: IntelligenceBridgeServer.defaultPort,
        format: .port
    ) private var port: NWEndpoint.Port
    @AppStorage(
        key: .launchAppStartsBridgeServer,
        defaultValue: true
    ) private var isEnabledLaunchAppStartsBridgeServer: Bool
    @Environment(IntelligenceBridgeServer.self) private var provider
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack {
            Form {
                Section(
                    content: {
                        TextField(
                            "ポート",
                            value: $port,
                            format: .port,
                            prompt: Text(IntelligenceBridgeServer.defaultPort.formatted())
                        )
                        .autocorrectionDisabled()
                    },
                    footer: {
                        if !isEditable {
                            Text("ポート番号を変更するには、先にブリッジサーバーを停止してください。")
                        }
                    }
                )
                .disabled(!isEditable)
                Section {
                    Toggle("アプリを開いたときにブリッジサーバーを起動する", isOn: $isEnabledLaunchAppStartsBridgeServer)
                }
            }
            .formStyle(.grouped)
            Divider()
            HStack {
                Spacer()
                Button("OK", role: .confirm) {
                    dismiss()
                }
                .buttonStyle(.borderedProminent)
            }
        }
        .padding()
    }

    private var isEditable: Bool {
        switch provider.currentState {
        case .setup, .waiting, .ready: false
        case .failed, .cancelled: true
        @unknown default: true
        }
    }
}
