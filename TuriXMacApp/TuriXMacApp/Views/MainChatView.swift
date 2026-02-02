//
//  MainChatView.swift
//  TuriXMacApp
//
//  Created by TuriX Team
//

import SwiftUI

struct MainChatView: View {
    @State private var messageText = ""
    @State private var messages: [ChatMessage] = []
    @State private var isProcessing = false
    
    var body: some View {
        VStack(spacing: 0) {
            // Header with gradient
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color.blue.opacity(0.1),
                        Color(NSColor.controlBackgroundColor)
                    ]),
                    startPoint: .leading,
                    endPoint: .trailing
                )
                
                HStack(spacing: 12) {
                    // Logo with glow
                    ZStack {
                        Circle()
                            .fill(Color.blue.opacity(0.2))
                            .frame(width: 44, height: 44)
                        
                        Image(systemName: "brain.head.profile")
                            .font(.title2)
                            .foregroundStyle(
                                LinearGradient(
                                    gradient: Gradient(colors: [.blue, .purple]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                    }
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text("TuriX")
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        Text(isProcessing ? "Working..." : "Ready")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                    
                    Button(action: {}) {
                        Image(systemName: "gearshape.fill")
                            .font(.title3)
                            .foregroundColor(.secondary)
                    }
                    .buttonStyle(.borderless)
                    .help("Settings")
                }
                .padding()
            }
            .frame(height: 70)
            
            Divider()
            
            // Chat messages
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 15) {
                    if messages.isEmpty {
                        VStack(spacing: 25) {
                            Spacer()
                            
                            // Welcome icon with gradient
                            ZStack {
                                Circle()
                                    .fill(
                                        RadialGradient(
                                            gradient: Gradient(colors: [Color.blue.opacity(0.2), Color.clear]),
                                            center: .center,
                                            startRadius: 0,
                                            endRadius: 60
                                        )
                                    )
                                    .frame(width: 120, height: 120)
                                
                                Image(systemName: "bubble.left.and.bubble.right.fill")
                                    .font(.system(size: 60))
                                    .foregroundStyle(
                                        LinearGradient(
                                            gradient: Gradient(colors: [.blue, .purple]),
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                            }
                            
                            Text("Welcome to TuriX")
                                .font(.title)
                                .fontWeight(.bold)
                            
                            Text("Ask me to perform tasks on your desktop")
                                .foregroundColor(.secondary)
                                .font(.body)
                            
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Example tasks:")
                                    .font(.callout)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.secondary)
                                
                                ExampleTask(text: "Open Chrome and search for news")
                                ExampleTask(text: "Create a new document and write a summary")
                                ExampleTask(text: "Check my email and reply to the latest message")
                            }
                            .padding(20)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color(NSColor.controlBackgroundColor).opacity(0.5))
                            )
                            
                            Spacer()
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                    } else {
                        ForEach(messages) { message in
                            ChatBubble(message: message)
                        }
                    }
                }
                .padding()
            }
            
            Divider()
            
            // Input area with better styling
            HStack(alignment: .bottom, spacing: 12) {
                ZStack(alignment: .topLeading) {
                    // Placeholder
                    if messageText.isEmpty {
                        Text("Type your message...")
                            .foregroundColor(.secondary)
                            .padding(.top, 8)
                            .padding(.leading, 12)
                    }
                    
                    TextEditor(text: $messageText)
                        .frame(minHeight: 44, maxHeight: 100)
                        .padding(8)
                        .background(Color(NSColor.controlBackgroundColor))
                        .cornerRadius(12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.blue.opacity(messageText.isEmpty ? 0.2 : 0.5), lineWidth: 1.5)
                        )
                        .disabled(isProcessing)
                        .scrollContentBackground(.hidden)
                }
                
                Button(action: sendMessage) {
                    ZStack {
                        Circle()
                            .fill(
                                messageText.isEmpty || isProcessing
                                ? Color.secondary.opacity(0.2)
                                : LinearGradient(
                                    gradient: Gradient(colors: [.blue, .purple]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 44, height: 44)
                        
                        Image(systemName: isProcessing ? "hourglass" : "arrow.up")
                            .font(.title3)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                    }
                }
                .buttonStyle(.borderless)
                .disabled(messageText.isEmpty || isProcessing)
            }
            .padding(16)
            .background(Color(NSColor.windowBackgroundColor))
        }
    }
    
    func sendMessage() {
        guard !messageText.isEmpty else { return }
        
        let userMessage = ChatMessage(content: messageText, isUser: true)
        messages.append(userMessage)
        messageText = ""
        isProcessing = true
        
        // Simulate AI response
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            let response = ChatMessage(
                content: "I understand you want me to: \(userMessage.content)\n\nThis is a demo interface. To fully execute tasks, the Python agent backend needs to be running. Please refer to the documentation for connecting the GUI to the agent.",
                isUser: false
            )
            messages.append(response)
            isProcessing = false
        }
    }
}

struct ChatMessage: Identifiable {
    let id = UUID()
    let content: String
    let isUser: Bool
    let timestamp = Date()
}

struct ChatBubble: View {
    let message: ChatMessage
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            if message.isUser {
                Spacer()
            } else {
                // AI Avatar
                Circle()
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [.blue.opacity(0.8), .purple.opacity(0.8)]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 32, height: 32)
                    .overlay(
                        Image(systemName: "brain.head.profile")
                            .font(.system(size: 14))
                            .foregroundColor(.white)
                    )
            }
            
            VStack(alignment: message.isUser ? .trailing : .leading, spacing: 6) {
                Text(message.content)
                    .padding(14)
                    .background(
                        message.isUser
                        ? AnyView(
                            LinearGradient(
                                gradient: Gradient(colors: [.blue, .blue.opacity(0.8)]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        : AnyView(Color(NSColor.controlBackgroundColor))
                    )
                    .foregroundColor(message.isUser ? .white : .primary)
                    .cornerRadius(16)
                    .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 1)
                
                Text(formatTime(message.timestamp))
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
            .frame(maxWidth: 500, alignment: message.isUser ? .trailing : .leading)
            
            if message.isUser {
                // User Avatar
                Circle()
                    .fill(Color.secondary.opacity(0.3))
                    .frame(width: 32, height: 32)
                    .overlay(
                        Image(systemName: "person.fill")
                            .font(.system(size: 14))
                            .foregroundColor(.secondary)
                    )
            } else {
                Spacer()
            }
        }
    }
    
    func formatTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

struct ExampleTask: View {
    let text: String
    
    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: "lightbulb.fill")
                .foregroundColor(.orange)
                .font(.body)
            
            Text(text)
                .font(.body)
                .foregroundColor(.primary)
        }
        .padding(.vertical, 4)
    }
}
