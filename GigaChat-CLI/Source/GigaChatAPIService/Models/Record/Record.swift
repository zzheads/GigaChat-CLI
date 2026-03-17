//
//  Record.swift
//  GigaChat-CLI
//
//  Created by Алексей Папин on 17.03.2026.
//

import Foundation

struct Record: Codable, Sendable {
    let date: Date
    let model: String
    let message: Message
    let temperature: Double?
    var answer: [Message]
}
