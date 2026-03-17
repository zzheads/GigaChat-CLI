//
//  Message.swift
//  GigaChat-CLI
//
//  Created by Алексей Папин on 17.03.2026.
//

struct Message: Codable, Sendable {
    enum Role: String, Codable {
        case user, system, assistant, function
    }
    
    var role: Role
    var content: String
}
