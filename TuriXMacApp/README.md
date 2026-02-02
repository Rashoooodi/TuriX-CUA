# TuriX macOS GUI Application

A native macOS application built with SwiftUI that provides a chat-centric interface for the TuriX Computer-Use-Agent with comprehensive first-run setup, LLM configuration, and settings management.

## 📚 Quick Links

- 👤 **End Users**: Start with [END_USER_README.md](END_USER_README.md)
- 👨‍💻 **Developers**: Start with [DEVELOPER_README.md](DEVELOPER_README.md)
- 🔨 **Building the App**: See [BUILD.md](BUILD.md) for detailed Xcode build instructions
- 📖 **All Documentation**: See [DOCUMENTATION_INDEX.md](DOCUMENTATION_INDEX.md)

---

## Features

### 🎯 First-Run Setup Flow
- **Welcome Screen**: Introduction to TuriX with options to start setup or skip
- **System Permissions Check**: Automated checking and guidance for required macOS permissions
  - Screen Recording (Required)
  - Accessibility (Required)
  - Notifications (Optional)
- **LLM Setup Choice**: Choose between Local (Ollama), Cloud (Google AI), or Hybrid configuration
- **Ollama Configuration**: Configure local or remote Ollama connection with model selection
- **Google AI Configuration**: Set up Google AI API with model selection
- **Model Role Assignment**: Assign models to Brain, Actor, Planner, and Memory roles
- **Optional Features**: Enable Discord integration, notifications, and startup options
- **Summary & Finish**: Review configuration before saving

### 💬 Chat Interface
- Clean, modern chat interface for interacting with TuriX
- Message history with timestamps
- Example task suggestions
- Real-time task execution status

### ⚙️ Settings
- General settings for appearance and behavior
- LLM configuration management
- Advanced agent settings
- About section with links to documentation and community

## Requirements

- macOS 13.0 or later
- Xcode 14.0 or later (for building)
- Swift 5.7 or later

## Building the Application

📖 **For detailed step-by-step instructions, see [BUILD.md](BUILD.md)**

### Quick Start

```bash
cd TuriXMacApp
open TuriXMacApp.xcodeproj
```

In Xcode:
1. Select your development team in Signing & Capabilities
2. Press `Cmd + R` to build and run

For troubleshooting and detailed instructions, refer to the [complete build guide](BUILD.md).

## Project Structure

```
TuriXMacApp/
├── TuriXMacApp.xcodeproj/     # Xcode project file
└── TuriXMacApp/                # Source code
    ├── TuriXMacAppApp.swift    # Main app entry point
    ├── ContentView.swift        # Root view controller
    ├── Info.plist              # App metadata
    ├── TuriXMacApp.entitlements # Security entitlements
    ├── Models/                 # Data models
    │   ├── AppState.swift      # App-wide state management
    │   ├── Configuration.swift  # Configuration data structures
    │   └── SetupState.swift    # Setup flow state
    ├── Setup/                  # Setup flow views
    │   ├── SetupFlowView.swift
    │   ├── WelcomeView.swift
    │   ├── PermissionsCheckView.swift
    │   ├── LLMSetupChoiceView.swift
    │   ├── OllamaConfigView.swift
    │   ├── GoogleAIConfigView.swift
    │   ├── ModelAssignmentView.swift
    │   ├── OptionalFeaturesView.swift
    │   └── SummaryView.swift
    └── Views/                  # Main app views
        ├── MainChatView.swift
        └── SettingsView.swift
```

## Configuration

The app saves configuration to `~/.turix/config.json` in the format compatible with the Python TuriX agent.

Example configuration:

```json
{
  "logging_level": "DEBUG",
  "output_dir": ".turix_tmp",
  "brain_llm": {
    "provider": "google_flash",
    "model_name": "gemini-2.0-flash",
    "api_key": "your_api_key_here"
  },
  "actor_llm": {
    "provider": "ollama",
    "model_name": "qwen2.5:latest",
    "base_url": "http://localhost:11434"
  },
  "planner_llm": {
    "provider": "ollama",
    "model_name": "qwen2.5:latest",
    "base_url": "http://localhost:11434"
  },
  "memory_llm": {
    "provider": "ollama",
    "model_name": "qwen2.5:latest",
    "base_url": "http://localhost:11434"
  },
  "agent": {
    "task": "",
    "memory_budget": 2000,
    "summary_memory_budget": 8000,
    "use_ui": false,
    "use_search": false,
    "use_skills": true,
    "skills_dir": "skills",
    "skills_max_chars": 4000,
    "use_plan": true,
    "max_actions_per_step": 5,
    "max_steps": 100,
    "force_stop_hotkey": "command+shift+2",
    "use_turix": true,
    "resume": false
  }
}
```

## First Run

On first launch, the app will guide you through the setup process:

1. **Welcome**: Introduction and option to skip setup
2. **Permissions**: Request necessary macOS permissions
3. **LLM Choice**: Select Local, Cloud, or Hybrid setup
4. **Configuration**: Configure Ollama and/or Google AI
5. **Model Assignment**: Assign models to different roles
6. **Features**: Enable optional features
7. **Summary**: Review and save configuration

## Permissions

The app requires the following macOS permissions:

### Required
- **Screen Recording**: Allows the AI to see your screen
- **Accessibility**: Allows the AI to control your computer

### Optional
- **Notifications**: Enables task completion notifications

You can grant these permissions through System Settings > Privacy & Security.

## Resetting Setup

To re-run the setup wizard:
1. Open Settings (Cmd + ,)
2. Go to the "General" tab
3. Click "Reset Setup Wizard"
4. Restart the application

## Connecting to Python Agent

The GUI is designed to work with the Python TuriX agent backend. To use the full functionality:

1. Ensure the Python agent is installed and configured
2. The GUI writes configuration to `~/.turix/config.json`
3. Run the Python agent using this configuration
4. The chat interface communicates with the agent

## Troubleshooting

### "Screen Recording permission denied"
- Go to System Settings > Privacy & Security > Screen Recording
- Enable permission for TuriXMacApp
- Restart the application

### "Accessibility permission denied"
- Go to System Settings > Privacy & Security > Accessibility
- Enable permission for TuriXMacApp
- Restart the application

### "Cannot connect to Ollama"
- Ensure Ollama is installed and running
- Check that Ollama is accessible at the configured URL
- Try testing the connection in the setup flow

### "Google AI API key invalid"
- Verify your API key at https://makersuite.google.com/app/apikey
- Ensure the key has not expired
- Re-enter the key in settings

## Development

### Adding New Features

1. **Models**: Add data structures in `Models/`
2. **Setup Steps**: Add new setup views in `Setup/`
3. **Main Views**: Add new views in `Views/`
4. **State Management**: Update `AppState` or create new state objects

### Testing

Run tests in Xcode:
```bash
Cmd + U
```

### Building for Distribution

1. Archive the app: `Product > Archive`
2. Distribute: Select "Copy App" or "Export"
3. Create a DMG or distribute via TestFlight

## License

This project is part of the TuriX Computer-Use-Agent and follows the same license.

## Contributing

Contributions are welcome! Please see the main TuriX repository for contribution guidelines.

## Support

- Discord: https://discord.gg/yaYrNAckb5
- Issues: https://github.com/Rashoooodi/TuriX-CUA/issues
- Email: contact@turix.ai
