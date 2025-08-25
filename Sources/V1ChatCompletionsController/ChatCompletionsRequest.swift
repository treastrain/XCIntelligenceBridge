//
//  ChatCompletionsRequest.swift
//  XCIntelligenceBridge
//
//  Created by treastrain on 2025/08/24.
//

import Foundation
import ModelProvider
import PersistentStorage
import RegexBuilder
import SwiftData

public nonisolated struct ChatCompletionsRequest: Sendable {
    let content: String

    public init(content: String) {
        self.content = content
    }

    public func stream() async throws -> some AsyncSequence<String, any Error> {
        let contents = content.split(separator: "\r\n")
        let requestHeaders = Headers(rowContents: contents)
        var body = Body(row: String(contents.last ?? ""))
        guard let model = try await model(identifierForXcode: body.model), let provider = try await modelProvider(uuid: model.providerUUID) else {
            throw URLError(.resourceUnavailable)
        }
        body.replaceModel(to: model.id)
        var request = provider.urlRequest(provider.v1ChatCompletionsURL)
        requestHeaders.set(to: &request)
        request.httpBody = body.row.data(using: .utf8)
        let (bytes, response) = try await URLSession.shared.bytes(for: request)
        let httpResponse = response as! HTTPURLResponse
        guard (200..<300).contains(httpResponse.statusCode) else { throw URLError(.badServerResponse) }
        return bytes.lines
    }
}

extension ChatCompletionsRequest {
    private func modelProvider(uuid: UUID) throws -> APIRequestableModelProvider? {
        let container = ModelContainer.shared
        let modelProviders = try container.mainContext.fetch(.modelProvider(by: uuid))
        return try modelProviders.compactMap { try APIRequestableModelProvider(from: $0) }.first
    }

    private func model(identifierForXcode: String) throws -> (id: String, providerUUID: UUID)? {
        let container = ModelContainer.shared
        let models = try container.mainContext.fetch(.model(by: identifierForXcode))
        return models.first.map { ($0.modelID, $0.providerUUID) }
    }
}

private nonisolated struct Headers: Sendable {
    private(set) var contentType: String!
    private(set) var connection: String!
    private(set) var accept: String!
    private(set) var userAgent: String!
    private(set) var acceptLanguage: String!
    private(set) var acceptEncoding: String!

    init(rowContents: [String.SubSequence]) {
        for content in rowContents {
            switch content {
            case _ where content.hasPrefix("Content-Type: "):
                contentType = String(content.replacing("Content-Type: ", with: ""))
            case _ where content.hasPrefix("Connection: "):
                connection = String(content.replacing("Connection: ", with: ""))
            case _ where content.hasPrefix("Accept: "):
                accept = String(content.replacing("Accept: ", with: ""))
            case _ where content.hasPrefix("User-Agent: "):
                userAgent = String(content.replacing("User-Agent: ", with: ""))
            case _ where content.hasPrefix("Accept-Language: "):
                acceptLanguage = String(content.replacing("Accept-Language: ", with: ""))
            case _ where content.hasPrefix("Accept-Encoding: "):
                acceptEncoding = String(content.replacing("Accept-Encoding: ", with: ""))
            default:
                break
            }
        }
    }

    func set(to request: inout URLRequest) {
        request.httpMethod = "POST"
        if let contentType {
            request.addValue(contentType, forHTTPHeaderField: "Content-Type")
        }
        if let connection {
            request.addValue(connection, forHTTPHeaderField: "Connection")
        }
        if let accept {
            request.addValue(accept, forHTTPHeaderField: "Accept")
        }
        if let userAgent {
            request.addValue(userAgent, forHTTPHeaderField: "User-Agent")
        }
        if let acceptLanguage {
            request.addValue(acceptLanguage, forHTTPHeaderField: "Accept-Language")
        }
        if let acceptEncoding {
            request.addValue(acceptEncoding, forHTTPHeaderField: "Accept-Encoding")
        }
    }
}

private nonisolated struct Body: Sendable {
    private(set) var row: String
    private(set) var model: String = ""
    private var modelRawString: String = ""

    init(row: String) {
        self.row = row
        let modelPattern = Regex {
            "\"model\":\""
            Capture {
                OneOrMore(CharacterClass.anyOf("\"").inverted)
            }
            "\""
        }
        if let match = row.firstMatch(of: modelPattern) {
            let modelIdentifier = match.output.1
            modelRawString = String(modelIdentifier)
            model = String(modelIdentifier).replacing("\\/", with: "/")
        }
    }

    mutating func replaceModel(to providerID: String) {
        row.replace(modelRawString, with: providerID, maxReplacements: 1)
    }
}
