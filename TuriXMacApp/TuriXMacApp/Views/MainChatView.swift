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
            // Header
            HStack {
                Image(systemName: "brain.head.profile")
                    .font(.title)
                    .foregroundColor(.blue)
                
                Text("TuriX")
                    .font(.title)
                    .bold()
                
                Spacer()
                
                Button(action: {}) {
                    Image(systemName: "gearshape")
                }
                .buttonStyle(.borderless)
                .help("Settings")
            }
            .padding()
            .background(Color(NSColor.controlBackgroundColor))
            
            Divider()
            
            // Chat messages
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 15) {
                    if messages.isEmpty {
                        VStack(spacing: 20) {
                            Spacer()
                            
                            Image(systemName: "bubble.left.and.bubble.right")
                                .font(.system(size: 60))
                                .foregroundColor(.secondary)
                            
                            Text("Welcome to TuriX")
                                .font(.title2)
                                .bold()
                            
                            Text("Ask me to perform tasks on your desktop")
                                .foregroundColor(.secondary)
                            
                            VStack(alignment: .leading, spacing: 10) {
                                Text("Example tasks:")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                
                                ExampleTask(text: "Open Chrome and search for news")
                                ExampleTask(text: "Create a new document and write a summary")
                                ExampleTask(text: "Check my email and reply to the latest message")
                            }
                            
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
            
            // Input area
            HStack(alignment: .bottom, spacing: 10) {
                TextEditor(text: $messageText)
                    .frame(minHeight: 40, maxHeight: 100)
                    .padding(8)
                    .background(Color(NSColor.controlBackgroundColor))
                    .cornerRadius(8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.secondary.opacity(0.3), lineWidth: 1)
                    )
                    .disabled(isProcessing)
                
                Button(action: sendMessage) {
                    Image(systemName: isProcessing ? "hourglass" : "arrow.up.circle.fill")
                        .font(.title)
                        .foregroundColor(messageText.isEmpty || isProcessing ? .secondary : .blue)
                }
                .buttonStyle(.borderless)
                .disabled(messageText.isEmpty || isProcessing)
            }
            .padding()
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
        HStack {
            if message.isUser {
                Spacer()
            }
            
            VStack(alignment: message.isUser ? .trailing : .leading, spacing: 5) {
                Text(message.content)
                    .padding(12)
                    .background(message.isUser ? Color.blue : Color(NSColor.controlBackgroundColor))
                    .foregroundColor(message.isUser ? .white : .primary)
                    .cornerRadius(12)
                
                Text(formatTime(message.timestamp))
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
            .frame(maxWidth: 500, alignment: message.isUser ? .trailing : .leading)
            
            if !message.isUser {
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
        HStack {
            Image(systemName: "lightbulb")
                .foregroundColor(.orange)
                .font(.caption)
            
            Text(text)
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
}
