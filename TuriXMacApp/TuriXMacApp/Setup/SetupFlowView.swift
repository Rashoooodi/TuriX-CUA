//
//  SetupFlowView.swift
//  TuriXMacApp
//
//  Created by TuriX Team
//

import SwiftUI

struct SetupFlowView: View {
    @EnvironmentObject var appState: AppState
    @StateObject private var setupState = SetupState()
    @State private var navigationPath = NavigationPath()
    
    var body: some View {
        NavigationStack(path: $navigationPath) {
            WelcomeView(setupState: setupState, navigationPath: $navigationPath)
                .navigationDestination(for: SetupStep.self) { step in
                    viewForStep(step)
                }
        }
    }
    
    @ViewBuilder
    func viewForStep(_ step: SetupStep) -> some View {
        switch step {
        case .permissions:
            PermissionsCheckView(setupState: setupState, navigationPath: $navigationPath)
        case .llmChoice:
            LLMSetupChoiceView(setupState: setupState, navigationPath: $navigationPath)
        case .ollamaConfig:
            OllamaConfigView(setupState: setupState, navigationPath: $navigationPath)
        case .googleConfig:
            GoogleAIConfigView(setupState: setupState, navigationPath: $navigationPath)
        case .modelAssignment:
            ModelAssignmentView(setupState: setupState, navigationPath: $navigationPath)
        case .optionalFeatures:
            OptionalFeaturesView(setupState: setupState, navigationPath: $navigationPath)
        case .summary:
            SummaryView(setupState: setupState, navigationPath: $navigationPath, appState: appState)
        }
    }
}

enum SetupStep: Hashable {
    case permissions
    case llmChoice
    case ollamaConfig
    case googleConfig
    case modelAssignment
    case optionalFeatures
    case summary
}
