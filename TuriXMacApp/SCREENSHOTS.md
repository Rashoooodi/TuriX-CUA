# TuriX macOS GUI Screenshots & UI Flow

This document describes the UI flow and screens of the TuriX native macOS application.

## Setup Flow

The setup flow guides new users through configuring TuriX with a 7-step wizard:

### Step 1: Welcome Screen
**Purpose**: Introduce users to TuriX and provide options to start setup or skip

**UI Elements**:
- TuriX logo (brain icon)
- Welcome title "Welcome to TuriX"
- Subtitle "Desktop Actions, Driven by AI"
- Introduction text
- "Get Started" button (primary)
- "Skip Setup" button (secondary)

**User Journey**:
- Users click "Get Started" to begin setup
- Or "Skip Setup" to use default configuration

---

### Step 2: System Permissions Check
**Purpose**: Ensure all required macOS permissions are granted

**UI Elements**:
- Title "System Permissions"
- Three permission rows with status indicators:
  1. **Screen Recording** (Required) - ✅ Granted / ❌ Not Granted
  2. **Accessibility** (Required) - ✅ Granted / ❌ Not Granted
  3. **Notifications** (Optional) - ✅ Granted / ⚠️ Optional
- Each row has:
  - Permission name and description
  - Status icon
  - "Open Settings" button
- "Refresh Status" button
- "Continue" button (disabled until required permissions granted)
- "Back" button

**User Journey**:
1. System checks current permission status
2. User clicks "Open Settings" for missing permissions
3. macOS opens System Settings to relevant panel
4. User grants permission and returns to app
5. App auto-refreshes status
6. Once required permissions granted, "Continue" becomes enabled

---

### Step 3: LLM Setup Choice
**Purpose**: Let users choose between Local, Cloud, or Hybrid LLM configuration

**UI Elements**:
- Title "LLM Setup"
- Subtitle "Choose how you want to run AI models"
- Three radio button cards:
  1. **Local Only (Ollama)** - "Free, private, requires ~16GB RAM"
  2. **Cloud (Google AI)** - "Best performance, API costs"
  3. **Hybrid** - "Mix of local and cloud models" (Recommended badge)
- "Continue" button
- "Back" button

**User Journey**:
1. User selects one of three options
2. Selection determines which configuration screens appear next
3. Recommended option (Hybrid) is pre-selected

---

### Step 4A: Ollama Configuration
**Purpose**: Configure connection to Ollama (local or remote)

**Shown When**: User selected "Local Only" or "Hybrid" in Step 3

**UI Elements**:
- Title "Ollama Configuration"
- Connection type selector (segmented control):
  - Local (localhost:11434)
  - Remote IP
- For Remote option:
  - IP Address text field
  - Port text field (default: 11434)
- Connection status: 🟢 Connected / 🔴 Failed / ⏳ Testing / ⚪️ Not tested
- "Test Connection" button
- Model selection dropdown (appears after successful connection)
- "Continue" or "Continue to Google AI" button (depending on choice in Step 3)
- "Back" button

**User Journey**:
1. User selects Local or Remote connection
2. For Remote, enters IP and port
3. Clicks "Test Connection"
4. System tests connection and displays available models
5. User selects preferred model from dropdown
6. Clicks "Continue" (or "Continue to Google AI" for Hybrid setup)

---

### Step 4B: Google AI Configuration
**Purpose**: Configure Google AI API access

**Shown When**: User selected "Cloud Only" or "Hybrid" in Step 3

**UI Elements**:
- Title "Google AI Configuration"
- API Key input field with show/hide toggle (eye icon)
- "Get Free API Key" link (opens https://makersuite.google.com/app/apikey)
- Model selection dropdown:
  - Gemini 2.0 Flash (Recommended)
  - Gemini 2.0 Pro
  - Gemini 1.5 Flash
  - Gemini 1.5 Pro
- Connection status: 🟢 Connected / 🔴 Failed / ⏳ Testing
- "Test Connection" button
- "Continue" button
- "Back" button

**User Journey**:
1. User enters or pastes Google AI API key
2. Selects preferred model from dropdown
3. Clicks "Test Connection" to verify API key
4. System validates key and shows success/failure
5. Clicks "Continue" when connection successful

---

### Step 5: Model Role Assignment
**Purpose**: Assign specific models to different agent roles

**UI Elements**:
- Title "Model Role Assignment"
- Four role assignment rows:
  1. 🧠 **Brain** (Main reasoning)
  2. 🎭 **Actor** (Action execution)
  3. 📝 **Planner** (Task planning)
  4. 💾 **Memory** (Context management)
- Each row has:
  - Role icon and name
  - Description
  - Model selection dropdown (shows available Ollama and Google models)
- "Use Recommended Configuration" button
- Resource estimates panel:
  - Estimated RAM Usage (e.g., "~12GB")
  - Cost per Task (e.g., "$0.01 - $0.10" or "Free")
- "Continue" button
- "Back" button

**User Journey**:
1. User sees default/recommended assignments
2. Optionally clicks "Use Recommended Configuration" to reset to recommended
3. Or customizes each role by selecting from dropdown
4. Reviews resource estimates
5. Clicks "Continue" when satisfied

---

### Step 6: Optional Features
**Purpose**: Enable or disable optional features

**UI Elements**:
- Title "Optional Features"
- Four feature toggles:
  1. ☐ **Discord Bot Integration** - "Enable Discord bot for remote task execution" (note: "Can be configured later in settings")
  2. ☐ **Desktop Notifications** - "Get notified when tasks complete"
  3. ☐ **Start Minimized to Menu Bar** - "App starts in menu bar instead of window"
  4. ☐ **Launch at Login** - "Automatically start TuriX when you log in"
- Each toggle has:
  - Icon
  - Title
  - Description
  - Optional note
  - On/Off switch
- "Continue" button
- "Back" button

**User Journey**:
1. User reviews optional features
2. Toggles features on/off as desired
3. Clicks "Continue"

---

### Step 7: Summary & Finish
**Purpose**: Review complete configuration before saving

**UI Elements**:
- Title "Configuration Summary"
- Four summary sections:
  1. **LLM Configuration**
     - Setup Type (Local/Cloud/Hybrid)
     - Ollama status (if configured)
     - Google AI status (if configured)
  2. **Model Assignments**
     - Brain assignment
     - Actor assignment
     - Planner assignment
     - Memory assignment
  3. **Resource Estimates**
     - RAM Usage
     - Cost per Task
  4. **Optional Features**
     - Discord Integration status
     - Notifications status
     - Start Minimized status
     - Launch at Login status
- "Go Back" button
- "Finish Setup" button (primary, large)

**After Clicking "Finish Setup"**:
- Success screen appears:
  - Green checkmark icon
  - "Setup Complete! 🎉"
  - "TuriX is now ready to use"
  - "Open Chat" button (large, primary)

**User Journey**:
1. User reviews complete configuration summary
2. If changes needed, clicks "Go Back"
3. If satisfied, clicks "Finish Setup"
4. Configuration is saved to ~/.turix/config.json
5. Setup completed flag is set
6. Success screen appears
7. User clicks "Open Chat" to enter main application

---

## Main Application

### Chat Interface
**Purpose**: Primary interface for interacting with TuriX AI agent

**UI Elements**:
- **Header**:
  - TuriX logo and title
  - Settings button (gear icon)
- **Chat Area**:
  - Message history (scrollable)
  - User messages (right-aligned, blue)
  - AI messages (left-aligned, gray)
  - Timestamps
- **Empty State** (when no messages):
  - Bubble icon
  - "Welcome to TuriX" title
  - "Ask me to perform tasks on your desktop" subtitle
  - Example tasks with lightbulb icons:
    - "Open Chrome and search for news"
    - "Create a new document and write a summary"
    - "Check my email and reply to the latest message"
- **Input Area** (bottom):
  - Multi-line text editor (expandable)
  - Send button (arrow up icon, blue when enabled)
  - Hourglass icon when processing

**User Journey**:
1. User types task in input field
2. Clicks send button or presses Enter
3. Message appears in chat as user message
4. Processing indicator shows while AI works
5. AI response appears in chat
6. User can continue conversation or start new task

---

### Settings Window
**Purpose**: Configure and manage TuriX settings

Accessed via: Command+, or Settings button in header

**Four Tabs**:

#### 1. General Tab
- **Appearance Section**:
  - Start minimized to menu bar toggle
  - Launch at login toggle
- **Notifications Section**:
  - Desktop notifications toggle
  - Sound notifications toggle
- **Setup Section**:
  - "Reset Setup Wizard" button (red)

#### 2. LLM Tab
- **Current Configuration Section**:
  - Lists current model assignments:
    - Brain: [provider] - [model]
    - Actor: [provider] - [model]
    - Planner: [provider] - [model]
    - Memory: [provider] - [model]
- "Reconfigure Models" button

#### 3. Advanced Tab
- **Agent Configuration Section**:
  - Max Actions per Step: 5
  - Max Steps: 100
  - Memory Budget: 2000
- **Features Section**:
  - Use UI mode toggle
  - Use search toggle
  - Use skills toggle
- **Hotkeys Section**:
  - Force Stop: Command+Shift+2

#### 4. About Tab
- TuriX logo (large)
- "TuriX" title
- "Desktop Actions, Driven by AI" subtitle
- Version number
- Links:
  - Documentation
  - Discord Community
  - Report Issues

---

## UI Design Principles

### Colors
- **Primary**: Blue (#007AFF) - Actions, selections
- **Success**: Green - Confirmations, permissions granted
- **Warning**: Orange - Optional items, notes
- **Error**: Red - Failures, missing required permissions
- **Gray**: Secondary text, backgrounds

### Typography
- **Large Title**: 34pt, Bold - Screen titles
- **Title**: 28pt, Bold - Section headers
- **Headline**: 17pt, Semibold - Card titles
- **Body**: 15pt, Regular - Descriptions
- **Caption**: 13pt, Regular - Secondary info

### Spacing
- Consistent 20-30px padding
- 15-20px spacing between elements
- Generous whitespace for readability

### Iconography
- System SF Symbols used throughout
- Consistent icon sizing
- Icons always paired with text labels

### Interaction States
- Hover: Subtle highlight
- Active: Darker shade
- Disabled: 50% opacity
- Loading: Animated spinner or progress indicator

---

## Accessibility

- Full keyboard navigation support
- VoiceOver compatible labels
- High contrast mode support
- Dynamic type support for text scaling
- Focus indicators for interactive elements

---

## Technical Notes

- Built with SwiftUI for native macOS experience
- Supports macOS 13.0+
- Dark mode automatically adapts
- Respects system accent colors
- Window resizing supported (minimum 800x600)
