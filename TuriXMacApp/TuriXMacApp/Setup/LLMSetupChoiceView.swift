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
            // Header with icon
            VStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(
                            RadialGradient(
                                gradient: Gradient(colors: [Color.purple.opacity(0.2), Color.clear]),
                                center: .center,
                                startRadius: 0,
                                endRadius: 50
                            )
                        )
                        .frame(width: 100, height: 100)
                    
                    Image(systemName: "cpu.fill")
                        .font(.system(size: 50))
                        .foregroundStyle(
                            LinearGradient(
                                gradient: Gradient(colors: [.purple, .blue]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                }
                
                Text("LLM Setup")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Text("Choose how you want to run AI models")
                    .foregroundColor(.secondary)
                    .font(.body)
            }
            
            VStack(spacing: 12) {
                ForEach(LLMSetupChoice.allCases, id: \.self) { choice in
                    LLMChoiceRow(
                        choice: choice,
                        isSelected: setupState.llmChoice == choice,
                        isRecommended: choice == .hybrid
                    ) {
                        withAnimation(.spring(response: 0.3)) {
                            setupState.llmChoice = choice
                        }
                    }
                }
            }
            
            Spacer()
            
            HStack {
                Button("Back") {
                    navigationPath.removeLast()
                }
                .buttonStyle(.bordered)
                .controlSize(.large)
                
                Spacer()
                
                Button {
                    navigateToNextStep()
                } label: {
                    HStack(spacing: 6) {
                        Text("Continue")
                        Image(systemName: "arrow.right")
                    }
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
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
    
    var iconName: String {
        switch choice {
        case .localOnly:
            return "desktopcomputer"
        case .cloudOnly:
            return "cloud.fill"
        case .hybrid:
            return "arrow.triangle.merge"
        }
    }
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                // Icon
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(isSelected ? Color.blue.opacity(0.15) : Color.secondary.opacity(0.1))
                        .frame(width: 50, height: 50)
                    
                    Image(systemName: iconName)
                        .font(.title2)
                        .foregroundColor(isSelected ? .blue : .secondary)
                }
                
                VStack(alignment: .leading, spacing: 6) {
                    HStack(spacing: 8) {
                        Text(choice.displayName)
                            .font(.headline)
                            .fontWeight(.semibold)
                            .foregroundColor(.primary)
                        
                        if isRecommended {
                            HStack(spacing: 4) {
                                Image(systemName: "star.fill")
                                    .font(.caption2)
                                Text("Recommended")
                                    .font(.caption2)
                                    .fontWeight(.semibold)
                            }
                            .padding(.horizontal, 8)
                            .padding(.vertical, 3)
                            .background(
                                LinearGradient(
                                    gradient: Gradient(colors: [Color.green.opacity(0.2), Color.green.opacity(0.15)]),
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .foregroundColor(.green)
                            .cornerRadius(6)
                        }
                    }
                    
                    Text(choice.description)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                }
                
                Spacer()
                
                // Selection indicator
                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .font(.title2)
                    .foregroundColor(isSelected ? .blue : .secondary.opacity(0.3))
            }
            .padding(18)
            .background(
                RoundedRectangle(cornerRadius: 14)
                    .fill(isSelected ? Color.blue.opacity(0.08) : Color(NSColor.controlBackgroundColor))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 14)
                    .stroke(isSelected ? Color.blue.opacity(0.5) : Color.clear, lineWidth: 2)
            )
            .shadow(color: isSelected ? Color.blue.opacity(0.1) : Color.clear, radius: 8, x: 0, y: 2)
        }
        .buttonStyle(.plain)
    }
}
