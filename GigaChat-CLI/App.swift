//
//  main.swift
//  GigaChat-CLI
//
//  Created by Алексей Папин on 14.03.2026.
//

import Foundation

@main
struct App {
    static func main() async {
        print("GigaChat CLI")
        let prompt = "Введите ваш authKey для доступа к GigaChat:"
        let authKey: String
        if let raw = getpass(prompt) {
            authKey = String(cString: raw)
        } else {
            print(prompt, terminator: " ")
            guard let line = readLine(), !line.isEmpty else { return }
            authKey = line
        }
        guard let chat = Chat(authKey: authKey) else { return }
                
        let proc = Process()
        proc.executableURL = URL(fileURLWithPath: "/usr/bin/clear")
        try? proc.run()
        proc.waitUntilExit()
        
        await chat.start()
    }
}
