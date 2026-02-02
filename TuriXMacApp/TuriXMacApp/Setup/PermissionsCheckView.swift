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
            // Icon and title
            VStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(
                            RadialGradient(
                                gradient: Gradient(colors: [Color.blue.opacity(0.2), Color.clear]),
                                center: .center,
                                startRadius: 0,
                                endRadius: 50
                            )
                        )
                        .frame(width: 100, height: 100)
                    
                    Image(systemName: "lock.shield.fill")
                        .font(.system(size: 50))
                        .foregroundStyle(
                            LinearGradient(
                                gradient: Gradient(colors: [.blue, .purple]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                }
                
                Text("System Permissions")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Text("TuriX requires certain macOS permissions to function properly")
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
            
            VStack(alignment: .leading, spacing: 16) {
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
            .padding(20)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color(NSColor.controlBackgroundColor).opacity(0.5))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.blue.opacity(0.2), lineWidth: 1)
            )
            
            if !canContinue {
                HStack(spacing: 8) {
                    Image(systemName: "info.circle.fill")
                        .foregroundColor(.orange)
                    Text("Grant required permissions to continue")
                        .font(.callout)
                        .foregroundColor(.secondary)
                }
                .padding(12)
                .background(Color.orange.opacity(0.1))
                .cornerRadius(8)
            }
            
            Spacer()
            
            HStack {
                Button("Back") {
                    navigationPath.removeLast()
                }
                .buttonStyle(.bordered)
                .controlSize(.large)
                
                Spacer()
                
                Button {
                    checkPermissions()
                } label: {
                    HStack(spacing: 6) {
                        Image(systemName: "arrow.clockwise")
                        Text("Refresh Status")
                    }
                }
                .buttonStyle(.bordered)
                .controlSize(.large)
                
                Button("Continue") {
                    navigationPath.append(SetupStep.llmChoice)
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
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
        HStack(spacing: 16) {
            // Status icon with animation
            ZStack {
                Circle()
                    .fill(status ? Color.green.opacity(0.2) : (isRequired ? Color.red.opacity(0.2) : Color.orange.opacity(0.2)))
                    .frame(width: 44, height: 44)
                
                Image(systemName: status ? "checkmark.circle.fill" : (isRequired ? "xmark.circle.fill" : "exclamationmark.triangle.fill"))
                    .font(.title2)
                    .foregroundColor(status ? .green : (isRequired ? .red : .orange))
            }
            
            VStack(alignment: .leading, spacing: 6) {
                HStack(spacing: 8) {
                    Text(title)
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    if isRequired {
                        Text("Required")
                            .font(.caption2)
                            .fontWeight(.medium)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 3)
                            .background(Color.red.opacity(0.15))
                            .foregroundColor(.red)
                            .cornerRadius(6)
                    }
                }
                
                Text(description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            if !status {
                Button {
                    action()
                } label: {
                    HStack(spacing: 6) {
                        Text("Grant")
                        Image(systemName: "arrow.up.forward.square")
                    }
                    .font(.callout)
                    .fontWeight(.medium)
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.small)
                .tint(.blue)
            }
        }
        .padding(16)
        .background(Color(NSColor.textBackgroundColor))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
    }
}
