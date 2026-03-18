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
        guard let authKey = getpass("Введите ваш authKey для доступа к GigaChat:"),
            let chat = Chat(authKey: String(cString: authKey))
        else { return }
                
        let proc = Process()
        proc.executableURL = URL(fileURLWithPath: "/usr/bin/clear")
        try? proc.run()
        proc.waitUntilExit()
        
        await chat.start()
    }
}

