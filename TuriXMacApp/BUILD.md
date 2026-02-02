# Building TuriX macOS App with Xcode

This guide provides step-by-step instructions for building the TuriX macOS application using Xcode.

## Table of Contents
- [Prerequisites](#prerequisites)
- [Quick Start](#quick-start)
- [Detailed Build Instructions](#detailed-build-instructions)
- [Code Signing Configuration](#code-signing-configuration)
- [Building for Distribution](#building-for-distribution)
- [Troubleshooting](#troubleshooting)
- [Verifying Your Build](#verifying-your-build)

---

## Prerequisites

### Required Software

1. **macOS 13.0 (Ventura) or later**
   - Check your version: Apple menu  → About This Mac
   - Upgrade if needed: System Settings → Software Update

2. **Xcode 14.0 or later**
   - Download from the [Mac App Store](https://apps.apple.com/us/app/xcode/id497799835)
   - Or download from [Apple Developer](https://developer.apple.com/xcode/)
   - **Current recommended version**: Xcode 15.0+

3. **Command Line Tools** (usually installed with Xcode)
   - Verify installation:
     ```bash
     xcode-select -p
     ```
   - If not installed, run:
     ```bash
     xcode-select --install
     ```

### System Requirements

- **Disk Space**: At least 10 GB free (5 GB for Xcode, 5 GB for builds)
- **RAM**: 8 GB minimum, 16 GB recommended
- **Processor**: Intel or Apple Silicon (M1/M2/M3)

---

## Quick Start

For experienced developers who just want to get started:

```bash
# 1. Clone the repository (if not already cloned)
git clone https://github.com/Rashoooodi/TuriX-CUA.git
cd TuriX-CUA/TuriXMacApp

# 2. Open the project
open TuriXMacApp.xcodeproj

# 3. In Xcode, press Cmd+R to build and run
```

---

## Detailed Build Instructions

### Step 1: Open the Project

1. **Navigate to the project directory:**
   ```bash
   cd /path/to/TuriX-CUA/TuriXMacApp
   ```

2. **Open the Xcode project:**
   ```bash
   open TuriXMacApp.xcodeproj
   ```
   
   Alternatively, you can:
   - Double-click `TuriXMacApp.xcodeproj` in Finder
   - Open Xcode → File → Open → Select `TuriXMacApp.xcodeproj`

3. **Wait for Xcode to load:**
   - Xcode will index the project (may take 1-2 minutes on first open)
   - You'll see a progress indicator at the top of the window

### Step 2: Select Build Target

1. **Locate the scheme selector** at the top-left of the Xcode window
   - It shows: `TuriXMacApp > My Mac`
   
2. **Verify the target:**
   - Click the scheme selector
   - Ensure "TuriXMacApp" is selected as the scheme
   - Ensure "My Mac" (or your Mac's name) is selected as the destination

### Step 3: Configure Code Signing

**For Development Builds:**

1. **Open Project Settings:**
   - Click on the blue "TuriXMacApp" project icon in the left navigator
   - Make sure the "TuriXMacApp" target is selected (not the project)

2. **Navigate to Signing & Capabilities:**
   - Click the "Signing & Capabilities" tab at the top

3. **Configure Automatic Signing:**
   - ✅ Check "Automatically manage signing"
   - Select your **Team** from the dropdown:
     - If you have an Apple Developer account: Select your team
     - If you don't: Select "Personal Team" (creates one automatically)
     - If no team appears: You may need to add your Apple ID:
       1. Xcode → Settings (Cmd+,)
       2. Accounts tab
       3. Click "+" → Add Apple ID
       4. Sign in with your Apple ID

4. **Verify Bundle Identifier:**
   - Bundle Identifier should be: `ai.turix.TuriXMacApp`
   - If there's a signing error, you can change it to: `ai.turix.TuriXMacApp.yourname`

5. **Check Entitlements:**
   - Ensure these entitlements are present:
     - ✅ App Sandbox: **Disabled** (set to NO)
     - ✅ Outgoing Connections (Client): **Enabled**
     - ✅ User Selected File (Read/Write): **Enabled**
     - ✅ Apple Events: **Enabled**

### Step 4: Build the Project

**Option A: Build and Run (Recommended for Testing)**

1. **Press `Cmd + R`** or click the ▶️ Play button in the top-left
2. **Wait for the build to complete:**
   - Build progress shows at the top center
   - Build log appears in the Report Navigator (Cmd+9)
   - First build may take 2-5 minutes

3. **App launches automatically** when build succeeds

**Option B: Build Only (Without Running)**

1. **Press `Cmd + B`** or select Product → Build
2. This compiles the app but doesn't launch it
3. Useful for checking if the code compiles without running

**Build Outputs:**
- Build products are located at:
  ```
  ~/Library/Developer/Xcode/DerivedData/TuriXMacApp-[random]/Build/Products/Debug/TuriXMacApp.app
  ```

### Step 5: First Launch Configuration

When you run the app for the first time:

1. **The Welcome screen appears**
   - This is the setup wizard

2. **System Permissions Required:**
   - The app will need:
     - ✅ Screen Recording permission
     - ✅ Accessibility permission
   - Click "Open Settings" for each and grant permissions
   - You may need to restart the app after granting permissions

3. **Complete the Setup Wizard:**
   - Follow the 7-step setup process
   - Configuration is saved to `~/.turix/config.json`

---

## Code Signing Configuration

### Understanding Code Signing

macOS requires all applications to be code-signed. For development:
- Xcode signs apps automatically with your development certificate
- Your Mac trusts apps signed with your certificate

### Development Certificate Setup

1. **Check your signing status:**
   - In Xcode, view the "Signing & Capabilities" tab
   - Look for a green checkmark ✅ next to "Signing Certificate"

2. **If you see signing errors:**
   - Try selecting a different team
   - Or create a new bundle identifier

3. **Manual Certificate Management (Advanced):**
   - Xcode → Settings → Accounts
   - Select your Apple ID
   - Click "Manage Certificates"
   - Ensure "Apple Development" certificate exists

### Personal Team Limitations

If using a Personal Team (free Apple ID):
- ✅ Can build and run on your Mac
- ❌ Cannot distribute to other users
- ❌ Cannot use certain advanced entitlements
- Certificate expires after 7 days (Xcode renews automatically)

### Apple Developer Account (Optional)

For broader distribution:
- Sign up at: https://developer.apple.com
- Cost: $99/year
- Benefits:
  - Distribute to other Macs
  - Notarize apps
  - App Store distribution
  - Extended entitlements

---

## Building for Distribution

### Creating a Release Build

1. **Select Release Configuration:**
   - Product → Scheme → Edit Scheme (Cmd+<)
   - Select "Run" in the left sidebar
   - Change "Build Configuration" to "Release"
   - Click "Close"

2. **Build for Release:**
   - Product → Build (Cmd+B)
   - Release builds are optimized (smaller, faster)

3. **Archive the App:**
   - Product → Archive
   - Wait for archive to complete
   - Organizer window opens showing your archive

4. **Export the App:**
   - In Organizer, select your archive
   - Click "Distribute App"
   - Choose distribution method:
     - **Copy App**: Creates .app bundle for direct sharing
     - **Developer ID**: For distribution outside App Store (requires paid account)
     - **Mac App Store**: For App Store submission (requires paid account)

### Creating a Disk Image (DMG)

After exporting the app:

```bash
# Using hdiutil (built into macOS)
hdiutil create -volname "TuriX" \
  -srcfolder TuriXMacApp.app \
  -ov -format UDZO \
  TuriX-0.3.0.dmg
```

Or use third-party tools:
- [create-dmg](https://github.com/create-dmg/create-dmg)
- [node-appdmg](https://github.com/LinusU/node-appdmg)

---

## Troubleshooting

### Common Build Errors

#### Error: "No signing certificate found"

**Solution:**
1. Xcode → Settings → Accounts
2. Add your Apple ID if not present
3. Select your account → Manage Certificates
4. Click "+" → Apple Development
5. Return to project and select the new certificate

#### Error: "Command Line Tools not found"

**Solution:**
```bash
xcode-select --install
sudo xcode-select --switch /Applications/Xcode.app
```

#### Error: "Unable to boot simulator"

**Note:** This is a macOS app, not iOS. Make sure:
- Destination is set to "My Mac" (not a simulator)
- Target is set to macOS, not iOS

#### Error: "Code signing entitlements are not supported"

**Solution:**
- Disable App Sandbox in entitlements
- Ensure all entitlements are properly configured
- Check that your signing certificate supports the entitlements

#### Error: "Build input file cannot be found"

**Solution:**
1. Product → Clean Build Folder (Cmd+Shift+K)
2. Close Xcode
3. Delete DerivedData:
   ```bash
   rm -rf ~/Library/Developer/Xcode/DerivedData
   ```
4. Reopen project and rebuild

#### Error: "The bundle identifier is already in use"

**Solution:**
- Change the bundle identifier to include your name:
  - Original: `ai.turix.TuriXMacApp`
  - Modified: `ai.turix.TuriXMacApp.yourname`

### Performance Issues

#### Slow Build Times

**Solutions:**
- Close other applications to free up RAM
- Disable Xcode previews if not needed
- Use Cmd+B (build only) instead of Cmd+R when testing code changes
- Enable parallel builds: Build Settings → Build Options → Enable Parallel Building

#### Xcode Freezes or Crashes

**Solutions:**
1. Force quit Xcode
2. Clean build folder
3. Clear derived data
4. Restart your Mac
5. Reinstall Command Line Tools

### Runtime Issues

#### App Won't Launch

**Check:**
- Build succeeded without errors
- Console app for crash logs (Applications → Utilities → Console)
- System logs: Log → Start Streaming

#### Permissions Not Granted

**Solution:**
- System Settings → Privacy & Security
- Manually enable Screen Recording and Accessibility for TuriXMacApp
- Restart the app

#### Configuration Not Saving

**Check:**
- App has write permissions to home directory
- `~/.turix/` directory is not restricted
- Try running from terminal to see error messages:
  ```bash
  /path/to/TuriXMacApp.app/Contents/MacOS/TuriXMacApp
  ```

---

## Verifying Your Build

### 1. Check Build Success

In Xcode:
- ✅ Build succeeded message appears
- ✅ No errors in Issue Navigator (Cmd+5)
- ✅ App icon appears in the Dock

### 2. Test App Functionality

Run through this checklist:

- [ ] **App launches** without crashing
- [ ] **Welcome screen** appears on first launch
- [ ] **Setup wizard** completes all 7 steps:
  1. Welcome
  2. Permissions check
  3. LLM setup choice
  4. Ollama configuration (if selected)
  5. Google AI configuration (if selected)
  6. Model role assignment
  7. Summary and finish
- [ ] **Chat interface** loads after setup
- [ ] **Settings window** opens (click gear icon)
- [ ] **Configuration saves** to `~/.turix/config.json`

### 3. Verify Configuration File

```bash
# Check config file exists
ls -la ~/.turix/config.json

# View config contents
cat ~/.turix/config.json

# Should see JSON with llm configurations
```

### 4. Check App Bundle

```bash
# Navigate to build products
cd ~/Library/Developer/Xcode/DerivedData

# Find TuriXMacApp folder
find . -name "TuriXMacApp.app" -type d

# Verify app structure
ls -la path/to/TuriXMacApp.app/Contents/
```

### 5. Test Code Signing

```bash
# Verify code signature
codesign -vv path/to/TuriXMacApp.app

# Check entitlements
codesign -d --entitlements :- path/to/TuriXMacApp.app
```

---

## Additional Resources

### Documentation
- [README.md](README.md) - Project overview
- [DEVELOPER_README.md](DEVELOPER_README.md) - Developer guide
- [END_USER_README.md](END_USER_README.md) - User guide
- [DOCUMENTATION_INDEX.md](DOCUMENTATION_INDEX.md) - All docs

### Xcode Documentation
- [Xcode Help](https://help.apple.com/xcode/)
- [Apple Developer Documentation](https://developer.apple.com/documentation/)
- [SwiftUI Tutorials](https://developer.apple.com/tutorials/swiftui)

### Getting Help
- **GitHub Issues**: https://github.com/Rashoooodi/TuriX-CUA/issues
- **Discord Community**: https://discord.gg/yaYrNAckb5
- **Email**: contact@turix.ai

---

## Quick Reference Commands

```bash
# Open project
open TuriXMacApp.xcodeproj

# Clean build folder
# In Xcode: Cmd+Shift+K

# Build
# In Xcode: Cmd+B

# Build and Run
# In Xcode: Cmd+R

# View build products
open ~/Library/Developer/Xcode/DerivedData

# Check code signature
codesign -vv path/to/TuriXMacApp.app

# Run app from terminal
./path/to/TuriXMacApp.app/Contents/MacOS/TuriXMacApp

# View config
cat ~/.turix/config.json

# Clear DerivedData (if issues)
rm -rf ~/Library/Developer/Xcode/DerivedData
```

---

## Build Checklist

Use this checklist for your first build:

- [ ] macOS 13.0+ installed
- [ ] Xcode 14.0+ installed
- [ ] Command Line Tools installed
- [ ] Project opened in Xcode
- [ ] Scheme set to "TuriXMacApp"
- [ ] Destination set to "My Mac"
- [ ] Code signing configured (team selected)
- [ ] Build succeeded (Cmd+B)
- [ ] App runs (Cmd+R)
- [ ] Setup wizard completed
- [ ] Configuration saved
- [ ] App functionality verified

---

**Last Updated**: February 2, 2026  
**Xcode Version Tested**: 15.0+  
**macOS Version Tested**: 13.0 (Ventura) and later

For questions or issues, please open an issue on GitHub or join our Discord community.
