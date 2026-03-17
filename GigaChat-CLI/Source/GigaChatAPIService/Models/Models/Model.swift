//
//  Model.swift
//  GigaChat-CLI
//
//  Created by Алексей Папин on 17.03.2026.
//

//    {
//      "id": "GigaChat:2.0.28.2",
//      "object": "model",
//      "owned_by": "salutedevices"
//    }

struct Model: Codable, Sendable {
    let id: String
    let object: String
    let ownedBy: String
    let type: String?
    
    private enum CodingKeys: String, CodingKey {
        case id
        case object
        case ownedBy = "owned_by"
        case type
    }
}
