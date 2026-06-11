//
//  ClairApp.swift
//  Clair
//
//  Created by olivia on 11/06/2026.
//

import SwiftUI

@main
struct ClairApp: App {
    var body: some Scene {
        WindowGroup {
            MainWindowView()
        }
        .commands {
            CommandGroup(
                replacing: .newItem,
                addition: {
                    Button("New document") {
                        // TODO: implement
                    }
                    .keyboardShortcut("n", modifiers: .command)
                }
            )
        }
    }
}
