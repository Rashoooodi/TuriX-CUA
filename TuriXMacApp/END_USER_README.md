# TuriX macOS App - End User Guide

Welcome to TuriX! This guide will help you get started with the TuriX macOS application.

## What is TuriX?

TuriX is a native macOS application that lets you control your computer using AI. Simply tell TuriX what you want to do, and it will perform tasks on your desktop automatically.

## Installation

### Option 1: Download Pre-built App (Coming Soon)
1. Download TuriXMacApp.dmg from releases
2. Open the DMG file
3. Drag TuriX.app to Applications folder
4. Double-click to launch

### Option 2: Build from Source
If you're comfortable with development tools:
```bash
cd TuriXMacApp
open TuriXMacApp.xcodeproj
# Press Cmd+R in Xcode to build and run
```

## First Launch - Setup Wizard

When you first open TuriX, a setup wizard will guide you through configuration:

### Step 1: Welcome
- Read the introduction
- Click "Get Started" or "Skip Setup" for defaults

### Step 2: Grant Permissions
TuriX needs these macOS permissions:
- **Screen Recording** (Required) - So AI can see your screen
- **Accessibility** (Required) - So AI can control your computer

Click "Open Settings" for each permission and enable TuriX in System Settings.

### Step 3: Choose AI Provider
Pick how you want to run AI models:
- **Local Only (Ollama)** - Free, private, needs ~16GB RAM
- **Cloud (Google AI)** - Fast, costs ~$0.01-$0.10 per task
- **Hybrid** ⭐ Recommended - Mix of both

### Step 4: Configure Providers
- **For Ollama**: Install from https://ollama.ai, then connect
- **For Google AI**: Get free API key from https://makersuite.google.com/app/apikey

### Step 5: Assign Models
Choose which AI model handles each task type (or use recommended settings)

### Step 6: Optional Features
- Discord bot integration
- Desktop notifications
- Launch at login

### Step 7: Finish
Review your settings and click "Finish Setup"

## Using TuriX

### Chat Interface
After setup, you'll see the main chat window:

1. **Type your task** in the text box at the bottom
2. **Press Enter** or click the send button
3. **Watch TuriX work** - it will perform the task on your desktop

### Example Tasks
- "Open Chrome and search for iPhone prices"
- "Create a new document and write a summary"
- "Check my email and reply to the latest message"
- "Find that presentation I was working on yesterday"

### Settings
Click the gear icon (⚙️) to:
- Change AI models
- Reset setup wizard
- Adjust advanced settings

## Troubleshooting

### "Permission Denied" Errors
1. Open **System Settings** > **Privacy & Security**
2. Go to **Screen Recording** - enable TuriX
3. Go to **Accessibility** - enable TuriX
4. Restart TuriX

### "Cannot Connect to Ollama"
1. Install Ollama: https://ollama.ai
2. Start Ollama: Open Terminal and run `ollama serve`
3. Test: Run `ollama list` to see available models
4. Return to TuriX and test connection

### "Invalid Google AI API Key"
1. Visit https://makersuite.google.com/app/apikey
2. Sign in with your Google account
3. Create a new API key
4. Copy the entire key and paste in TuriX
5. Test the connection

### Task Not Working
- Be specific in your instructions
- Break complex tasks into smaller steps
- Check that permissions are still granted
- Verify AI models are connected

## Getting Help

- **Discord Community**: https://discord.gg/yaYrNAckb5
- **GitHub Issues**: https://github.com/Rashoooodi/TuriX-CUA/issues
- **Email Support**: contact@turix.ai

## Keyboard Shortcuts

- **Cmd+,** - Open Settings
- **Cmd+Shift+2** - Force stop current task (default)
- **Cmd+Q** - Quit TuriX

## Privacy & Safety

- **Local mode**: All data stays on your computer
- **Cloud mode**: Only task instructions are sent to AI provider
- **No tracking**: TuriX doesn't collect usage data
- **Open source**: You can review all code on GitHub

## System Requirements

- **macOS**: 13.0 (Ventura) or later
- **RAM**: 8GB minimum, 16GB recommended for local AI
- **Internet**: Required for cloud AI, optional for local mode
- **Storage**: ~500MB for app, varies for local AI models

## Configuration Files

TuriX stores settings in:
- **Config**: `~/.turix/config.json`
- **Setup flag**: `~/.turix/setup_completed`

To reset everything, delete the `~/.turix` folder.

## Updates

Check for updates:
1. Visit https://github.com/Rashoooodi/TuriX-CUA/releases
2. Download latest version
3. Replace old app with new one

## Next Steps

1. ✅ Complete setup wizard
2. ✅ Try example tasks
3. ✅ Join Discord community
4. ✅ Share your favorite use cases!

---

**Need more help?** See the detailed [USER_GUIDE.md](USER_GUIDE.md) or ask on [Discord](https://discord.gg/yaYrNAckb5)!
