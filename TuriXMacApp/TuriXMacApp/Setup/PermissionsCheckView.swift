//
//  PermissionsCheckView.swift
//  TuriXMacApp
//
//  Created by TuriX Team
//

import SwiftUI
import AVFoundation

struct PermissionsCheckView: View {
    @ObservedObject var setupState: SetupState
    @Binding var navigationPath: NavigationPath
    @State private var refreshTrigger = false
    
    var body: some View {
        VStack(spacing: 30) {
            Text("System Permissions")
                .font(.largeTitle)
                .bold()
            
            Text("TuriX requires certain macOS permissions to function properly")
                .foregroundColor(.secondary)
            
            VStack(alignment: .leading, spacing: 20) {
                PermissionRow(
                    title: "Screen Recording",
                    description: "Required for AI to see your screen",
                    status: setupState.hasScreenRecording,
                    isRequired: true,
                    action: openScreenRecordingSettings
                )
                
                PermissionRow(
                    title: "Accessibility",
                    description: "Required for AI to control your computer",
                    status: setupState.hasAccessibility,
                    isRequired: true,
                    action: openAccessibilitySettings
                )
                
                PermissionRow(
                    title: "Notifications",
                    description: "Optional for task completion alerts",
                    status: setupState.hasNotifications,
                    isRequired: false,
                    action: openNotificationSettings
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
                
                Button("Refresh Status") {
                    checkPermissions()
                }
                .buttonStyle(.bordered)
                
                Button("Continue") {
                    navigationPath.append(SetupStep.llmChoice)
                }
                .buttonStyle(.borderedProminent)
                .disabled(!canContinue)
            }
            .padding(.horizontal)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onAppear {
            checkPermissions()
        }
    }
    
    var canContinue: Bool {
        setupState.hasScreenRecording && setupState.hasAccessibility
    }
    
    func checkPermissions() {
        // Check Screen Recording
        setupState.hasScreenRecording = CGPreflightScreenCaptureAccess()
        
        // Check Accessibility
        let options: NSDictionary = [kAXTrustedCheckOptionPrompt.takeRetainedValue() as String: false]
        setupState.hasAccessibility = AXIsProcessTrustedWithOptions(options)
        
        // Check Notifications (simplified)
        setupState.hasNotifications = true
    }
    
    func openScreenRecordingSettings() {
        let url = URL(string: "x-apple.systempreferences:com.apple.preference.security?Privacy_ScreenCapture")!
        NSWorkspace.shared.open(url)
        
        // Auto-refresh after delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            checkPermissions()
        }
    }
    
    func openAccessibilitySettings() {
        let url = URL(string: "x-apple.systempreferences:com.apple.preference.security?Privacy_Accessibility")!
        NSWorkspace.shared.open(url)
        
        // Auto-refresh after delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            checkPermissions()
        }
    }
    
    func openNotificationSettings() {
        let url = URL(string: "x-apple.systempreferences:com.apple.preference.notifications")!
        NSWorkspace.shared.open(url)
    }
}

struct PermissionRow: View {
    let title: String
    let description: String
    let status: Bool
    let isRequired: Bool
    let action: () -> Void
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 5) {
                HStack {
                    Text(title)
                        .font(.headline)
                    if isRequired {
                        Text("Required")
                            .font(.caption)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(Color.red.opacity(0.2))
                            .foregroundColor(.red)
                            .cornerRadius(4)
                    }
                }
                Text(description)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Text(status ? "✅" : (isRequired ? "❌" : "⚠️"))
                .font(.title2)
            
            Button("Open Settings") {
                action()
            }
            .buttonStyle(.bordered)
            .controlSize(.small)
        }
        .padding()
        .background(Color(NSColor.textBackgroundColor))
        .cornerRadius(8)
    }
}
