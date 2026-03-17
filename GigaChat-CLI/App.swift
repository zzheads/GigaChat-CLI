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
        guard let chat = Chat() else { return }
                
        let proc = Process()
        proc.executableURL = URL(fileURLWithPath: "/usr/bin/clear")
        try? proc.run()
        proc.waitUntilExit()
        
        print("GigaChat CLI:\n\n\n")
        await chat.start()
    }
}

