//
//  GoogleAIConfigView.swift
//  TuriXMacApp
//
//  Created by TuriX Team
//

import SwiftUI

struct GoogleAIConfigView: View {
    @ObservedObject var setupState: SetupState
    @Binding var navigationPath: NavigationPath
    @State private var showAPIKey = false
    
    var body: some View {
        VStack(spacing: 30) {
            Text("Google AI Configuration")
                .font(.largeTitle)
                .bold()
            
            Text("Configure your Google AI API access")
                .foregroundColor(.secondary)
            
            Form {
                Section("API Key") {
                    HStack {
                        if showAPIKey {
                            TextField("API Key", text: $setupState.googleAPIKey)
                                .textFieldStyle(.roundedBorder)
                        } else {
                            SecureField("API Key", text: $setupState.googleAPIKey)
                                .textFieldStyle(.roundedBorder)
                        }
                        
                        Button(action: { showAPIKey.toggle() }) {
                            Image(systemName: showAPIKey ? "eye.slash" : "eye")
                        }
                        .buttonStyle(.borderless)
                    }
                    
                    Link("Get Free API Key", destination: URL(string: "https://makersuite.google.com/app/apikey")!)
                        .font(.caption)
                }
                
                Section("Model Selection") {
                    Picker("Model", selection: $setupState.selectedGoogleModel) {
                        ForEach(GoogleAIModel.allCases) { model in
                            Text(model.displayName).tag(model)
                        }
                    }
                    .pickerStyle(.menu)
                }
                
                Section("Connection Status") {
                    HStack {
                        Text(setupState.googleConnectionStatus.icon)
                        Text(setupState.googleConnectionStatus.message)
                            .foregroundColor(.secondary)
                        
                        Spacer()
                        
                        Button("Test Connection") {
                            testConnection()
                        }
                        .buttonStyle(.bordered)
                        .disabled(setupState.googleAPIKey.isEmpty || setupState.googleConnectionStatus == .testing)
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
                
                Button("Continue") {
                    navigationPath.append(SetupStep.modelAssignment)
                }
                .buttonStyle(.borderedProminent)
                .disabled(!canContinue)
            }
            .padding(.horizontal)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    var canContinue: Bool {
        if case .success = setupState.googleConnectionStatus {
            return !setupState.googleAPIKey.isEmpty
        }
        return false
    }
    
    func testConnection() {
        setupState.googleConnectionStatus = .testing
        
        // Simulate API test
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            if setupState.googleAPIKey.isEmpty {
                setupState.googleConnectionStatus = .failed("API key is required")
            } else {
                setupState.googleConnectionStatus = .success
            }
        }
    }
}
