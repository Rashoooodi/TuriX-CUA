//
//  Configuration.swift
//  TuriXMacApp
//
//  Created by TuriX Team
//

import Foundation

struct Configuration: Codable {
    var loggingLevel: String = "DEBUG"
    var outputDir: String = ".turix_tmp"
    var brainLLM: LLMConfig
    var actorLLM: LLMConfig
    var plannerLLM: LLMConfig
    var memoryLLM: LLMConfig
    var agent: AgentConfig
    
    enum CodingKeys: String, CodingKey {
        case loggingLevel = "logging_level"
        case outputDir = "output_dir"
        case brainLLM = "brain_llm"
        case actorLLM = "actor_llm"
        case plannerLLM = "planner_llm"
        case memoryLLM = "memory_llm"
        case agent
    }
}

struct LLMConfig: Codable {
    var provider: String
    var modelName: String
    var apiKey: String?
    var baseUrl: String?
    
    enum CodingKeys: String, CodingKey {
        case provider
        case modelName = "model_name"
        case apiKey = "api_key"
        case baseUrl = "base_url"
    }
}

struct AgentConfig: Codable {
    var task: String = ""
    var memoryBudget: Int = 2000
    var summaryMemoryBudget: Int = 8000
    var useUI: Bool = false
    var useSearch: Bool = false
    var useSkills: Bool = true
    var skillsDir: String = "skills"
    var skillsMaxChars: Int = 4000
    var usePlan: Bool = true
    var maxActionsPerStep: Int = 5
    var maxSteps: Int = 100
    var forceStopHotkey: String = "command+shift+2"
    var useTurix: Bool = true
    var resume: Bool = false
    var agentId: String?
    var saveBrainConversationPath: String = "brain_llm_interactions.log"
    var saveActorConversationPath: String = "actor_llm_interactions.log"
    var savePlannerConversationPath: String = "planner_llm_interactions.log"
    var saveBrainConversationPathEncoding: String = "utf-8"
    var saveActorConversationPathEncoding: String = "utf-8"
    var savePlannerConversationPathEncoding: String = "utf-8"
    
    enum CodingKeys: String, CodingKey {
        case task
        case memoryBudget = "memory_budget"
        case summaryMemoryBudget = "summary_memory_budget"
        case useUI = "use_ui"
        case useSearch = "use_search"
        case useSkills = "use_skills"
        case skillsDir = "skills_dir"
        case skillsMaxChars = "skills_max_chars"
        case usePlan = "use_plan"
        case maxActionsPerStep = "max_actions_per_step"
        case maxSteps = "max_steps"
        case forceStopHotkey = "force_stop_hotkey"
        case useTurix = "use_turix"
        case resume
        case agentId = "agent_id"
        case saveBrainConversationPath = "save_brain_conversation_path"
        case saveActorConversationPath = "save_actor_conversation_path"
        case savePlannerConversationPath = "save_planner_conversation_path"
        case saveBrainConversationPathEncoding = "save_brain_conversation_path_encoding"
        case saveActorConversationPathEncoding = "save_actor_conversation_path_encoding"
        case savePlannerConversationPathEncoding = "save_planner_conversation_path_encoding"
    }
}

// Setup-specific models
enum LLMProvider: String, CaseIterable, Identifiable {
    case ollama = "ollama"
    case googleAI = "google_flash"
    
    var id: String { rawValue }
    
    var displayName: String {
        switch self {
        case .ollama: return "Ollama (Local)"
        case .googleAI: return "Google AI (Cloud)"
        }
    }
}

enum LLMSetupChoice: String, CaseIterable {
    case localOnly = "local"
    case cloudOnly = "cloud"
    case hybrid = "hybrid"
    
    var displayName: String {
        switch self {
        case .localOnly: return "Local Only (Ollama)"
        case .cloudOnly: return "Cloud (Google AI)"
        case .hybrid: return "Hybrid"
        }
    }
    
    var description: String {
        switch self {
        case .localOnly:
            return "Free, private, requires ~16GB RAM"
        case .cloudOnly:
            return "Best performance, API costs"
        case .hybrid:
            return "Mix of local and cloud models (Recommended)"
        }
    }
}

enum ModelRole: String, CaseIterable, Hashable {
    case brain = "brain"
    case actor = "actor"
    case planner = "planner"
    case memory = "memory"
    
    var displayName: String {
        switch self {
        case .brain: return "🧠 Brain"
        case .actor: return "🎭 Actor"
        case .planner: return "📝 Planner"
        case .memory: return "💾 Memory"
        }
    }
    
    var description: String {
        switch self {
        case .brain: return "Main reasoning"
        case .actor: return "Action execution"
        case .planner: return "Task planning"
        case .memory: return "Context management"
        }
    }
}
