//
//  XCIntelligenceBridge_macOSApp.swift
//  XCIntelligenceBridge
//
//  Created by treastrain on 2025/08/20.
//

import IntelligenceBridgeServer
import PersistentStorage
import SwiftData
public import SwiftUI

public struct XCIntelligenceBridgeMacOSApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @State var provider = IntelligenceBridgeServer()

    public init() {}

    public var body: some Scene {
        Window(Text("XCIntelligenceBridge"), id: "MainWindow") {
            ContentView()
        }
        .modelContainer(.shared)
        .defaultAppStorage(UserDefaults(suiteName: AppGroup.name) ?? .standard)
        .environment(provider)
    }
}

final class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        // TODO: Make this configurable in settings
        false
    }
}
