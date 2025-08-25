//
//  ParseableAppStorage.swift
//  XCIntelligenceBridge
//
//  Created by treastrain on 2025/08/24.
//

public import SwiftUI

@propertyWrapper
public struct ParseableAppStorage<
    F: ParseableFormatStyle
> where F.FormatOutput == String {
    let formatStyle: F
    let defaultValue: F.FormatInput
    var base: AppStorage<F.FormatOutput>

    init(
        key: String,
        format: F,
        defaultValue: F.FormatInput,
        store: UserDefaults? = nil
    ) {
        self.formatStyle = format
        self.defaultValue = defaultValue
        self.base = AppStorage(wrappedValue: format.format(defaultValue), key, store: store)
    }

    public var wrappedValue: F.FormatInput {
        get { (try? formatStyle.parseStrategy.parse(base.wrappedValue)) ?? defaultValue }
        nonmutating set { base.wrappedValue = formatStyle.format(newValue) }
    }

    public var projectedValue: Binding<F.FormatInput> {
        Binding(
            get: { wrappedValue },
            set: { wrappedValue = $0 }
        )
    }
}

extension ParseableAppStorage: DynamicProperty {
    public mutating func update() {
        base.update()
    }
}

extension ParseableAppStorage: Sendable {}
