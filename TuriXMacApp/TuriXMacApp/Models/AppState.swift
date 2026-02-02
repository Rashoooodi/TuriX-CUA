//
//  AppState.swift
//  TuriXMacApp
//
//  Created by TuriX Team
//

import SwiftUI

class AppState: ObservableObject {
    @Published var setupCompleted: Bool = false
    @Published var configuration: Configuration?
    
    init() {
        loadSetupStatus()
        if setupCompleted {
            loadConfiguration()
        }
    }
    
    func loadSetupStatus() {
        let configPath = FileManager.default.homeDirectoryForCurrentUser
            .appendingPathComponent(".turix")
            .appendingPathComponent("setup_completed")
        setupCompleted = FileManager.default.fileExists(atPath: configPath.path)
    }
    
    func markSetupCompleted() {
        let turixDir = FileManager.default.homeDirectoryForCurrentUser
            .appendingPathComponent(".turix")
        
        // Create directory if it doesn't exist
        try? FileManager.default.createDirectory(at: turixDir, withIntermediateDirectories: true)
        
        let flagPath = turixDir.appendingPathComponent("setup_completed")
        FileManager.default.createFile(atPath: flagPath.path, contents: Data())
        setupCompleted = true
    }
    
    func resetSetup() {
        let flagPath = FileManager.default.homeDirectoryForCurrentUser
            .appendingPathComponent(".turix")
            .appendingPathComponent("setup_completed")
        try? FileManager.default.removeItem(at: flagPath)
        setupCompleted = false
    }
    
    func loadConfiguration() {
        let configPath = FileManager.default.homeDirectoryForCurrentUser
            .appendingPathComponent(".turix")
            .appendingPathComponent("config.json")
        
        guard let data = try? Data(contentsOf: configPath),
              let config = try? JSONDecoder().decode(Configuration.self, from: data) else {
            return
        }
        
        configuration = config
    }
    
    func saveConfiguration(_ config: Configuration) {
        let turixDir = FileManager.default.homeDirectoryForCurrentUser
            .appendingPathComponent(".turix")
        
        // Create directory if it doesn't exist
        try? FileManager.default.createDirectory(at: turixDir, withIntermediateDirectories: true)
        
        let configPath = turixDir.appendingPathComponent("config.json")
        
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        
        if let data = try? encoder.encode(config) {
            try? data.write(to: configPath)
            configuration = config
        }
    }
}
