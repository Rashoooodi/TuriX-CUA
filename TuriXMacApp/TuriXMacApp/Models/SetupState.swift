//
//  SetupState.swift
//  TuriXMacApp
//
//  Created by TuriX Team
//

import SwiftUI

class SetupState: ObservableObject {
    @Published var currentStep: Int = 0
    @Published var llmChoice: LLMSetupChoice = .hybrid
    
    // Ollama configuration
    @Published var ollamaConnectionType: OllamaConnectionType = .local
    @Published var ollamaIP: String = ""
    @Published var ollamaPort: String = "11434"
    @Published var ollamaModels: [String] = []
    @Published var ollamaConnectionStatus: ConnectionStatus = .notTested
    @Published var selectedOllamaModel: String = ""
    
    // Google AI configuration
    @Published var googleAPIKey: String = ""
    @Published var selectedGoogleModel: GoogleAIModel = .gemini2Flash
    @Published var googleConnectionStatus: ConnectionStatus = .notTested
    
    // Model assignments
    @Published var modelAssignments: [ModelRole: ModelAssignment] = [
        .brain: ModelAssignment(provider: .googleAI, model: "gemini-2.0-flash"),
        .actor: ModelAssignment(provider: .ollama, model: "qwen2.5:latest"),
        .planner: ModelAssignment(provider: .ollama, model: "qwen2.5:latest"),
        .memory: ModelAssignment(provider: .ollama, model: "qwen2.5:latest")
    ]
    
    // Optional features
    @Published var enableDiscord: Bool = false
    @Published var enableNotifications: Bool = true
    @Published var startMinimized: Bool = false
    @Published var launchAtLogin: Bool = false
    
    // Permissions
    @Published var hasScreenRecording: Bool = false
    @Published var hasAccessibility: Bool = false
    @Published var hasNotifications: Bool = false
    
    var ollamaBaseURL: String {
        if ollamaConnectionType == .local {
            return "http://localhost:\(ollamaPort)"
        } else {
            return "http://\(ollamaIP):\(ollamaPort)"
        }
    }
    
    func buildConfiguration() -> Configuration {
        let brainAssignment = modelAssignments[.brain]!
        let actorAssignment = modelAssignments[.actor]!
        let plannerAssignment = modelAssignments[.planner]!
        let memoryAssignment = modelAssignments[.memory]!
        
        let brainLLM = LLMConfig(
            provider: brainAssignment.provider.rawValue,
            modelName: brainAssignment.model,
            apiKey: brainAssignment.provider == .googleAI ? googleAPIKey : nil,
            baseUrl: brainAssignment.provider == .ollama ? ollamaBaseURL : nil
        )
        
        let actorLLM = LLMConfig(
            provider: actorAssignment.provider.rawValue,
            modelName: actorAssignment.model,
            apiKey: actorAssignment.provider == .googleAI ? googleAPIKey : nil,
            baseUrl: actorAssignment.provider == .ollama ? ollamaBaseURL : nil
        )
        
        let plannerLLM = LLMConfig(
            provider: plannerAssignment.provider.rawValue,
            modelName: plannerAssignment.model,
            apiKey: plannerAssignment.provider == .googleAI ? googleAPIKey : nil,
            baseUrl: plannerAssignment.provider == .ollama ? ollamaBaseURL : nil
        )
        
        let memoryLLM = LLMConfig(
            provider: memoryAssignment.provider.rawValue,
            modelName: memoryAssignment.model,
            apiKey: memoryAssignment.provider == .googleAI ? googleAPIKey : nil,
            baseUrl: memoryAssignment.provider == .ollama ? ollamaBaseURL : nil
        )
        
        return Configuration(
            brainLLM: brainLLM,
            actorLLM: actorLLM,
            plannerLLM: plannerLLM,
            memoryLLM: memoryLLM,
            agent: AgentConfig()
        )
    }
    
    func useRecommendedModels() {
        switch llmChoice {
        case .localOnly:
            modelAssignments[.brain] = ModelAssignment(provider: .ollama, model: "qwen2.5:latest")
            modelAssignments[.actor] = ModelAssignment(provider: .ollama, model: "qwen2.5:latest")
            modelAssignments[.planner] = ModelAssignment(provider: .ollama, model: "qwen2.5:latest")
            modelAssignments[.memory] = ModelAssignment(provider: .ollama, model: "qwen2.5:latest")
        case .cloudOnly:
            modelAssignments[.brain] = ModelAssignment(provider: .googleAI, model: "gemini-2.0-pro")
            modelAssignments[.actor] = ModelAssignment(provider: .googleAI, model: "gemini-2.0-flash")
            modelAssignments[.planner] = ModelAssignment(provider: .googleAI, model: "gemini-2.0-flash")
            modelAssignments[.memory] = ModelAssignment(provider: .googleAI, model: "gemini-1.5-flash")
        case .hybrid:
            modelAssignments[.brain] = ModelAssignment(provider: .googleAI, model: "gemini-2.0-flash")
            modelAssignments[.actor] = ModelAssignment(provider: .ollama, model: "qwen2.5:latest")
            modelAssignments[.planner] = ModelAssignment(provider: .ollama, model: "qwen2.5:latest")
            modelAssignments[.memory] = ModelAssignment(provider: .ollama, model: "qwen2.5:latest")
        }
    }
}

enum OllamaConnectionType: String, CaseIterable {
    case local = "Local"
    case remote = "Remote IP"
}

enum ConnectionStatus {
    case notTested
    case testing
    case success
    case failed(String)
    
    var icon: String {
        switch self {
        case .notTested: return "⚪️"
        case .testing: return "⏳"
        case .success: return "🟢"
        case .failed: return "🔴"
        }
    }
    
    var message: String {
        switch self {
        case .notTested: return "Not tested"
        case .testing: return "Testing..."
        case .success: return "Connected"
        case .failed(let error): return "Failed: \(error)"
        }
    }
}

enum GoogleAIModel: String, CaseIterable, Identifiable {
    case gemini2Flash = "gemini-2.0-flash"
    case gemini2Pro = "gemini-2.0-pro"
    case gemini15Flash = "gemini-1.5-flash"
    case gemini15Pro = "gemini-1.5-pro"
    
    var id: String { rawValue }
    
    var displayName: String {
        switch self {
        case .gemini2Flash: return "Gemini 2.0 Flash (Recommended)"
        case .gemini2Pro: return "Gemini 2.0 Pro"
        case .gemini15Flash: return "Gemini 1.5 Flash"
        case .gemini15Pro: return "Gemini 1.5 Pro"
        }
    }
}

struct ModelAssignment {
    var provider: LLMProvider
    var model: String
}
