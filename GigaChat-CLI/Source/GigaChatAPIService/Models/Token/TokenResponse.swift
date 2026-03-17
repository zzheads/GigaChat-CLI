//
//  TokenResponse.swift
//  GigaChat-CLI
//
//  Created by Алексей Папин on 16.03.2026.
//

struct TokenResponse: Codable, Sendable {

    //    Токен для авторизации запросов.
    let accessToken: String
    //    Дата и время истечения действия токена в миллисекундах, в формате unix timestamp.
    let expiresAt: Int
    
    private enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case expiresAt = "expires_at"
    }
}
