//
//  TokenRequest.swift
//  GigaChat-CLI
//
//  Created by Алексей Папин on 16.03.2026.
//

import Foundation

struct TokenRequest: Codable, Sendable {
    
    enum Scope: String, Codable, Sendable {
        //    GIGACHAT_API_PERS — доступ для физических лиц.
        case pers = "GIGACHAT_API_PERS"
        //    GIGACHAT_API_B2B — доступ для ИП и юридических лиц по платным пакетам.
        case b2b = "GIGACHAT_API_B2B"
        //    GIGACHAT_API_CORP — доступ для ИП и юридических лиц по схеме pay-as-you-go.
        case corp = "GIGACHAT_API_CORP"
    }
    
    var rqUID: String
    let authKey: String
    var scope: Scope
    
    init(rqUID: String = UUID().uuidString, authKey: String, scope: Scope = .pers) {
        self.rqUID = rqUID
        self.authKey = authKey
        self.scope = scope
    }
}

extension TokenRequest: NetworkRequest {
    var path: String { "/oauth" }
    
    var method: HTTPMethod { .post }

    var headers: HTTPHeaders? {
        [ Header.contentType(.urlencoded),
          .accept(.json),
          .authorization(authKey),
          .rqUID(rqUID)
        ].headers
    }
    
    var parameters: [Parameters] {
        [.formData(["scope": scope.rawValue])]
    }        
}
