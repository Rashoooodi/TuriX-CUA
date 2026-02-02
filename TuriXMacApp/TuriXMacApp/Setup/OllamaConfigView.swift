//
//  OllamaConfigView.swift
//  TuriXMacApp
//
//  Created by TuriX Team
//

import SwiftUI

struct OllamaConfigView: View {
    @ObservedObject var setupState: SetupState
    @Binding var navigationPath: NavigationPath
    
    var body: some View {
        VStack(spacing: 30) {
            Text("Ollama Configuration")
                .font(.largeTitle)
                .bold()
            
            Text("Configure your Ollama connection")
                .foregroundColor(.secondary)
            
            Form {
                Section("Connection Type") {
                    Picker("", selection: $setupState.ollamaConnectionType) {
                        ForEach(OllamaConnectionType.allCases, id: \.self) { type in
                            Text(type.rawValue).tag(type)
                        }
                    }
                    .pickerStyle(.segmented)
                }
                
                if setupState.ollamaConnectionType == .remote {
                    Section("Remote Connection") {
                        TextField("IP Address", text: $setupState.ollamaIP)
                            .textFieldStyle(.roundedBorder)
                        
                        TextField("Port", text: $setupState.ollamaPort)
                            .textFieldStyle(.roundedBorder)
                    }
                }
                
                Section("Connection Status") {
                    HStack {
                        Text(setupState.ollamaConnectionStatus.icon)
                        Text(setupState.ollamaConnectionStatus.message)
                            .foregroundColor(.secondary)
                        
                        Spacer()
                        
                        Button("Test Connection") {
                            testConnection()
                        }
                        .buttonStyle(.bordered)
                        .disabled(setupState.ollamaConnectionStatus == .testing)
                    }
                }
                
                if case .success = setupState.ollamaConnectionStatus,
                   !setupState.ollamaModels.isEmpty {
                    Section("Available Models") {
                        Picker("Select Model", selection: $setupState.selectedOllamaModel) {
                            ForEach(setupState.ollamaModels, id: \.self) { model in
                                Text(model).tag(model)
                            }
                        }
                        .pickerStyle(.menu)
                    }
                }
            }
            .formStyle(.grouped)
            .scrollContentBackground(.hidden)
            
            Spacer()
            
            HStack {
                Button("Back") {
                    navigationPath.removeLast()
                }
                .buttonStyle(.bordered)
                
                Spacer()
                
                if setupState.llmChoice == .hybrid {
                    Button("Continue to Google AI") {
                        navigationPath.append(SetupStep.googleConfig)
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(!canContinue)
                } else {
                    Button("Continue") {
                        navigationPath.append(SetupStep.modelAssignment)
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(!canContinue)
                }
            }
            .padding(.horizontal)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    var canContinue: Bool {
        if case .success = setupState.ollamaConnectionStatus {
            return !setupState.selectedOllamaModel.isEmpty
        }
        return false
    }
    
    func testConnection() {
        setupState.ollamaConnectionStatus = .testing
        
        // Simulate connection test
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            // Mock successful connection with models
            setupState.ollamaModels = [
                "qwen2.5:latest",
                "llama3.2:latest",
                "mistral:latest",
                "gemma2:latest"
            ]
            setupState.selectedOllamaModel = "qwen2.5:latest"
            setupState.ollamaConnectionStatus = .success
        }
    }
}
