//
//  GigaChatAPIServiceProtocol.swift
//  GigaChat-CLI
//
//  Created by Алексей Папин on 17.03.2026.
//

protocol GigaChatAPIServiceProtocol: AnyObject {
    func fetchToken(isNeedSet: Bool) async throws -> TokenResponse
    func fetchModels() async throws -> ModelsResponse
    func send(request: CompletionsRequest) async throws -> CompletionsResponse
    func ask(model: String, message: Message, temperature: Double?) async throws -> [Choice]
    func ask(model: String, message: Message) async throws -> [Choice]
}

extension GigaChatAPIServiceProtocol {
    func ask(model: String, message: Message) async throws -> [Choice] {
        try await ask(model: model, message: message, temperature: nil)
    }
}
