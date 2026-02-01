//
//  OptionalFeaturesView.swift
//  TuriXMacApp
//
//  Created by TuriX Team
//

import SwiftUI

struct OptionalFeaturesView: View {
    @ObservedObject var setupState: SetupState
    @Binding var navigationPath: NavigationPath
    
    var body: some View {
        VStack(spacing: 30) {
            Text("Optional Features")
                .font(.largeTitle)
                .bold()
            
            Text("Choose additional features to enable")
                .foregroundColor(.secondary)
            
            VStack(alignment: .leading, spacing: 20) {
                FeatureToggle(
                    icon: "message.badge",
                    title: "Discord Bot Integration",
                    description: "Enable Discord bot for remote task execution",
                    note: "Can be configured later in settings",
                    isEnabled: $setupState.enableDiscord
                )
                
                FeatureToggle(
                    icon: "bell.badge",
                    title: "Desktop Notifications",
                    description: "Get notified when tasks complete",
                    note: nil,
                    isEnabled: $setupState.enableNotifications
                )
                
                FeatureToggle(
                    icon: "menubar.rectangle",
                    title: "Start Minimized to Menu Bar",
                    description: "App starts in menu bar instead of window",
                    note: nil,
                    isEnabled: $setupState.startMinimized
                )
                
                FeatureToggle(
                    icon: "power",
                    title: "Launch at Login",
                    description: "Automatically start TuriX when you log in",
                    note: nil,
                    isEnabled: $setupState.launchAtLogin
                )
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
                    navigationPath.append(SetupStep.summary)
                }
                .buttonStyle(.borderedProminent)
            }
            .padding(.horizontal)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct FeatureToggle: View {
    let icon: String
    let title: String
    let description: String
    let note: String?
    @Binding var isEnabled: Bool
    
    var body: some View {
        HStack(alignment: .top) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(.blue)
                .frame(width: 30)
            
            VStack(alignment: .leading, spacing: 5) {
                Text(title)
                    .font(.headline)
                
                Text(description)
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                if let note = note {
                    Text(note)
                        .font(.caption2)
                        .foregroundColor(.orange)
                        .italic()
                }
            }
            
            Spacer()
            
            Toggle("", isOn: $isEnabled)
                .labelsHidden()
        }
        .padding()
        .background(Color(NSColor.textBackgroundColor))
        .cornerRadius(8)
    }
}
