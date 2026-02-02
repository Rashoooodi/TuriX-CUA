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
    @State private var checkmarkScale: CGFloat = 0
    @State private var successOpacity: Double = 0
    
    var body: some View {
        VStack(spacing: 30) {
            if !isCompleted {
                // Header
                VStack(spacing: 16) {
                    Image(systemName: "checkmark.seal.fill")
                        .font(.system(size: 50))
                        .foregroundStyle(
                            LinearGradient(
                                gradient: Gradient(colors: [.blue, .purple]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                    
                    Text("Configuration Summary")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    Text("Review your configuration before finishing")
                        .foregroundColor(.secondary)
                }
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        SummarySection(title: "LLM Configuration", icon: "cpu") {
                            SummaryRow(label: "Setup Type", value: setupState.llmChoice.displayName)
                            
                            if !setupState.ollamaModels.isEmpty {
                                SummaryRow(label: "Ollama", value: "Connected (\(setupState.ollamaBaseURL))")
                            }
                            
                            if !setupState.googleAPIKey.isEmpty {
                                SummaryRow(label: "Google AI", value: "Configured")
                            }
                        }
                        
                        SummarySection(title: "Model Assignments", icon: "brain") {
                            ForEach(ModelRole.allCases, id: \.self) { role in
                                if let assignment = setupState.modelAssignments[role] {
                                    SummaryRow(
                                        label: role.displayName,
                                        value: "\(assignment.provider.displayName): \(assignment.model)"
                                    )
                                }
                            }
                        }
                        
                        SummarySection(title: "Resource Estimates", icon: "gauge") {
                            SummaryRow(label: "RAM Usage", value: estimatedRAM, icon: "memorychip")
                            SummaryRow(label: "Cost per Task", value: estimatedCost, icon: "dollarsign.circle")
                        }
                        
                        SummarySection(title: "Optional Features", icon: "star") {
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
                    .controlSize(.large)
                    
                    Spacer()
                    
                    Button {
                        finishSetup()
                    } label: {
                        HStack(spacing: 8) {
                            Text("Finish Setup")
                            Image(systemName: "checkmark.circle.fill")
                        }
                    }
                    .buttonStyle(.borderedProminent)
                    .controlSize(.large)
                }
                .padding(.horizontal)
            } else {
                // Success state with animation
                VStack(spacing: 30) {
                    Spacer()
                    
                    ZStack {
                        // Glow effect
                        Circle()
                            .fill(
                                RadialGradient(
                                    gradient: Gradient(colors: [Color.green.opacity(0.3), Color.clear]),
                                    center: .center,
                                    startRadius: 0,
                                    endRadius: 100
                                )
                            )
                            .frame(width: 200, height: 200)
                            .opacity(successOpacity)
                        
                        // Checkmark
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 100))
                            .foregroundStyle(
                                LinearGradient(
                                    gradient: Gradient(colors: [.green, .green.opacity(0.7)]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .scaleEffect(checkmarkScale)
                            .shadow(color: .green.opacity(0.3), radius: 20, x: 0, y: 10)
                    }
                    
                    VStack(spacing: 12) {
                        Text("Setup Complete! 🎉")
                            .font(.system(size: 42, weight: .bold))
                            .opacity(successOpacity)
                        
                        Text("TuriX is now ready to use")
                            .font(.title3)
                            .foregroundColor(.secondary)
                            .opacity(successOpacity)
                    }
                    
                    Spacer()
                    
                    Button {
                        appState.markSetupCompleted()
                    } label: {
                        HStack(spacing: 8) {
                            Text("Open Chat")
                            Image(systemName: "arrow.right.circle.fill")
                        }
                        .font(.title3)
                        .fontWeight(.semibold)
                    }
                    .buttonStyle(.borderedProminent)
                    .controlSize(.large)
                    .tint(.green)
                    .padding(.bottom, 40)
                    .opacity(successOpacity)
                }
                .onAppear {
                    // Animate checkmark
                    withAnimation(.spring(response: 0.6, dampingFraction: 0.6).delay(0.1)) {
                        checkmarkScale = 1.0
                    }
                    
                    // Fade in content
                    withAnimation(.easeIn(duration: 0.5).delay(0.3)) {
                        successOpacity = 1.0
                    }
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
        
        withAnimation(.spring(response: 0.5)) {
            isCompleted = true
        }
    }
}

struct SummarySection<Content: View>: View {
    let title: String
    var icon: String = "info.circle"
    @ViewBuilder let content: Content
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 8) {
                Image(systemName: icon + ".fill")
                    .foregroundColor(.blue)
                Text(title)
                    .font(.headline)
                    .fontWeight(.semibold)
            }
            
            VStack(alignment: .leading, spacing: 10) {
                content
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(NSColor.controlBackgroundColor).opacity(0.5))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.blue.opacity(0.1), lineWidth: 1)
            )
        }
    }
}

struct SummaryRow: View {
    let label: String
    let value: String
    var icon: String? = nil
    
    var body: some View {
        HStack {
            if let icon = icon {
                Image(systemName: icon)
                    .foregroundColor(.secondary)
                    .frame(width: 16)
            }
            Text(label)
                .foregroundColor(.secondary)
            Spacer()
            Text(value)
                .fontWeight(.medium)
        }
        .font(.subheadline)
    }
}
