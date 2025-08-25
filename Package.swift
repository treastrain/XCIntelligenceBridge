// swift-tools-version: 6.2

import PackageDescription

let package = Package(
    name: "XCIntelligenceBridge",
    platforms: [.macOS(.v26)],
    products: [
        .library(
            name: "XCIntelligenceBridge",
            targets: [
                "XCIntelligenceBridge_macOSApp"
            ]
        ),
        .library(
            name: "XCIntelligenceBridge_macOSApp",
            targets: [
                "XCIntelligenceBridge_macOSApp"
            ]
        ),
    ],
    targets: [
        .target(
            name: "XCIntelligenceBridge_macOSApp",
            dependencies: [
                "IntelligenceBridgeServer",
                "Keychain",
                "ModelProvider",
                "PersistentStorage",
            ]
        ),
        .target(
            name: "IntelligenceBridgeServer",
            dependencies: [
                "V1ChatCompletionsController",
                "V1ModelsController",
            ]
        ),
        .target(name: "Keychain"),
        .target(
            name: "ModelProvider",
            dependencies: [
                "Keychain",
                "PersistentStorage",
            ]
        ),
        .target(
            name: "PersistentStorage",
            dependencies: ["Keychain"]
        ),
        .target(
            name: "V1ChatCompletionsController",
            dependencies: [
                "ModelProvider",
                "PersistentStorage",
            ]
        ),
        .target(
            name: "V1ModelsController",
            dependencies: [
                "ModelProvider",
                "PersistentStorage",
            ]
        ),
    ],
    swiftLanguageModes: [.v6]
)

// Ref: - https://github.com/treastrain/swift-upcomingfeatureflags-cheatsheet

extension SwiftSetting {
    static let existentialAny: Self = .enableUpcomingFeature("ExistentialAny")  // SE-0335, Swift 5.6,  SwiftPM 5.8+
    static let internalImportsByDefault: Self = .enableUpcomingFeature("InternalImportsByDefault")  // SE-0409, Swift 6.0,  SwiftPM 6.0+
    static let memberImportVisibility: Self = .enableUpcomingFeature("MemberImportVisibility")  // SE-0444, Swift 6.1,  SwiftPM 6.1+
    static let inferIsolatedConformances: Self = .enableUpcomingFeature("InferIsolatedConformances")  // SE-0470, Swift 6.2,  SwiftPM 6.2+
    static let nonisolatedNonsendingByDefault: Self = .enableUpcomingFeature("NonisolatedNonsendingByDefault")  // SE-0461, Swift 6.2,  SwiftPM 6.2+
    static let defaultActorIsolation: Self = .defaultIsolation(MainActor.self)
}

extension SwiftSetting: @retroactive CaseIterable {
    public static var allCases: [Self] {
        [.existentialAny, .internalImportsByDefault, .memberImportVisibility, .inferIsolatedConformances, .nonisolatedNonsendingByDefault, .defaultActorIsolation]
    }
}

package.targets
    .forEach { $0.swiftSettings = SwiftSetting.allCases }
