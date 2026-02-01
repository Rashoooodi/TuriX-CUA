//
//  ModelAssignmentView.swift
//  TuriXMacApp
//
//  Created by TuriX Team
//

import SwiftUI

struct ModelAssignmentView: View {
    @ObservedObject var setupState: SetupState
    @Binding var navigationPath: NavigationPath
    
    var body: some View {
        VStack(spacing: 30) {
            Text("Model Role Assignment")
                .font(.largeTitle)
                .bold()
            
            Text("Assign models to different agent roles")
                .foregroundColor(.secondary)
            
            VStack(spacing: 15) {
                ForEach(ModelRole.allCases, id: \.self) { role in
                    ModelRoleRow(
                        role: role,
                        setupState: setupState
                    )
                }
            }
            .padding()
            .background(Color(NSColor.controlBackgroundColor))
            .cornerRadius(10)
            
            Button("Use Recommended Configuration") {
                setupState.useRecommendedModels()
            }
            .buttonStyle(.bordered)
            
            // Resource estimates
            VStack(alignment: .leading, spacing: 10) {
                Text("Estimated Resources")
                    .font(.headline)
                
                HStack {
                    Text("RAM Usage:")
                    Spacer()
                    Text(estimatedRAM)
                        .foregroundColor(.secondary)
                }
                
                HStack {
                    Text("Cost per Task:")
                    Spacer()
                    Text(estimatedCost)
                        .foregroundColor(.secondary)
                }
            }
            .padding()
            .background(Color(NSColor.controlBackgroundColor).opacity(0.5))
            .cornerRadius(8)
            
            Spacer()
            
            HStack {
                Button("Back") {
                    navigationPath.removeLast()
                }
                .buttonStyle(.bordered)
                
                Spacer()
                
                Button("Continue") {
                    navigationPath.append(SetupStep.optionalFeatures)
                }
                .buttonStyle(.borderedProminent)
            }
            .padding(.horizontal)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    var estimatedRAM: String {
        let ollamaCount = setupState.modelAssignments.values.filter { $0.provider == .ollama }.count
        let ramGB = ollamaCount * 4
        return ollamaCount > 0 ? "~\(ramGB)GB" : "Minimal"
    }
    
    var estimatedCost: String {
        let googleCount = setupState.modelAssignments.values.filter { $0.provider == .googleAI }.count
        return googleCount > 0 ? "$0.01 - $0.10" : "Free"
    }
}

struct ModelRoleRow: View {
    let role: ModelRole
    @ObservedObject var setupState: SetupState
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 5) {
                Text(role.displayName)
                    .font(.headline)
                Text(role.description)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Menu {
                Section("Ollama Models") {
                    if !setupState.ollamaModels.isEmpty {
                        ForEach(setupState.ollamaModels, id: \.self) { model in
                            Button(model) {
                                setupState.modelAssignments[role] = ModelAssignment(provider: .ollama, model: model)
                            }
                        }
                    } else {
                        Text("No Ollama models configured")
                            .foregroundColor(.secondary)
                    }
                }
                
                Section("Google AI Models") {
                    if !setupState.googleAPIKey.isEmpty {
                        ForEach(GoogleAIModel.allCases) { model in
                            Button(model.rawValue) {
                                setupState.modelAssignments[role] = ModelAssignment(provider: .googleAI, model: model.rawValue)
                            }
                        }
                    } else {
                        Text("No Google AI configured")
                            .foregroundColor(.secondary)
                    }
                }
            } label: {
                HStack {
                    if let assignment = setupState.modelAssignments[role] {
                        Text("\(assignment.provider.displayName): \(assignment.model)")
                    } else {
                        Text("Select Model")
                    }
                    Image(systemName: "chevron.down")
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(Color.blue.opacity(0.1))
                .cornerRadius(6)
            }
        }
        .padding()
        .background(Color(NSColor.textBackgroundColor))
        .cornerRadius(8)
    }
}
