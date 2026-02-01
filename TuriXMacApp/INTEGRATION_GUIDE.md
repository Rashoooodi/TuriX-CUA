# Integration Guide: Connecting macOS GUI to Python Agent

This guide explains how to integrate the TuriX macOS GUI with the Python agent backend.

## Overview

The TuriX system consists of two components:
1. **macOS GUI** (Swift/SwiftUI) - User interface and configuration
2. **Python Agent** (Python) - AI agent that performs tasks

Currently, the GUI generates configuration files that the Python agent reads. For full integration, the GUI needs to communicate with the Python agent in real-time.

## Current State

### What Works Now

✅ **Configuration Generation**
- GUI creates `~/.turix/config.json`
- Python agent reads this config
- Compatible JSON format

✅ **Independent Operation**
- GUI handles setup and configuration
- Python agent runs separately via command line

### What's Not Implemented

❌ **Real-time Communication**
- GUI doesn't start/stop Python agent
- No status updates from agent to GUI
- No task submission from GUI to agent

## Integration Approaches

### Option 1: Process Management (Recommended for MVP)

The GUI spawns and manages the Python agent as a subprocess.

#### Implementation

**In Swift (MainChatView.swift):**

```swift
import Foundation

class AgentManager: ObservableObject {
    @Published var isRunning = false
    @Published var status = "Idle"
    
    private var process: Process?
    private var outputPipe: Pipe?
    
    func startAgent() {
        let pythonPath = "/usr/local/bin/python3"  // Or path to venv
        let scriptPath = Bundle.main.path(forResource: "main", ofType: "py")!
        let configPath = FileManager.default.homeDirectoryForCurrentUser
            .appendingPathComponent(".turix/config.json").path
        
        process = Process()
        process?.executableURL = URL(fileURLWithPath: pythonPath)
        process?.arguments = [scriptPath, "-c", configPath]
        
        // Capture output
        outputPipe = Pipe()
        process?.standardOutput = outputPipe
        process?.standardError = outputPipe
        
        // Handle output
        outputPipe?.fileHandleForReading.readabilityHandler = { [weak self] handle in
            let data = handle.availableData
            if let output = String(data: data, encoding: .utf8) {
                DispatchQueue.main.async {
                    self?.handleAgentOutput(output)
                }
            }
        }
        
        do {
            try process?.run()
            isRunning = true
            status = "Running"
        } catch {
            print("Failed to start agent: \(error)")
        }
    }
    
    func stopAgent() {
        process?.terminate()
        isRunning = false
        status = "Stopped"
    }
    
    func sendTask(_ task: String) {
        // Write to stdin or temp file
        // Python agent polls for tasks
    }
    
    private func handleAgentOutput(_ output: String) {
        // Parse agent status/results
        print("Agent: \(output)")
    }
}
```

**In Python (main.py):**

```python
# Add task queue mechanism
import json
import time
from pathlib import Path

task_file = Path.home() / ".turix" / "current_task.json"

def check_for_new_task():
    if task_file.exists():
        with open(task_file) as f:
            task_data = json.load(f)
        task_file.unlink()  # Remove after reading
        return task_data.get("task")
    return None

# In main loop
while True:
    task = check_for_new_task()
    if task:
        print(f"Executing task: {task}", flush=True)
        # Execute task...
    time.sleep(1)
```

### Option 2: HTTP Server (Better for Production)

The Python agent runs an HTTP server, GUI communicates via REST API.

#### Implementation

**Python Server (server.py):**

```python
from flask import Flask, request, jsonify
import threading
import asyncio

app = Flask(__name__)
agent_instance = None

@app.route('/task', methods=['POST'])
def submit_task():
    task = request.json.get('task')
    # Queue task for agent
    return jsonify({"status": "accepted", "task_id": "123"})

@app.route('/status/<task_id>', methods=['GET'])
def get_status(task_id):
    # Return task status
    return jsonify({"status": "running", "progress": 50})

@app.route('/stop', methods=['POST'])
def stop_agent():
    # Stop current task
    return jsonify({"status": "stopped"})

def run_server():
    app.run(host='localhost', port=5000)

# Start in thread
server_thread = threading.Thread(target=run_server)
server_thread.start()
```

**Swift Client:**

```swift
import Foundation

class AgentClient: ObservableObject {
    @Published var status = "Idle"
    private let baseURL = "http://localhost:5000"
    
    func submitTask(_ task: String) async throws {
        let url = URL(string: "\(baseURL)/task")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body = ["task": task]
        request.httpBody = try JSONEncoder().encode(body)
        
        let (data, _) = try await URLSession.shared.data(for: request)
        let response = try JSONDecoder().decode(TaskResponse.self, from: data)
        
        // Poll for status
        await pollStatus(taskId: response.taskId)
    }
    
    func pollStatus(taskId: String) async {
        let url = URL(string: "\(baseURL)/status/\(taskId)")!
        
        while true {
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                let status = try JSONDecoder().decode(StatusResponse.self, from: data)
                
                DispatchQueue.main.async {
                    self.status = status.status
                }
                
                if status.status == "completed" || status.status == "failed" {
                    break
                }
                
                try await Task.sleep(nanoseconds: 1_000_000_000) // 1 second
            } catch {
                print("Status poll error: \(error)")
                break
            }
        }
    }
}

struct TaskResponse: Codable {
    let status: String
    let taskId: String
}

struct StatusResponse: Codable {
    let status: String
    let progress: Int
}
```

### Option 3: WebSocket (Best for Real-time)

Use WebSockets for bidirectional real-time communication.

**Python (websocket_server.py):**

```python
import asyncio
import websockets
import json

connected_clients = set()

async def handle_client(websocket, path):
    connected_clients.add(websocket)
    try:
        async for message in websocket:
            data = json.loads(message)
            if data['type'] == 'task':
                # Execute task
                await websocket.send(json.dumps({
                    'type': 'status',
                    'status': 'executing'
                }))
                # ... task execution ...
                await websocket.send(json.dumps({
                    'type': 'result',
                    'result': 'Task completed'
                }))
    finally:
        connected_clients.remove(websocket)

async def main():
    async with websockets.serve(handle_client, "localhost", 8765):
        await asyncio.Future()

asyncio.run(main())
```

**Swift:**

```swift
import Foundation

class WebSocketAgent: NSObject, URLSessionWebSocketDelegate {
    private var webSocketTask: URLSessionWebSocketTask?
    
    func connect() {
        let url = URL(string: "ws://localhost:8765")!
        let session = URLSession(configuration: .default, delegate: self, delegateQueue: nil)
        webSocketTask = session.webSocketTask(with: url)
        webSocketTask?.resume()
        receiveMessage()
    }
    
    func sendTask(_ task: String) {
        let message = ["type": "task", "task": task]
        if let data = try? JSONEncoder().encode(message),
           let json = String(data: data, encoding: .utf8) {
            let message = URLSessionWebSocketTask.Message.string(json)
            webSocketTask?.send(message) { error in
                if let error = error {
                    print("Send error: \(error)")
                }
            }
        }
    }
    
    private func receiveMessage() {
        webSocketTask?.receive { [weak self] result in
            switch result {
            case .success(let message):
                switch message {
                case .string(let text):
                    self?.handleMessage(text)
                case .data(let data):
                    if let text = String(data: data, encoding: .utf8) {
                        self?.handleMessage(text)
                    }
                @unknown default:
                    break
                }
                self?.receiveMessage()
            case .failure(let error):
                print("Receive error: \(error)")
            }
        }
    }
    
    private func handleMessage(_ message: String) {
        guard let data = message.data(using: .utf8),
              let json = try? JSONDecoder().decode([String: String].self, from: data) else {
            return
        }
        
        DispatchQueue.main.async {
            if json["type"] == "status" {
                // Update UI with status
            } else if json["type"] == "result" {
                // Show result
            }
        }
    }
}
```

## Recommended Implementation Path

### Phase 1: File-based (Current - Works Now)
1. GUI generates config
2. User manually starts Python agent
3. Agent reads config and runs

### Phase 2: Process Management
1. GUI spawns Python agent subprocess
2. Agent writes status to log files
3. GUI tails log files for updates

### Phase 3: HTTP API
1. Add Flask/FastAPI server to Python agent
2. GUI communicates via HTTP
3. Better status tracking

### Phase 4: WebSocket
1. Real-time bidirectional communication
2. Live progress updates
3. Interactive workflows

## Quick Integration for Testing

### Minimal Integration (10 minutes)

**1. Modify MainChatView.swift:**

```swift
func sendMessage() {
    guard !messageText.isEmpty else { return }
    
    let userMessage = ChatMessage(content: messageText, isUser: true)
    messages.append(userMessage)
    
    // Write task to file
    let taskFile = FileManager.default.homeDirectoryForCurrentUser
        .appendingPathComponent(".turix/current_task.txt")
    try? messageText.write(to: taskFile, atomically: true, encoding: .utf8)
    
    messageText = ""
    isProcessing = true
    
    // Poll for result
    pollForResult()
}

func pollForResult() {
    let resultFile = FileManager.default.homeDirectoryForCurrentUser
        .appendingPathComponent(".turix/task_result.txt")
    
    Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
        if FileManager.default.fileExists(atPath: resultFile.path),
           let result = try? String(contentsOf: resultFile, encoding: .utf8) {
            timer.invalidate()
            
            let response = ChatMessage(content: result, isUser: false)
            self.messages.append(response)
            self.isProcessing = false
            
            try? FileManager.default.removeItem(at: resultFile)
        }
    }
}
```

**2. Modify Python main.py:**

```python
import time
from pathlib import Path

task_file = Path.home() / ".turix" / "current_task.txt"
result_file = Path.home() / ".turix" / "task_result.txt"

while True:
    if task_file.exists():
        task = task_file.read_text()
        task_file.unlink()
        
        print(f"Executing: {task}")
        # ... execute task ...
        result = f"Completed: {task}"
        
        result_file.write_text(result)
    
    time.sleep(1)
```

## Next Steps

1. Choose integration approach based on requirements
2. Implement basic communication
3. Add error handling
4. Test thoroughly
5. Add progress tracking
6. Implement task queuing
7. Add concurrent task support

## Resources

- [URLSession Documentation](https://developer.apple.com/documentation/foundation/urlsession)
- [Flask Documentation](https://flask.palletsprojects.com/)
- [WebSockets Documentation](https://websockets.readthedocs.io/)
- [Process Management](https://developer.apple.com/documentation/foundation/process)

---

**Questions?** Ask on [Discord](https://discord.gg/yaYrNAckb5) or create a [GitHub issue](https://github.com/Rashoooodi/TuriX-CUA/issues).
