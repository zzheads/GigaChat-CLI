//
//  CompletionsRequest.swift
//  GigaChat-CLI
//
//  Created by Алексей Папин on 17.03.2026.
//

struct CompletionsRequest: Codable, Sendable {
    var model: String
    var messages: [Message]
    var temperature: Double?
}

extension CompletionsRequest: NetworkRequest {
    var path: String { "/chat/completions" }
    var method: HTTPMethod { .post }
    var headers: HTTPHeaders? { nil }
    var parameters: [Parameters] {
        guard let json = jsonObject as? [String: Any] else { return [] }
        print(json)
        return [.json(json)]
    }
}
