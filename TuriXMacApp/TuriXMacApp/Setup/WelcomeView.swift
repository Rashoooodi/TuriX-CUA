//
//  WelcomeView.swift
//  TuriXMacApp
//
//  Created by TuriX Team
//

import SwiftUI

struct WelcomeView: View {
    @ObservedObject var setupState: SetupState
    @Binding var navigationPath: NavigationPath
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        VStack(spacing: 30) {
            Spacer()
            
            // Logo
            Image(systemName: "brain.head.profile")
                .font(.system(size: 100))
                .foregroundColor(.blue)
            
            Text("Welcome to TuriX")
                .font(.system(size: 48, weight: .bold))
            
            Text("Desktop Actions, Driven by AI")
                .font(.title2)
                .foregroundColor(.secondary)
            
            Text("TuriX lets powerful AI models take real, hands-on actions directly on your desktop. Let's get you set up in just a few steps.")
                .multilineTextAlignment(.center)
                .padding(.horizontal, 80)
                .padding(.top, 20)
            
            Spacer()
            
            HStack(spacing: 20) {
                Button("Skip Setup") {
                    // Use default configuration and skip
                    let defaultConfig = setupState.buildConfiguration()
                    appState.saveConfiguration(defaultConfig)
                    appState.markSetupCompleted()
                }
                .buttonStyle(.bordered)
                
                Button("Get Started") {
                    navigationPath.append(SetupStep.permissions)
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
            }
            .padding(.bottom, 40)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(NSColor.windowBackgroundColor))
    }
}
