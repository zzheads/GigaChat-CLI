//
//  GigaChatAPIService.swift
//  GigaChat-CLI
//
//  Created by Алексей Папин on 17.03.2026.
//

import Foundation

final class GigaChatAPIService: NSObject {
    private let baseURL: URL
    private let tokenURL: URL
    private let authKey: String
    
    private lazy var tokenService: INetworkService = NetworkService(
        requestBuilder: URLRequestBuilder(baseUrl: tokenURL, dataSource: nil),
        logger: nil
    )
    
    private lazy var networkService: INetworkService = NetworkService(
        requestBuilder: URLRequestBuilder(baseUrl: baseURL, dataSource: nil),
        logger: nil
    )
    
    private var records: [Record] = []
    
    init(baseURL: URL, tokenURL: URL, authKey: String) {
        self.baseURL = baseURL
        self.tokenURL = tokenURL
        self.authKey = authKey
    }
}

extension GigaChatAPIService: GigaChatAPIServiceProtocol {
    
    func fetchToken(isNeedSet: Bool = true) async throws -> TokenResponse {
        let request = TokenRequest(authKey: authKey, scope: .pers)
        let response: TokenResponse = try await tokenService.perform(request)
        if isNeedSet {
            networkService.set(token: response.accessToken)
        }
        return response
    }
    
    func fetchModels() async throws -> ModelsResponse {
        try await networkService.perform(ModelsRequest())
    }
    
    func send(request: CompletionsRequest) async throws -> CompletionsResponse {
        try await networkService.perform(request)
    }
    
    func ask(model: String, message: Message, temperature: Double? = nil) async throws -> [Choice] {
        var record = Record(date: Date(), model: model, message: message, temperature: temperature, answer: [])
        let request = CompletionsRequest(model: model, messages: [message], temperature: temperature)
        let response = try await send(request: request)
        record.answer = response.choices.map { $0.message }
        records.append(record)
        return response.choices
    }
}
