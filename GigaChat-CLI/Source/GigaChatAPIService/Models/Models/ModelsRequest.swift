//
//  ModelsRequest.swift
//  GigaChat-CLI
//
//  Created by Алексей Папин on 17.03.2026.
//

struct ModelsRequest: Codable, Sendable {
    
}

extension ModelsRequest: NetworkRequest {
    var path: String { "/models" }
    var method: HTTPMethod { .get }
    var headers: HTTPHeaders? { nil }    
    var parameters: [Parameters] { [] }
}
