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
    @State private var logoScale: CGFloat = 0.8
    @State private var contentOpacity: Double = 0
    
    var body: some View {
        ZStack {
            // Gradient background
            LinearGradient(
                gradient: Gradient(colors: [
                    Color.blue.opacity(0.1),
                    Color.purple.opacity(0.05),
                    Color(NSColor.windowBackgroundColor)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 30) {
                Spacer()
                
                // Animated Logo with glow effect
                ZStack {
                    Circle()
                        .fill(
                            RadialGradient(
                                gradient: Gradient(colors: [Color.blue.opacity(0.3), Color.clear]),
                                center: .center,
                                startRadius: 0,
                                endRadius: 80
                            )
                        )
                        .frame(width: 160, height: 160)
                    
                    Image(systemName: "brain.head.profile")
                        .font(.system(size: 100))
                        .foregroundStyle(
                            LinearGradient(
                                gradient: Gradient(colors: [.blue, .purple]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .shadow(color: .blue.opacity(0.3), radius: 10, x: 0, y: 5)
                }
                .scaleEffect(logoScale)
                
                Text("Welcome to TuriX")
                    .font(.system(size: 48, weight: .bold))
                    .foregroundStyle(
                        LinearGradient(
                            gradient: Gradient(colors: [.primary, .blue]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                
                Text("Desktop Actions, Driven by AI")
                    .font(.title2)
                    .fontWeight(.medium)
                    .foregroundColor(.secondary)
                
                Text("TuriX lets powerful AI models take real, hands-on actions directly on your desktop. Let's get you set up in just a few steps.")
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 80)
                    .padding(.top, 20)
                    .font(.body)
                    .foregroundColor(.secondary)
                
                Spacer()
                
                HStack(spacing: 20) {
                    Button("Skip Setup") {
                        // Use default configuration and skip
                        let defaultConfig = setupState.buildConfiguration()
                        appState.saveConfiguration(defaultConfig)
                        appState.markSetupCompleted()
                    }
                    .buttonStyle(.bordered)
                    .controlSize(.large)
                    
                    Button {
                        navigationPath.append(SetupStep.permissions)
                    } label: {
                        HStack(spacing: 8) {
                            Text("Get Started")
                            Image(systemName: "arrow.right.circle.fill")
                        }
                    }
                    .buttonStyle(.borderedProminent)
                    .controlSize(.large)
                    .tint(.blue)
                }
                .padding(.bottom, 40)
                .opacity(contentOpacity)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onAppear {
            // Animate logo entrance
            withAnimation(.spring(response: 0.8, dampingFraction: 0.6)) {
                logoScale = 1.0
            }
            
            // Fade in content
            withAnimation(.easeIn(duration: 0.8).delay(0.3)) {
                contentOpacity = 1.0
            }
        }
    }
}
