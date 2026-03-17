//
//  CompletionsResponse.swift
//  GigaChat-CLI
//
//  Created by Алексей Папин on 17.03.2026.
//

struct CompletionsResponse: Codable, Sendable {
    let choices: [Choice]
}
