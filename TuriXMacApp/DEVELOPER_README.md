# TuriX macOS App - Developer Documentation

Complete guide for developers who want to build, modify, or contribute to the TuriX macOS application.

## Quick Start for Developers

```bash
# Clone repository
git clone https://github.com/Rashoooodi/TuriX-CUA.git
cd TuriX-CUA/TuriXMacApp

# Open in Xcode
open TuriXMacApp.xcodeproj

# Build and run
# Press Cmd+R in Xcode
```

## Prerequisites

- **macOS 13.0+** (Ventura or later)
- **Xcode 14.0+** with Command Line Tools
- **Swift 5.7+**
- Basic knowledge of SwiftUI and macOS development

Install Command Line Tools:
```bash
xcode-select --install
```

## Project Architecture

### Technology Stack
- **UI Framework**: SwiftUI
- **Architecture**: MVVM (Model-View-ViewModel)
- **State Management**: Combine with `@StateObject`, `@ObservableObject`
- **Navigation**: NavigationStack (iOS 16+/macOS 13+)
- **Persistence**: JSON file storage via `Codable`
- **Minimum Target**: macOS 13.0

### Directory Structure

```
TuriXMacApp/
├── TuriXMacApp.xcodeproj/          # Xcode project configuration
│   ├── project.pbxproj             # Project settings
│   └── xcshareddata/
│       └── xcschemes/               # Build schemes
├── TuriXMacApp/                     # Source code (17 Swift files)
│   ├── TuriXMacAppApp.swift        # @main - App entry point
│   ├── ContentView.swift           # Root view (setup or chat)
│   ├── Models/                     # Data layer (3 files)
│   │   ├── AppState.swift          # Global app state
│   │   ├── Configuration.swift     # Config data structures
│   │   └── SetupState.swift        # Setup wizard state
│   ├── Setup/                      # Setup flow (9 files)
│   │   ├── SetupFlowView.swift     # Navigation controller
│   │   ├── WelcomeView.swift       # Step 1
│   │   ├── PermissionsCheckView.swift  # Step 2
│   │   ├── LLMSetupChoiceView.swift    # Step 3
│   │   ├── OllamaConfigView.swift      # Step 4A
│   │   ├── GoogleAIConfigView.swift    # Step 4B
│   │   ├── ModelAssignmentView.swift   # Step 5
│   │   ├── OptionalFeaturesView.swift  # Step 6
│   │   └── SummaryView.swift           # Step 7
│   ├── Views/                      # Main app (2 files)
│   │   ├── MainChatView.swift      # Chat interface
│   │   └── SettingsView.swift      # Settings window
│   ├── Assets.xcassets/            # App icons, colors
│   ├── Info.plist                  # App metadata
│   └── TuriXMacApp.entitlements    # Security permissions
├── build.sh                        # Command-line build script
├── Package.swift                   # Swift Package Manager support
└── [Documentation files]           # 8 MD files, 60K+ words
```

## Building the Application

### Using Xcode (Recommended)

1. **Open Project**
   ```bash
   open TuriXMacApp.xcodeproj
   ```

2. **Configure Signing**
   - Select project in navigator
   - Select "TuriXMacApp" target
   - Go to "Signing & Capabilities"
   - Choose your development team

3. **Build and Run**
   - Press `Cmd+R` or Product → Run
   - Press `Cmd+B` to build only

### Using Build Script

```bash
./build.sh
# Output: build/Build/Products/Release/TuriXMacApp.app
```

### Command Line Build

```bash
xcodebuild -project TuriXMacApp.xcodeproj \
           -scheme TuriXMacApp \
           -configuration Release \
           clean build
```

## Code Organization

### State Management

**AppState.swift** - Global application state
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

**SetupState.swift** - Setup wizard state
```swift
class SetupState: ObservableObject {
    @Published var llmChoice: LLMSetupChoice
    @Published var modelAssignments: [ModelRole: ModelAssignment]
    
    func buildConfiguration() -> Configuration
    func useRecommendedModels()
}
```

### Configuration Model

**Configuration.swift** - Codable config matching Python agent format
```swift
struct Configuration: Codable {
    var brainLLM: LLMConfig      // Main reasoning
    var actorLLM: LLMConfig      // Action execution
    var plannerLLM: LLMConfig    // Task planning
    var memoryLLM: LLMConfig     // Context management
    var agent: AgentConfig
}
```

Saved to: `~/.turix/config.json`

### Navigation Flow

Setup wizard uses `NavigationStack` with custom navigation:
```swift
@State private var navigationPath = NavigationPath()

// Navigate forward
navigationPath.append(SetupStep.permissions)

// Navigate back
navigationPath.removeLast()
```

## Development Workflow

### Adding a New Setup Step

1. **Add enum case**
   ```swift
   // SetupFlowView.swift
   enum SetupStep: Hashable {
       case newStep
   }
   ```

2. **Create view file**
   ```swift
   // Setup/NewStepView.swift
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
   ```

3. **Add to view builder**
   ```swift
   // SetupFlowView.swift
   func viewForStep(_ step: SetupStep) -> some View {
       switch step {
       case .newStep:
           NewStepView(setupState: setupState, 
                      navigationPath: $navigationPath)
       }
   }
   ```

### Adding a New Setting

1. **Update AppState or create state object**
2. **Add UI in SettingsView.swift**
3. **Persist if needed in saveConfiguration()**

### Modifying Configuration Format

1. Update `Configuration.swift` structs
2. Add/modify `CodingKeys` enum for JSON mapping
3. Test with Python agent for compatibility

## Debugging

### Enable Detailed Logging
```swift
print("Debug: \(value)")
// Or use unified logging
import os.log
let log = OSLog(subsystem: "ai.turix.app", category: "setup")
os_log(.debug, log: log, "Setup state: %@", state)
```

### View Debug Area
- Xcode → View → Debug Area → Show Debug Area
- Console shows print statements and errors

### Common Issues

**"Screen Recording permission denied"**
```swift
// Check in PermissionsCheckView.swift
setupState.hasScreenRecording = CGPreflightScreenCaptureAccess()
```

**"Type 'X' cannot conform to 'Y'"**
- Ensure protocol conformance is complete
- Check if protocol requires associated types

**"Cannot find 'X' in scope"**
- Verify imports are present
- Check file is added to target

## Testing

### Manual Testing Checklist
- [ ] App launches without crash
- [ ] Setup wizard navigates correctly
- [ ] Permission checks work
- [ ] Configuration saves to file
- [ ] Setup completion flag persists
- [ ] Chat interface displays
- [ ] Settings window opens

### Automated Testing
Currently, no unit tests are implemented. To add:

1. **Create test target** in Xcode
2. **Add test files**
   ```swift
   import XCTest
   @testable import TuriXMacApp
   
   class ConfigurationTests: XCTestCase {
       func testConfigurationEncoding() {
           // Test JSON encoding/decoding
       }
   }
   ```

3. **Run tests**: `Cmd+U` in Xcode

## Code Style

### SwiftUI Best Practices
- Use `@StateObject` for owned objects
- Use `@ObservedObject` for passed objects
- Use `@EnvironmentObject` for shared state
- Keep views small and composable
- Extract reusable components

### Naming Conventions
- **Views**: Descriptive noun + "View" (e.g., `WelcomeView`)
- **State**: Purpose + "State" (e.g., `SetupState`)
- **Models**: Clear noun (e.g., `Configuration`)
- **Functions**: Verb phrase (e.g., `saveConfiguration`)

### File Organization
- Group related files in folders
- One major view per file
- Extract sub-views when they get large

## Integration with Python Agent

The GUI writes configuration that the Python agent reads:

### File-based Communication (Current)
```swift
// Swift writes
appState.saveConfiguration(config)
// Saves to ~/.turix/config.json

// Python reads
config_path = Path.home() / ".turix" / "config.json"
```

### Future Integration Options
See [INTEGRATION_GUIDE.md](INTEGRATION_GUIDE.md) for:
1. Process management (spawn Python subprocess)
2. HTTP API (REST communication)
3. WebSocket (real-time bidirectional)

## Distribution

### Development Build
```bash
# Ad-hoc distribution
Archive → Distribute App → Copy App
```

### Release Build
1. **Archive**: Product → Archive
2. **Export**: Organizer → Distribute App
3. **Choose method**:
   - Direct Distribution (DMG)
   - Mac App Store
   - TestFlight

### Create DMG
```bash
# Using create-dmg tool
create-dmg \
  --volname "TuriX Installer" \
  --window-pos 200 120 \
  --window-size 800 400 \
  --icon "TuriXMacApp.app" 200 190 \
  --app-drop-link 600 185 \
  "TuriX.dmg" \
  "build/Build/Products/Release/"
```

## Contributing

### Before Submitting PR
1. **Verify code compiles** without warnings
2. **Test all UI flows** manually
3. **Update documentation** if needed
4. **Follow code style** guidelines
5. **Write clear commit messages**

### Commit Message Format
```
Short description (50 chars or less)

Longer explanation if needed. Explain what and why,
not how. Wrap at 72 characters.

Fixes #123
```

### Pull Request Process
1. Fork repository
2. Create feature branch
3. Make changes
4. Test thoroughly
5. Submit PR with description

## Resources

### Documentation
- [END_USER_README.md](END_USER_README.md) - End user guide
- [USER_GUIDE.md](USER_GUIDE.md) - Detailed user manual
- [INTEGRATION_GUIDE.md](INTEGRATION_GUIDE.md) - Backend integration
- [SCREENSHOTS.md](SCREENSHOTS.md) - UI flow documentation
- [CODE_VERIFICATION.md](CODE_VERIFICATION.md) - Code review report

### Apple Documentation
- [SwiftUI](https://developer.apple.com/documentation/swiftui)
- [macOS Human Interface Guidelines](https://developer.apple.com/design/human-interface-guidelines/macos)
- [Xcode Help](https://help.apple.com/xcode/)

### TuriX Community
- **Discord**: https://discord.gg/yaYrNAckb5
- **GitHub**: https://github.com/Rashoooodi/TuriX-CUA
- **Email**: contact@turix.ai

## Troubleshooting Development Issues

### Xcode Won't Open Project
```bash
# Clean derived data
rm -rf ~/Library/Developer/Xcode/DerivedData/*
```

### Build Fails with "Command Line Tools Not Found"
```bash
xcode-select --install
sudo xcode-select --switch /Applications/Xcode.app
```

### Signing Issues
- Ensure you're signed in to Xcode with Apple ID
- Go to Xcode → Preferences → Accounts
- Use "Automatically manage signing"

### SwiftUI Preview Not Working
- Press `Cmd+Option+P` to refresh
- Clean build folder: Product → Clean Build Folder
- Restart Xcode

## License

See [LICENSE](../LICENSE) in repository root.

---

**Questions?** Ask on [Discord](https://discord.gg/yaYrNAckb5) or create a [GitHub issue](https://github.com/Rashoooodi/TuriX-CUA/issues)!
