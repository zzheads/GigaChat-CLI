//
//  Command.swift
//  GigaChat-CLI
//
//  Created by Алексей Папин on 17.03.2026.
//

enum Command: Codable, Sendable {
    static let allCases: [Command] = [.model(0), .temperature(0), .listModels, .message(""), .history, .help]
    
    case model(Int)
    case temperature(Double)
    case listModels
    case message(String)
    case history
    case help
    
    init?(line: String) {
        let components = line.split(separator: " ", maxSplits: 1)
        guard
            let first = components.first,
            let second = components.last,
            let command = Command.allCases.first(where: { $0.id == first }) else {
            return nil
        }
        switch command {
        case .model:
            let modelNumber = Int(second) ?? 1
            self = .model(modelNumber)
        case .temperature:
            let temperature = Double(second) ?? 0
            self = .temperature(temperature)
        case .listModels:
            self = .listModels
        case .message:
            self = .message(String(second))
        case .history:
            self = .history
        case .help:
            self = .help
        }
    }
    
    var id: String {
        switch self {
        case .model:
            "/model"
        case .temperature:
            "/temperature"
        case .listModels:
            "/listModels"
        case .message:
            "/message"
        case .history:
            "/history"
        case .help:
            "/help"
        }
    }
    
    var title: String {
        switch self {
        case .model:
            "/model <Номер модели>"
        case .temperature:
            "/temperature <Значение температуры>"
        case .listModels:
            "/listModels"
        case .message:
            "/message <Сообщение>"
        case .history:
            "/history"
        case .help:
            "/help"
        }
    }
    
    var description: String {
        switch self {
        case .model:
            "Установить текущую модель"
        case .temperature:
            "Установить текущую температуру"
        case .listModels:
            "Показать список доступных моделей"
        case .message:
            "Отправить сообщение"
        case .history:
            "Показать историю"
        case .help:
            "Помощь"
        }
    }
}
