//
//  SettingsView.swift
//  TuriXMacApp
//
//  Created by TuriX Team
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var appState: AppState
    @State private var selectedTab: SettingsTab = .general
    
    var body: some View {
        TabView(selection: $selectedTab) {
            GeneralSettingsView()
                .tabItem {
                    Label("General", systemImage: "gearshape")
                }
                .tag(SettingsTab.general)
            
            LLMSettingsView()
                .tabItem {
                    Label("LLM", systemImage: "brain")
                }
                .tag(SettingsTab.llm)
            
            AdvancedSettingsView()
                .tabItem {
                    Label("Advanced", systemImage: "slider.horizontal.3")
                }
                .tag(SettingsTab.advanced)
            
            AboutSettingsView()
                .tabItem {
                    Label("About", systemImage: "info.circle")
                }
                .tag(SettingsTab.about)
        }
        .frame(width: 600, height: 400)
    }
}

enum SettingsTab {
    case general
    case llm
    case advanced
    case about
}

struct GeneralSettingsView: View {
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        Form {
            Section("Appearance") {
                Toggle("Start minimized to menu bar", isOn: .constant(false))
                Toggle("Launch at login", isOn: .constant(false))
            }
            
            Section("Notifications") {
                Toggle("Desktop notifications", isOn: .constant(true))
                Toggle("Sound notifications", isOn: .constant(false))
            }
            
            Section("Setup") {
                Button("Reset Setup Wizard") {
                    appState.resetSetup()
                }
                .foregroundColor(.red)
            }
        }
        .formStyle(.grouped)
        .padding()
    }
}

struct LLMSettingsView: View {
    var body: some View {
        Form {
            Section("Current Configuration") {
                Text("Brain: Google AI - gemini-2.0-flash")
                Text("Actor: Ollama - qwen2.5:latest")
                Text("Planner: Ollama - qwen2.5:latest")
                Text("Memory: Ollama - qwen2.5:latest")
            }
            
            Section {
                Button("Reconfigure Models") {
                    // Open setup wizard at model assignment step
                }
            }
        }
        .formStyle(.grouped)
        .padding()
    }
}

struct AdvancedSettingsView: View {
    var body: some View {
        Form {
            Section("Agent Configuration") {
                Text("Max Actions per Step: 5")
                Text("Max Steps: 100")
                Text("Memory Budget: 2000")
            }
            
            Section("Features") {
                Toggle("Use UI mode", isOn: .constant(false))
                Toggle("Use search", isOn: .constant(true))
                Toggle("Use skills", isOn: .constant(true))
            }
            
            Section("Hotkeys") {
                Text("Force Stop: Command+Shift+2")
            }
        }
        .formStyle(.grouped)
        .padding()
    }
}

struct AboutSettingsView: View {
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "brain.head.profile")
                .font(.system(size: 80))
                .foregroundColor(.blue)
            
            Text("TuriX")
                .font(.largeTitle)
                .bold()
            
            Text("Desktop Actions, Driven by AI")
                .foregroundColor(.secondary)
            
            Text("Version 0.3.0")
                .font(.caption)
                .foregroundColor(.secondary)
            
            Divider()
                .padding(.horizontal, 50)
            
            VStack(spacing: 10) {
                Link("Documentation", destination: URL(string: "https://github.com/Rashoooodi/TuriX-CUA")!)
                Link("Discord Community", destination: URL(string: "https://discord.gg/yaYrNAckb5")!)
                Link("Report Issues", destination: URL(string: "https://github.com/Rashoooodi/TuriX-CUA/issues")!)
            }
            
            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
