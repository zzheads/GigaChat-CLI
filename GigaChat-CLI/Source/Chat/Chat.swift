//
//  Chat.swift
//  GigaChat-CLI
//
//  Created by Алексей Папин on 14.03.2026.
//

import Foundation

final class Chat {
    private let gigaChatService: GigaChatAPIServiceProtocol
    private let allCommands: [Command] = [.listModels, .model(0), .temperature(0), .message(""), .history, .help]
    private var modelsList: [Model] = []
    private var currentTemperature: Double?
    private var currentModelIndex = 0
    
    init?() {
        guard let baseURL = URL(string: APIConstants.baseURLString),
              let tokenURL = URL(string: APIConstants.tokenURLString) else {
            return nil
        }
        
        self.gigaChatService = GigaChatAPIService(
            baseURL: baseURL,
            tokenURL: tokenURL,
            authKey: APIConstants.authKey
        )
    }
    
    func start() async {
        do {
            let _ = try await gigaChatService.fetchToken(isNeedSet: true)
            let response = try await gigaChatService.fetchModels()
            modelsList = response.data
            await chooseModel()
            showHelp()
            await listen()
        } catch {
            await handle(error: error)
        }
    }
    
    func showHelp() {
        print("Список доступных команд:")
        for command in allCommands {
            print("\(command.title): \(command.description)")
        }
    }
    
    func showModelsList() {
        print("Доступные модели:")
        modelsList.enumerated().forEach { index, model in
            print("\(index + 1). \(model.id) (\(model.object))")
        }
    }
    
    func chooseModel() async {
        print("Выберите модель для общения:")
        showModelsList()
        if let line = readLine()?.trimmingCharacters(in: .whitespacesAndNewlines),
           let choosen = Int(line),
           modelsList.indices.contains(choosen - 1) {
            let model = modelsList[choosen - 1]
            print("Выбрана модель: \(model)")
            currentModelIndex = choosen - 1
        } else {
            await chooseModel()
        }
    }
    
    func send(message: String) async {
        
        guard !modelsList.isEmpty else { return }
        let model = modelsList[currentModelIndex]
        let message = Message(role: .user, content: message)
        do {
            let choices = try await gigaChatService.ask(
                model: model.id,
                message: message,
                temperature: currentTemperature
            )
            print("\n\(model.id): \(choices.first?.message.content ?? "")")
        } catch {
            await handle(error: error)
        }
    }
    
    func handle(error: Error) async {
        print("Произошла ошибка: \(error)")
    }
    
    func listen() async {
        if let line = readLine()?.trimmingCharacters(in: .whitespacesAndNewlines),
           let command = Command(line: line) {
            switch command {
            case .model(let int):
                guard modelsList.indices.contains(int - 1) else { return }
                currentModelIndex = int - 1
            case .temperature(let double):
                currentTemperature = double
            case .listModels:
                showModelsList()
            case .message(let string):
                await send(message: string)
            case .history:
                break
            case .help:
                showHelp()
            }
        }
        await listen()
    }
}
