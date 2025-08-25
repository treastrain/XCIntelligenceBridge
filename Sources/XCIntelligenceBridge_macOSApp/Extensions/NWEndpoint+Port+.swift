//
//  NWEndpoint+Port+.swift
//  XCIntelligenceBridge
//
//  Created by treastrain on 2025/08/21.
//

import Foundation
import Network

extension NWEndpoint.Port {
    struct FormatStyle: ParseableFormatStyle {
        let parseStrategy: ParseStrategy

        func format(_ value: NWEndpoint.Port) -> String {
            "\(value.rawValue)"
        }
    }

    struct ParseStrategy: Foundation.ParseStrategy {
        func parse(_ value: String) throws -> NWEndpoint.Port {
            if let port = NWEndpoint.Port(value) {
                return port
            } else {
                throw CocoaError(
                    .formatting,
                    userInfo: [
                        NSDebugDescriptionErrorKey: "Cannot parse \(value). Port strings are expected to be numeric values between 0 and 65535"
                    ]
                )
            }
        }
    }
}

extension NWEndpoint.Port {
    func formatted() -> FormatStyle.FormatOutput {
        FormatStyle.port.format(self)
    }
}

extension ParseableFormatStyle where Self == NWEndpoint.Port.FormatStyle {
    static var port: Self { .init(parseStrategy: .port) }
}

extension ParseStrategy where Self == NWEndpoint.Port.ParseStrategy {
    static var port: Self { .init() }
}
