//
//  SummaryView.swift
//  TuriXMacApp
//
//  Created by TuriX Team
//

import SwiftUI

struct SummaryView: View {
    @ObservedObject var setupState: SetupState
    @Binding var navigationPath: NavigationPath
    @ObservedObject var appState: AppState
    @State private var isCompleted = false
    
    var body: some View {
        VStack(spacing: 30) {
            if !isCompleted {
                Text("Configuration Summary")
                    .font(.largeTitle)
                    .bold()
                
                Text("Review your configuration before finishing")
                    .foregroundColor(.secondary)
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        SummarySection(title: "LLM Configuration") {
                            SummaryRow(label: "Setup Type", value: setupState.llmChoice.displayName)
                            
                            if !setupState.ollamaModels.isEmpty {
                                SummaryRow(label: "Ollama", value: "Connected (\(setupState.ollamaBaseURL))")
                            }
                            
                            if !setupState.googleAPIKey.isEmpty {
                                SummaryRow(label: "Google AI", value: "Configured")
                            }
                        }
                        
                        SummarySection(title: "Model Assignments") {
                            ForEach(ModelRole.allCases, id: \.self) { role in
                                if let assignment = setupState.modelAssignments[role] {
                                    SummaryRow(
                                        label: role.displayName,
                                        value: "\(assignment.provider.displayName): \(assignment.model)"
                                    )
                                }
                            }
                        }
                        
                        SummarySection(title: "Resource Estimates") {
                            SummaryRow(label: "RAM Usage", value: estimatedRAM)
                            SummaryRow(label: "Cost per Task", value: estimatedCost)
                        }
                        
                        SummarySection(title: "Optional Features") {
                            SummaryRow(label: "Discord Integration", value: setupState.enableDiscord ? "Enabled" : "Disabled")
                            SummaryRow(label: "Notifications", value: setupState.enableNotifications ? "Enabled" : "Disabled")
                            SummaryRow(label: "Start Minimized", value: setupState.startMinimized ? "Yes" : "No")
                            SummaryRow(label: "Launch at Login", value: setupState.launchAtLogin ? "Yes" : "No")
                        }
                    }
                }
                
                Spacer()
                
                HStack {
                    Button("Go Back") {
                        navigationPath.removeLast()
                    }
                    .buttonStyle(.bordered)
                    
                    Spacer()
                    
                    Button("Finish Setup") {
                        finishSetup()
                    }
                    .buttonStyle(.borderedProminent)
                    .controlSize(.large)
                }
                .padding(.horizontal)
            } else {
                // Success state
                VStack(spacing: 30) {
                    Spacer()
                    
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 80))
                        .foregroundColor(.green)
                    
                    Text("Setup Complete! 🎉")
                        .font(.largeTitle)
                        .bold()
                    
                    Text("TuriX is now ready to use")
                        .foregroundColor(.secondary)
                    
                    Spacer()
                    
                    Button("Open Chat") {
                        // This will trigger the main view
                        appState.markSetupCompleted()
                    }
                    .buttonStyle(.borderedProminent)
                    .controlSize(.large)
                }
            }
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
    
    func finishSetup() {
        let configuration = setupState.buildConfiguration()
        appState.saveConfiguration(configuration)
        
        withAnimation {
            isCompleted = true
        }
    }
}

struct SummarySection<Content: View>: View {
    let title: String
    @ViewBuilder let content: Content
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(.headline)
            
            VStack(alignment: .leading, spacing: 8) {
                content
            }
            .padding()
            .background(Color(NSColor.textBackgroundColor))
            .cornerRadius(8)
        }
    }
}

struct SummaryRow: View {
    let label: String
    let value: String
    
    var body: some View {
        HStack {
            Text(label)
                .foregroundColor(.secondary)
            Spacer()
            Text(value)
                .bold()
        }
        .font(.caption)
    }
}
