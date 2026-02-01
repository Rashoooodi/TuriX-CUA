//
//  LLMSetupChoiceView.swift
//  TuriXMacApp
//
//  Created by TuriX Team
//

import SwiftUI

struct LLMSetupChoiceView: View {
    @ObservedObject var setupState: SetupState
    @Binding var navigationPath: NavigationPath
    
    var body: some View {
        VStack(spacing: 30) {
            Text("LLM Setup")
                .font(.largeTitle)
                .bold()
            
            Text("Choose how you want to run AI models")
                .foregroundColor(.secondary)
            
            VStack(spacing: 15) {
                ForEach(LLMSetupChoice.allCases, id: \.self) { choice in
                    LLMChoiceRow(
                        choice: choice,
                        isSelected: setupState.llmChoice == choice,
                        isRecommended: choice == .hybrid
                    ) {
                        setupState.llmChoice = choice
                    }
                }
            }
            .padding()
            .background(Color(NSColor.controlBackgroundColor))
            .cornerRadius(10)
            
            Spacer()
            
            HStack {
                Button("Back") {
                    navigationPath.removeLast()
                }
                .buttonStyle(.bordered)
                
                Spacer()
                
                Button("Continue") {
                    navigateToNextStep()
                }
                .buttonStyle(.borderedProminent)
            }
            .padding(.horizontal)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    func navigateToNextStep() {
        switch setupState.llmChoice {
        case .localOnly:
            navigationPath.append(SetupStep.ollamaConfig)
        case .cloudOnly:
            navigationPath.append(SetupStep.googleConfig)
        case .hybrid:
            navigationPath.append(SetupStep.ollamaConfig)
        }
    }
}

struct LLMChoiceRow: View {
    let choice: LLMSetupChoice
    let isSelected: Bool
    let isRecommended: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(isSelected ? .blue : .gray)
                    .font(.title3)
                
                VStack(alignment: .leading, spacing: 5) {
                    HStack {
                        Text(choice.displayName)
                            .font(.headline)
                            .foregroundColor(.primary)
                        
                        if isRecommended {
                            Text("Recommended")
                                .font(.caption)
                                .padding(.horizontal, 6)
                                .padding(.vertical, 2)
                                .background(Color.green.opacity(0.2))
                                .foregroundColor(.green)
                                .cornerRadius(4)
                        }
                    }
                    
                    Text(choice.description)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
            }
            .padding()
            .background(isSelected ? Color.blue.opacity(0.1) : Color(NSColor.textBackgroundColor))
            .cornerRadius(8)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(isSelected ? Color.blue : Color.clear, lineWidth: 2)
            )
        }
        .buttonStyle(.plain)
    }
}
