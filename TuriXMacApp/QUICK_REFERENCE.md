# TuriX macOS App - Quick Reference

## 🚀 Quick Start

### Build & Run
```bash
cd TuriXMacApp
open TuriXMacApp.xcodeproj  # Opens in Xcode
# Press Cmd+R to build and run
```

### First Launch
1. Grant Screen Recording permission
2. Grant Accessibility permission  
3. Complete 7-step setup wizard
4. Start using chat interface

## 📁 Project Structure

```
TuriXMacApp/
├── 📱 TuriXMacAppApp.swift          Main entry point
├── 📱 ContentView.swift             Root view (setup or chat)
├── 📂 Models/
│   ├── AppState.swift               Global app state
│   ├── Configuration.swift          Config data models
│   └── SetupState.swift             Setup wizard state
├── 📂 Setup/                        7-step setup wizard
│   ├── SetupFlowView.swift          Navigation controller
│   ├── WelcomeView.swift            Step 1: Welcome
│   ├── PermissionsCheckView.swift   Step 2: Permissions
│   ├── LLMSetupChoiceView.swift     Step 3: LLM choice
│   ├── OllamaConfigView.swift       Step 4A: Ollama
│   ├── GoogleAIConfigView.swift     Step 4B: Google AI
│   ├── ModelAssignmentView.swift    Step 5: Model roles
│   ├── OptionalFeaturesView.swift   Step 6: Features
│   └── SummaryView.swift            Step 7: Summary
└── 📂 Views/
    ├── MainChatView.swift           Chat interface
    └── SettingsView.swift           Settings window
```

## 🎯 Setup Wizard Flow

```
1. Welcome
   ├─→ Skip Setup ──────────→ Use defaults
   └─→ Get Started
        ↓
2. Permissions (Screen Recording + Accessibility)
        ↓
3. LLM Choice
   ├─→ Local Only ──────→ 4A. Ollama Config ──→ 5. Model Assignment
   ├─→ Cloud Only ──────→ 4B. Google AI ──────→ 5. Model Assignment
   └─→ Hybrid ──────────→ 4A. Ollama ─→ 4B. Google AI ─→ 5. Model Assignment
        ↓
5. Model Assignment (Brain, Actor, Planner, Memory)
        ↓
6. Optional Features (Discord, Notifications, Startup)
        ↓
7. Summary & Finish ──────→ Save config ──→ Open Chat
```

## 🔧 Configuration

### Saved Location
```
~/.turix/config.json          # Configuration file
~/.turix/setup_completed      # Setup flag
```

### Config Format (JSON)
```json
{
  "brain_llm": {
    "provider": "google_flash",
    "model_name": "gemini-2.0-flash",
    "api_key": "..."
  },
  "actor_llm": {
    "provider": "ollama",
    "model_name": "qwen2.5:latest",
    "base_url": "http://localhost:11434"
  },
  "planner_llm": { ... },
  "memory_llm": { ... },
  "agent": { ... }
}
```

## 🎨 Key Views

### AppState (Global State)
```swift
class AppState: ObservableObject {
    @Published var setupCompleted: Bool
    @Published var configuration: Configuration?
    
    func saveConfiguration(_ config: Configuration)
    func markSetupCompleted()
    func resetSetup()
}
```

### SetupState (Setup Wizard)
```swift
class SetupState: ObservableObject {
    @Published var llmChoice: LLMSetupChoice
    @Published var ollamaModels: [String]
    @Published var modelAssignments: [ModelRole: ModelAssignment]
    
    func buildConfiguration() -> Configuration
    func useRecommendedModels()
}
```

## 🔑 Key Features

### Permissions Checked
- ✅ Screen Recording (Required)
- ✅ Accessibility (Required)
- ✅ Notifications (Optional)

### LLM Providers
- 🏠 **Ollama** (Local): Free, private, ~16GB RAM
- ☁️ **Google AI** (Cloud): Fast, API costs
- 🔄 **Hybrid**: Best of both (Recommended)

### Model Roles
- 🧠 **Brain**: Main reasoning
- 🎭 **Actor**: Action execution  
- 📝 **Planner**: Task planning
- 💾 **Memory**: Context management

### Chat Interface
- Message history
- User/AI bubbles
- Timestamps
- Example tasks

### Settings Tabs
1. **General**: Appearance, startup, notifications
2. **LLM**: Model configuration
3. **Advanced**: Agent settings
4. **About**: Version, links, community

## 🛠️ Development

### Run in Xcode
```bash
open TuriXMacApp.xcodeproj
# Cmd+R to build and run
# Cmd+, to open settings
```

### Build Script
```bash
./build.sh
# Output: build/Build/Products/Release/TuriXMacApp.app
```

### Common Commands
```bash
# Clean build
rm -rf build/

# Run app
open build/Build/Products/Release/TuriXMacApp.app

# View logs
tail -f ~/Library/Logs/TuriX/app.log
```

## 📚 Documentation Files

| File | Purpose | Size |
|------|---------|------|
| README.md | Build instructions | 7KB |
| USER_GUIDE.md | End-user manual | 12KB |
| DEVELOPER_GUIDE.md | Developer docs | 9KB |
| INTEGRATION_GUIDE.md | Backend integration | 12KB |
| SCREENSHOTS.md | UI flow | 10KB |
| PROJECT_SUMMARY.md | Project overview | 10KB |

## 🎭 Model Recommendations

### Hybrid (Recommended) ⭐
- Brain: Google AI (gemini-2.0-flash)
- Actor: Ollama (qwen2.5:latest)
- Planner: Ollama (qwen2.5:latest)
- Memory: Ollama (qwen2.5:latest)

### Local Only
- All roles: Ollama (qwen2.5:latest)

### Cloud Only
- Brain: Google AI (gemini-2.0-pro)
- Actor: Google AI (gemini-2.0-flash)
- Planner: Google AI (gemini-2.0-flash)
- Memory: Google AI (gemini-1.5-flash)

## 🔗 Integration Options

### Option 1: File-based (Current)
- GUI writes config
- Python reads config
- Independent operation

### Option 2: Process Management
- GUI spawns Python subprocess
- Monitors via logs
- Start/stop control

### Option 3: HTTP Server
- Python runs HTTP server
- GUI calls REST API
- Real-time status

### Option 4: WebSocket
- Bidirectional real-time
- Live progress updates
- Interactive workflows

## 🐛 Troubleshooting

### Permission Denied
```bash
# Go to System Settings → Privacy & Security
# Enable Screen Recording + Accessibility
```

### Can't Connect to Ollama
```bash
# Install Ollama
brew install ollama

# Start Ollama
ollama serve

# Test
curl http://localhost:11434/api/tags
```

### Invalid Google AI Key
```bash
# Get new key at:
# https://makersuite.google.com/app/apikey
```

### Reset Setup
```bash
# In app: Settings → General → Reset Setup Wizard
# Or manually:
rm ~/.turix/setup_completed
```

## 📖 Resources

- 📘 [Main README](README.md) - Build instructions
- 📗 [User Guide](USER_GUIDE.md) - Complete manual
- 📕 [Developer Guide](DEVELOPER_GUIDE.md) - Developer docs
- 📙 [Integration Guide](INTEGRATION_GUIDE.md) - Backend setup

## 🌐 Links

- **GitHub**: https://github.com/Rashoooodi/TuriX-CUA
- **Discord**: https://discord.gg/yaYrNAckb5
- **Email**: contact@turix.ai

## ⌨️ Keyboard Shortcuts

| Shortcut | Action |
|----------|--------|
| Cmd+R | Build and run (Xcode) |
| Cmd+, | Open settings |
| Cmd+W | Close window |
| Cmd+Q | Quit app |
| Cmd+Shift+2 | Force stop task (default) |

## 💡 Quick Tips

1. **Use Hybrid mode** for best balance
2. **Grant permissions** before first use
3. **Test connections** during setup
4. **Check logs** if issues occur
5. **Reset setup** to reconfigure
6. **Join Discord** for help

## 🚦 Status Indicators

- 🟢 Connected / Success
- 🔴 Failed / Error
- ⏳ Testing / Loading
- ⚪️ Not tested / Idle
- ✅ Granted / Enabled
- ❌ Denied / Disabled
- ⚠️ Optional / Warning

## 📊 Resource Estimates

### Local Only
- RAM: ~16GB
- Cost: Free

### Cloud Only
- RAM: Minimal
- Cost: $0.01-$0.10 per task

### Hybrid
- RAM: ~12GB
- Cost: $0.01-$0.05 per task

---

**Built with ❤️ for TuriX**
