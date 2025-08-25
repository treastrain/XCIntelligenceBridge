//
//  IntelligenceBridgeServer.swift
//  XCIntelligenceBridge
//
//  Created by treastrain on 2025/08/20.
//

import Foundation
public import Network
public import Observation
import V1ChatCompletionsController
import V1ModelsController

@Observable
public final class IntelligenceBridgeServer {
    public static let defaultPort: NWEndpoint.Port = 8080
    public private(set) var currentState: NetworkListener<TCP>.State = .cancelled
    @ObservationIgnored
    private var currentTask: Task<Void, Never>?

    public init() {}

    public func startServer(
        port: NWEndpoint.Port = defaultPort
    ) {
        currentTask?.cancel()
        currentTask = Task {
            do {
                try await NetworkListener(using: .parameters({ TCP() }).localPort(port))
                    .onStateUpdate { [unowned self] in currentState = $1 }
                    .run { [weak self] in await self?.receive(incoming: $0) }
            } catch {
                print("Error server on port \(port): \(error)")
            }
        }
    }

    public func stopServer() {
        currentTask?.cancel()
        currentTask = nil
        currentState = .cancelled
    }
}

extension IntelligenceBridgeServer {
    private func receive(incoming connection: NetworkConnection<TCP>) async {
        do {
            let firstMessage = try await connection.receive(atMost: 1)
            var content = firstMessage.content
            let remaining = (firstMessage.metadata.other.first as! NWProtocolTCP.Metadata).availableReceiveBuffer
            let (quotient, remainder) = remaining.quotientAndRemainder(dividingBy: UInt32.max)
            for _ in 0..<quotient {
                let message = try await connection.receive(atMost: Int(UInt32.max))
                content.append(message.content)
            }
            let message = try await connection.receive(atMost: Int(remainder))
            content.append(message.content)
            guard let content = String(data: content, encoding: .utf8), let firstLine = content.components(separatedBy: "\r\n").first else { return }
            let components = firstLine.components(separatedBy: " ")
            guard components.indices.contains(1) else { return }
            let endpoint = components[1]
            switch endpoint {
            case "/v1/models?":
                try await v1Models(connection: connection)
            case "/v1/chat/completions":
                try await v1ChatCompletions(connection: connection, content: content)
            default:
                let response = """
                    HTTP/1.1 404 Not Found
                    Content-Length: 0
                    Connection: close
                    """
                let responseData = response.data(using: .utf8)!
                try await connection.send(responseData)
            }
        } catch {
            let body = "\(error)"
            let response = """
                HTTP/1.1 500 Internal Server Error
                Content-Type: text/plain; charset=utf-8
                Content-Length: \(body.utf8.count)
                Connection: close

                \(body)
                """
            let responseData = response.data(using: .utf8)!
            try? await connection.send(responseData)
        }
    }
}

extension IntelligenceBridgeServer {
    private func v1Models(
        connection: NetworkConnection<TCP>
    ) async throws {
        let request = ModelsRequest()
        let body = try await request.response().jsonString
        let response = """
            HTTP/1.1 200 OK
            Content-Type: application/json
            Content-Length: \(body.utf8.count)
            Connection: close

            \(body)
            """
        let responseData = response.data(using: .utf8)!
        try await connection.send(responseData)
    }
}

extension IntelligenceBridgeServer {
    private func v1ChatCompletions(
        connection: NetworkConnection<TCP>,
        content: String
    ) async throws {
        let request = ChatCompletionsRequest(content: content)
        let events = try await request.stream()
        let response = """
            HTTP/1.1 200 OK
            Content-Type: text/event-stream
            """ + "\r\n\r\n"
        let responseData = response.data(using: .utf8)!
        try await connection.send(responseData)
        for try await event in events {
            let eventData = "\(event)\r\n\r\n".data(using: .utf8)!
            try await connection.send(eventData)
        }
    }
}
