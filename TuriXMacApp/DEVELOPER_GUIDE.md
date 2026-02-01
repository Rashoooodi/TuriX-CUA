# TuriX macOS App - Quick Start for Developers

This guide will help you get started developing the TuriX macOS application.

## Prerequisites

- macOS 13.0 (Ventura) or later
- Xcode 14.0 or later
- Command Line Tools: `xcode-select --install`
- Basic knowledge of Swift and SwiftUI

## Project Structure

```
TuriXMacApp/
├── TuriXMacApp.xcodeproj/          # Xcode project
├── TuriXMacApp/                     # Source code
│   ├── TuriXMacAppApp.swift         # App entry point (@main)
│   ├── ContentView.swift            # Root view (shows setup or chat)
│   ├── Models/                      # Data models
│   │   ├── AppState.swift           # App-wide state
│   │   ├── Configuration.swift      # Config structs
│   │   └── SetupState.swift         # Setup flow state
│   ├── Setup/                       # Setup wizard views
│   │   ├── SetupFlowView.swift      # Setup navigation
│   │   ├── WelcomeView.swift        # Step 1: Welcome
│   │   ├── PermissionsCheckView.swift  # Step 2: Permissions
│   │   ├── LLMSetupChoiceView.swift    # Step 3: LLM choice
│   │   ├── OllamaConfigView.swift      # Step 4A: Ollama
│   │   ├── GoogleAIConfigView.swift    # Step 4B: Google AI
│   │   ├── ModelAssignmentView.swift   # Step 5: Model roles
│   │   ├── OptionalFeaturesView.swift  # Step 6: Features
│   │   └── SummaryView.swift           # Step 7: Summary
│   ├── Views/                       # Main app views
│   │   ├── MainChatView.swift       # Chat interface
│   │   └── SettingsView.swift       # Settings window
│   ├── Assets.xcassets/             # Images, colors
│   ├── Info.plist                   # App metadata
│   └── TuriXMacApp.entitlements     # Permissions
├── build.sh                         # Build script
├── Package.swift                    # Swift Package Manager
├── README.md                        # Build documentation
├── USER_GUIDE.md                    # User documentation
└── SCREENSHOTS.md                   # UI flow documentation
```

## Quick Start

### 1. Clone and Open

```bash
git clone https://github.com/Rashoooodi/TuriX-CUA.git
cd TuriX-CUA/TuriXMacApp
open TuriXMacApp.xcodeproj
```

### 2. Build and Run

In Xcode:
- Press `Cmd + R` to build and run
- Or: Product → Run

Command line:
```bash
./build.sh
open build/Build/Products/Release/TuriXMacApp.app
```

### 3. Grant Permissions

On first run, you'll need to grant:
- Screen Recording permission
- Accessibility permission

## Architecture Overview

### State Management

The app uses SwiftUI's `@StateObject` and `@EnvironmentObject` for state management:

- **AppState**: Global app state (setup completion, configuration)
- **SetupState**: Setup wizard state (transient, only during setup)

### Navigation

- **NavigationStack**: Used for setup flow navigation
- **TabView**: Used for settings tabs
- Each setup step is a separate view pushed onto the stack

### Configuration Persistence

Configuration is saved to `~/.turix/config.json`:
- Uses `Codable` protocol for JSON serialization
- Compatible with Python agent configuration format
- Setup completion flag stored separately as `.turix/setup_completed`

### Views

All views follow SwiftUI best practices:
- Declarative UI
- View composition
- Minimal state
- Reusable components

## Key Components

### AppState.swift

Manages global application state:

```swift
class AppState: ObservableObject {
    @Published var setupCompleted: Bool
    @Published var configuration: Configuration?
    
    func saveConfiguration(_ config: Configuration)
    func loadConfiguration()
    func markSetupCompleted()
    func resetSetup()
}
```

### SetupState.swift

Manages setup flow state:

```swift
class SetupState: ObservableObject {
    @Published var currentStep: Int
    @Published var llmChoice: LLMSetupChoice
    @Published var ollamaConnectionStatus: ConnectionStatus
    @Published var modelAssignments: [ModelRole: ModelAssignment]
    
    func buildConfiguration() -> Configuration
}
```

### Configuration.swift

Data models for configuration:

```swift
struct Configuration: Codable {
    var brainLLM: LLMConfig
    var actorLLM: LLMConfig
    var plannerLLM: LLMConfig
    var memoryLLM: LLMConfig
    var agent: AgentConfig
}
```

## Development Workflow

### Adding a New Setup Step

1. Create new view file in `Setup/`
2. Add case to `SetupStep` enum in `SetupFlowView.swift`
3. Add view builder case in `viewForStep(_:)`
4. Update navigation logic in previous step

Example:
```swift
// 1. Create NewStepView.swift
struct NewStepView: View {
    @ObservedObject var setupState: SetupState
    @Binding var navigationPath: NavigationPath
    
    var body: some View {
        VStack {
            Text("New Step")
            Button("Continue") {
                navigationPath.append(SetupStep.nextStep)
            }
        }
    }
}

// 2. Add to SetupStep enum
enum SetupStep: Hashable {
    case newStep
    // ... other cases
}

// 3. Add to viewForStep
func viewForStep(_ step: SetupStep) -> some View {
    switch step {
    case .newStep:
        NewStepView(setupState: setupState, navigationPath: $navigationPath)
    // ... other cases
    }
}
```

### Adding a New Setting

1. Add property to `AppState` or create new state class
2. Add UI in appropriate settings tab (`SettingsView.swift`)
3. Persist if needed in `saveConfiguration`

### Styling Guidelines

Use SwiftUI standard components:
- `.buttonStyle(.borderedProminent)` for primary actions
- `.buttonStyle(.bordered)` for secondary actions
- `.formStyle(.grouped)` for settings forms
- System colors: `.blue`, `.green`, `.red`, etc.
- SF Symbols for icons

### Testing

Run in simulator or on device:
- Xcode: Product → Test (Cmd + U)
- Supports macOS 13.0+

### Debugging

Enable detailed logging:
```swift
print("Debug: \(value)")
```

View console: Xcode → View → Debug Area → Show Debug Area

## Common Tasks

### Update App Version

Edit in `Info.plist`:
```xml
<key>CFBundleShortVersionString</key>
<string>0.3.0</string>
```

And in `project.pbxproj`:
```
MARKETING_VERSION = 0.3.0;
```

### Add New Dependency

For Swift packages:
1. File → Add Packages...
2. Enter package URL
3. Select version
4. Add to target

### Export for Distribution

1. Product → Archive
2. Distribute App
3. Choose distribution method:
   - Direct Distribution (for DMG)
   - Mac App Store
   - TestFlight

### Create DMG

```bash
# Build release version
./build.sh

# Create DMG (requires create-dmg tool)
create-dmg \
  --volname "TuriX Installer" \
  --window-pos 200 120 \
  --window-size 800 400 \
  --icon-size 100 \
  --icon "TuriXMacApp.app" 200 190 \
  --hide-extension "TuriXMacApp.app" \
  --app-drop-link 600 185 \
  "TuriX-0.3.0.dmg" \
  "build/Build/Products/Release/"
```

## API Integration

### Connecting to Python Agent

The GUI generates config that the Python agent reads:

```python
# Python agent reads from
config_path = Path.home() / ".turix" / "config.json"
```

To make GUI talk to Python agent:
1. Add IPC mechanism (XPC, sockets, or HTTP)
2. Start Python agent as subprocess
3. Send tasks via IPC
4. Receive status updates

Example approach:
```swift
// Start Python agent
let process = Process()
process.executableURL = URL(fileURLWithPath: "/path/to/python")
process.arguments = ["/path/to/main.py", "-c", configPath]
process.launch()

// Send task via pipe or HTTP
```

### Ollama API Integration

Currently mocked. To implement:

```swift
import Foundation

func testOllamaConnection(baseURL: String) async -> ConnectionStatus {
    guard let url = URL(string: "\(baseURL)/api/tags") else {
        return .failed("Invalid URL")
    }
    
    do {
        let (data, _) = try await URLSession.shared.data(from: url)
        let response = try JSONDecoder().decode(OllamaResponse.self, from: data)
        return .success
    } catch {
        return .failed(error.localizedDescription)
    }
}
```

### Google AI API Integration

Currently mocked. To implement:

```swift
func testGoogleAIConnection(apiKey: String) async -> ConnectionStatus {
    let url = URL(string: "https://generativelanguage.googleapis.com/v1/models")!
    var request = URLRequest(url: url)
    request.addValue(apiKey, forHTTPHeaderField: "x-goog-api-key")
    
    do {
        let (_, response) = try await URLSession.shared.data(for: request)
        if let httpResponse = response as? HTTPURLResponse,
           httpResponse.statusCode == 200 {
            return .success
        }
        return .failed("Invalid API key")
    } catch {
        return .failed(error.localizedDescription)
    }
}
```

## Resources

### Apple Documentation
- [SwiftUI Documentation](https://developer.apple.com/documentation/swiftui)
- [App Distribution Guide](https://developer.apple.com/documentation/xcode/distributing-your-app-for-beta-testing-and-releases)
- [macOS Human Interface Guidelines](https://developer.apple.com/design/human-interface-guidelines/macos)

### TuriX Documentation
- [Main README](../README.md)
- [User Guide](USER_GUIDE.md)
- [UI Flow](SCREENSHOTS.md)

### Community
- [Discord](https://discord.gg/yaYrNAckb5)
- [GitHub Issues](https://github.com/Rashoooodi/TuriX-CUA/issues)

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

See [CONTRIBUTING.md](../CONTRIBUTING.MD) for guidelines.

## License

See [LICENSE](../LICENSE) file in repository root.

---

**Happy coding!** 🎉

For questions or issues, reach out on [Discord](https://discord.gg/yaYrNAckb5) or create a [GitHub issue](https://github.com/Rashoooodi/TuriX-CUA/issues).
