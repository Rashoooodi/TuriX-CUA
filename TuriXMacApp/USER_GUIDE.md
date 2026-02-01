# TuriX macOS GUI User Guide

Complete guide for using the TuriX native macOS application.

## Table of Contents
1. [Getting Started](#getting-started)
2. [First-Time Setup](#first-time-setup)
3. [Using the Chat Interface](#using-the-chat-interface)
4. [Managing Settings](#managing-settings)
5. [Troubleshooting](#troubleshooting)
6. [FAQ](#faq)

---

## Getting Started

### System Requirements
- macOS 13.0 (Ventura) or later
- 8GB RAM minimum (16GB recommended for local models)
- Active internet connection (for cloud models)

### Installation

#### Option 1: Download Pre-built App (Recommended)
1. Download TuriXMacApp.dmg from releases
2. Open the DMG file
3. Drag TuriX.app to Applications folder
4. Double-click to launch

#### Option 2: Build from Source
```bash
cd TuriXMacApp
./build.sh
open build/Build/Products/Release/TuriXMacApp.app
```

---

## First-Time Setup

When you first launch TuriX, you'll be guided through a 7-step setup wizard.

### Step 1: Welcome

The welcome screen introduces TuriX and offers two options:

- **Get Started**: Begin the guided setup (recommended for first-time users)
- **Skip Setup**: Use default configuration and configure manually later

💡 **Tip**: We recommend completing the setup wizard to ensure optimal configuration.

### Step 2: System Permissions

TuriX requires certain macOS permissions to function:

#### Required Permissions

**Screen Recording**
- Allows TuriX to see your screen
- Required for the AI to understand visual context
- Grant in: System Settings → Privacy & Security → Screen Recording

**Accessibility**
- Allows TuriX to control your computer
- Required for executing automated actions
- Grant in: System Settings → Privacy & Security → Accessibility

#### Optional Permissions

**Notifications**
- Enables task completion alerts
- Can be enabled/disabled anytime in settings

#### Granting Permissions

1. Click "Open Settings" next to each permission
2. macOS will open the relevant settings panel
3. Enable the permission for TuriX
4. Return to TuriX (it auto-refreshes)
5. Once all required permissions are granted, click "Continue"

### Step 3: LLM Setup Choice

Choose how you want to run AI models:

#### Option 1: Local Only (Ollama)
**Best for**: Privacy-conscious users, offline work
- ✅ Free and private
- ✅ No API costs
- ✅ Works offline
- ❌ Requires ~16GB RAM
- ❌ Slower than cloud models
- ❌ Requires Ollama installation

#### Option 2: Cloud (Google AI)
**Best for**: Best performance, minimal local resources
- ✅ Fast and powerful
- ✅ Low RAM usage
- ✅ No local installation
- ❌ Requires internet
- ❌ API costs (typically $0.01-$0.10 per task)
- ❌ Data sent to cloud

#### Option 3: Hybrid (Recommended) ⭐
**Best for**: Balanced performance and cost
- ✅ Uses cloud for heavy reasoning
- ✅ Uses local for quick tasks
- ✅ Optimizes cost and speed
- ⚠️ Requires both Ollama and API key

💡 **Recommendation**: Choose Hybrid for the best balance of performance and cost.

### Step 4A: Ollama Configuration

If you selected Local or Hybrid:

#### Local Connection (Recommended)
1. Ensure Ollama is installed and running
2. Select "Local" connection type
3. Click "Test Connection"
4. Select your preferred model from the dropdown

#### Remote Connection
1. Select "Remote IP" connection type
2. Enter the IP address of your Ollama server
3. Enter the port (default: 11434)
4. Click "Test Connection"
5. Select your preferred model

**Available Models**:
- qwen2.5:latest (recommended)
- llama3.2:latest
- mistral:latest
- gemma2:latest

### Step 4B: Google AI Configuration

If you selected Cloud or Hybrid:

1. Get a free API key:
   - Click "Get Free API Key" link
   - Sign in with Google
   - Create and copy your API key
2. Paste API key into the field
3. Select your preferred model:
   - **Gemini 2.0 Flash** (recommended) - Fast and efficient
   - **Gemini 2.0 Pro** - Most capable
   - **Gemini 1.5 Flash** - Cost-effective
   - **Gemini 1.5 Pro** - Good balance
4. Click "Test Connection" to verify

### Step 5: Model Role Assignment

TuriX uses four specialized AI agents:

#### Roles

**🧠 Brain** (Main Reasoning)
- Understands your tasks
- Plans the overall strategy
- Recommended: Fast, capable model (Gemini 2.0 Flash or Qwen2.5)

**🎭 Actor** (Action Execution)
- Executes specific actions
- Interacts with your computer
- Recommended: Local model for quick responses (Qwen2.5)

**📝 Planner** (Task Planning)
- Breaks down complex tasks
- Creates step-by-step plans
- Recommended: Local model (Qwen2.5)

**💾 Memory** (Context Management)
- Manages conversation history
- Compresses long contexts
- Recommended: Efficient local model (Qwen2.5)

#### Assigning Models

1. Review the default assignments
2. Click "Use Recommended Configuration" for optimal setup
3. Or customize each role using the dropdowns
4. Check resource estimates before continuing

💡 **Tip**: The recommended configuration balances performance and cost effectively.

### Step 6: Optional Features

Enable additional features:

#### Discord Bot Integration ☐
- Control TuriX from Discord
- Requires additional configuration
- Can be set up later in settings

#### Desktop Notifications ☑
- Get alerts when tasks complete
- Recommended for awareness

#### Start Minimized to Menu Bar ☐
- App launches in menu bar instead of window
- Good for background operation

#### Launch at Login ☐
- Automatically starts TuriX on login
- Convenient for frequent use

### Step 7: Summary & Finish

Review your complete configuration:

1. **LLM Configuration**: Verify your provider choices
2. **Model Assignments**: Check role assignments
3. **Resource Estimates**: Review RAM and cost estimates
4. **Optional Features**: Confirm feature selections

If everything looks good:
1. Click "Finish Setup"
2. Configuration saves to ~/.turix/config.json
3. Success screen appears
4. Click "Open Chat" to start using TuriX

---

## Using the Chat Interface

### Starting a Conversation

The chat interface is your main way to interact with TuriX.

#### Example Tasks

**Simple Tasks**:
- "Open Chrome and go to github.com"
- "Create a new text document"
- "Take a screenshot"

**Complex Tasks**:
- "Search for iPhone prices, create a document with the results, and email it to john@example.com"
- "Check my calendar, find my next meeting, and create a reminder 15 minutes before"
- "Download the latest sales report, analyze the data, and create a summary presentation"

#### Best Practices

1. **Be Specific**: Provide clear, detailed instructions
   - ❌ "Check email"
   - ✅ "Open Mail app and check for unread emails from boss@company.com"

2. **Break Down Complex Tasks**: For very complex tasks, guide TuriX step by step
   - ❌ "Do everything for my presentation"
   - ✅ "First, open PowerPoint. Then create a new presentation with a title slide."

3. **Provide Context**: Include relevant details
   - ❌ "Send a message"
   - ✅ "Send a message to John Smith via Slack saying 'Meeting confirmed for 2pm'"

### Understanding Responses

TuriX will respond with:
- **Status updates**: "I'm opening Chrome now..."
- **Questions**: "Which browser would you like me to use?"
- **Results**: "Task completed successfully"
- **Errors**: "I couldn't find that file. Could you provide the full path?"

### Interrupting Tasks

If you need to stop a running task:
- Press Command+Shift+2 (default force stop hotkey)
- Or close the TuriX window

---

## Managing Settings

Access settings via Command+, or the gear icon in the header.

### General Settings

**Appearance**
- Control startup behavior
- Configure launch options

**Notifications**
- Enable/disable desktop notifications
- Control notification sounds

**Setup**
- Reset setup wizard (clears configuration and restarts setup)

### LLM Settings

**Current Configuration**
- View active model assignments
- See which providers are in use

**Reconfiguration**
- Change model assignments
- Update API keys
- Switch providers

### Advanced Settings

**Agent Configuration**
- Max Actions per Step: Controls action batching
- Max Steps: Limits task execution length
- Memory Budget: Controls conversation history size

**Features**
- UI Mode: Enable visual UI interaction
- Search: Enable web search capabilities
- Skills: Enable skill system

**Hotkeys**
- Force Stop: Keyboard shortcut to stop tasks

### About

- View app version
- Access documentation
- Join Discord community
- Report issues on GitHub

---

## Troubleshooting

### Common Issues

#### "Screen Recording permission denied"

**Solution**:
1. Open System Settings
2. Go to Privacy & Security → Screen Recording
3. Enable TuriX
4. Restart TuriX

#### "Accessibility permission denied"

**Solution**:
1. Open System Settings
2. Go to Privacy & Security → Accessibility
3. Click the lock to make changes
4. Add TuriX to the list
5. Restart TuriX

#### "Cannot connect to Ollama"

**Possible causes**:
- Ollama not installed
- Ollama not running
- Wrong IP/port

**Solution**:
1. Install Ollama from ollama.ai
2. Start Ollama: `ollama serve`
3. Verify it's running: `ollama list`
4. Test connection in TuriX settings

#### "Google AI API key invalid"

**Possible causes**:
- Key expired
- Key not activated
- Incorrect key format

**Solution**:
1. Go to https://makersuite.google.com/app/apikey
2. Create a new API key
3. Copy the entire key
4. Paste into TuriX settings
5. Test connection

#### "Task not executing correctly"

**Try**:
1. Be more specific in your instructions
2. Break down into smaller steps
3. Check if permissions are granted
4. Verify models are connected
5. Check console logs for errors

### Getting Help

If you continue experiencing issues:

1. **Check Documentation**: Review README and this guide
2. **Search Issues**: Check GitHub issues for similar problems
3. **Discord Community**: Ask in Discord for community support
4. **Report Bug**: Create a GitHub issue with:
   - Detailed description
   - Steps to reproduce
   - System information
   - Log files (from ~/.turix/logs/)

---

## FAQ

### General Questions

**Q: Is TuriX free?**
A: Yes, TuriX is 100% open-source and free for personal and research use. Cloud provider costs (if using Google AI) are separate.

**Q: Does TuriX work offline?**
A: Yes, if you use Local Only (Ollama) configuration. Cloud and Hybrid modes require internet.

**Q: What data does TuriX collect?**
A: TuriX runs locally on your machine. When using cloud providers, only the task instructions are sent to the AI service.

### Setup Questions

**Q: Can I change my configuration later?**
A: Yes, open Settings and use "Reset Setup Wizard" to reconfigure, or manually adjust settings.

**Q: Do I need both Ollama and Google AI?**
A: Only if you choose Hybrid mode. Local Only needs just Ollama, Cloud Only needs just Google AI.

**Q: How much does Google AI cost?**
A: Typically $0.01-$0.10 per task. Google provides free quota for new users.

### Usage Questions

**Q: What tasks can TuriX perform?**
A: TuriX can control any application on your Mac, including browsers, email clients, productivity apps, and more.

**Q: Can TuriX access my files?**
A: Only what you explicitly ask it to. TuriX requires permissions to access files and follows macOS security restrictions.

**Q: How do I stop a running task?**
A: Press Command+Shift+2 (or your configured hotkey).

### Technical Questions

**Q: What models does TuriX support?**
A: Ollama models (Qwen, Llama, Mistral, etc.) and Google AI models (Gemini 2.0/1.5 Flash/Pro).

**Q: How much RAM do I need?**
A: Minimum 8GB, recommended 16GB for local models. Cloud-only requires minimal RAM.

**Q: Where is my configuration stored?**
A: Configuration is saved in ~/.turix/config.json

**Q: Can I use custom models?**
A: Yes, any model compatible with Ollama can be used for local execution.

---

## Next Steps

- Join our [Discord community](https://discord.gg/yaYrNAckb5)
- Read the [technical documentation](README.md)
- Explore [example tasks](../examples/)
- Contribute on [GitHub](https://github.com/Rashoooodi/TuriX-CUA)

---

**Need more help?** Contact us at contact@turix.ai
