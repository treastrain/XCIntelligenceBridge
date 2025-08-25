//
//  NetworkListener+.swift
//  XCIntelligenceBridge
//
//  Created by treastrain on 2025/08/21.
//

import Foundation
import Network

extension NetworkListener.State: @retroactive CustomStringConvertible {
    var description: String {
        switch self {
        case .setup: String(localized: "セットアップ中")
        case .waiting(let nwError): String(localized: "待機中（\(nwError.localizedDescription)）")
        case .ready: String(localized: "ローカルホストサーバーとして接続可能")
        case .failed(let nwError): String(localized: "失敗（\(nwError.localizedDescription)）")
        case .cancelled: String(localized: "停止中")
        @unknown default: "\(self)"
        }
    }
}
