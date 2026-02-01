//
//  TuriXMacAppApp.swift
//  TuriXMacApp
//
//  Created by TuriX Team
//

import SwiftUI

@main
struct TuriXMacAppApp: App {
    @StateObject private var appState = AppState()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(appState)
        }
        .commands {
            CommandGroup(replacing: .appInfo) {
                Button("About TuriX") {
                    // Show about window
                }
            }
        }
        
        Settings {
            SettingsView()
                .environmentObject(appState)
        }
    }
}
