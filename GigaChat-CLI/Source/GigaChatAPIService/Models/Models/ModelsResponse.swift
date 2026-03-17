//
//  ModelsResponse.swift
//  GigaChat-CLI
//
//  Created by Алексей Папин on 17.03.2026.
//

//{
//  "data": [
//    {
//      "id": "GigaChat:2.0.28.2",
//      "object": "model",
//      "owned_by": "salutedevices"
//    }
//  ],
//  "object": "list"
//}

struct ModelsResponse: Codable, Sendable {
    let data: [Model]
    let object: String
}
