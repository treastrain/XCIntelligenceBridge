//
//  ContentView.swift
//  XCIntelligenceBridge
//
//  Created by treastrain on 2025/08/20.
//

import IntelligenceBridgeServer
import PersistentStorage
import SwiftUI

import enum Network.NWEndpoint
import class Network.NetworkListener

struct ContentView: View {
    @ParseableAppStorage(
        key: .bridgeServerPort,
        defaultValue: IntelligenceBridgeServer.defaultPort,
        format: .port
    ) private var port: NWEndpoint.Port
    @AppStorage(
        key: .launchAppStartsBridgeServer,
        defaultValue: true
    ) private var isEnabledLaunchAppStartsBridgeServer: Bool
    @State private var isOn = false
    @State private var isPresentedBridgeServerView = false
    @State private var isPresentedAddModelProviderView = false
    @Environment(IntelligenceBridgeServer.self) private var provider

    var body: some View {
        Form {
            Section {
                HStack {
                    Image(.icon)
                        .resizable()
                        .antialiased(true)
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 50)
                        .padding()
                    VStack(alignment: .leading) {
                        Text("XCIntelligenceBridge")
                            .font(.title.bold())
                        Text(version)
                            .foregroundStyle(.secondary)
                            .font(.caption)
                            .textSelection(.enabled)
                        Text("Developed by [@treastrain](https://treastrain.jp)")
                            .foregroundStyle(.secondary)
                            .padding(.top, .leastNonzeroMagnitude)
                    }
                }
            }
            Section {
                Label(
                    title: {
                        HStack(alignment: .firstTextBaseline) {
                            Toggle(
                                isOn: $isOn,
                                label: {
                                    VStack(alignment: .leading) {
                                        Text("ブリッジサーバー")
                                        status
                                    }
                                }
                            )
                            .toggleStyle(.switch)
                            Button("詳細", systemImage: "info.circle") {
                                isPresentedBridgeServerView = true
                            }
                            .font(.title3)
                            .labelStyle(.iconOnly)
                            .buttonStyle(.plain)
                            .foregroundStyle(.secondary)
                        }
                    },
                    icon: {
                        RoundedRectangle(cornerRadius: 6)
                            .fill(.blue.gradient.blendMode(.screen))
                            .strokeBorder(.gray, lineWidth: 2 / 3)
                            .frame(width: 27, height: 27)
                            .overlay {
                                Image(systemName: "internaldrive")
                                    .imageScale(.large)
                                    .foregroundStyle(.primary)
                                    .bold()
                            }
                    }
                )
            }
            Section(
                content: {
                    ModelProviderListSectionContent()
                },
                header: {
                    Text("モデルプロバイダ")
                },
                footer: {
                    HStack {
                        Spacer()
                        Button("モデルプロバイダを追加…") {
                            isPresentedAddModelProviderView = true
                        }
                    }
                }
            )
        }
        .formStyle(.grouped)
        .onChange(of: isOn) {
            if $1 {
                provider.startServer(port: port)
            } else {
                provider.stopServer()
            }
        }
        .task {
            if isEnabledLaunchAppStartsBridgeServer {
                isOn = true
            }
        }
        .sheet(isPresented: $isPresentedBridgeServerView) {
            BridgeServerView()
        }
        .sheet(isPresented: $isPresentedAddModelProviderView) {
            AddModelProviderView()
        }
    }

    private var version: String {
        var version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
        #if DEBUG
            version += " (Debug)"
        #endif
        return version
    }

    private var status: some View {
        let state = provider.currentState
        return Label(
            title: {
                Text(verbatim: "\(state)")
                    .foregroundStyle(.secondary)
            },
            icon: {
                let image = Image(systemName: "circlebadge.fill")
                switch state {
                case .setup, .waiting:
                    image
                        .hidden()
                        .overlay {
                            ProgressView()
                                .controlSize(.small)
                        }
                case .ready:
                    image.foregroundStyle(.green)
                case .failed, .cancelled:
                    image.foregroundStyle(.red)
                @unknown default:
                    image.foregroundStyle(.purple)
                }
            }
        )
        .font(.callout)
        .labelStyle(.status)
        .padding(.top, .leastNonzeroMagnitude)
    }
}

private nonisolated struct StatusLabelStyle: LabelStyle {
    func makeBody(configuration: Configuration) -> some View {
        HStack(alignment: .firstTextBaseline) {
            configuration.icon
            configuration.title
        }
    }
}

extension LabelStyle where Self == StatusLabelStyle {
    fileprivate static var status: StatusLabelStyle { .init() }
}
