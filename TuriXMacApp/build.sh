#!/bin/bash
# Build script for TuriX macOS Application

set -e

echo "🔨 Building TuriX macOS Application..."

# Check if Xcode is installed
if ! command -v xcodebuild &> /dev/null; then
    echo "❌ Error: Xcode is not installed or xcodebuild is not in PATH"
    echo "Please install Xcode from the Mac App Store"
    exit 1
fi

# Check macOS version
if [[ $(sw_vers -productVersion | cut -d. -f1) -lt 13 ]]; then
    echo "⚠️  Warning: This app requires macOS 13.0 or later"
fi

cd "$(dirname "$0")"

# Clean build folder
echo "🧹 Cleaning build folder..."
rm -rf build/

# Build the application
echo "🔧 Building application..."
xcodebuild \
    -project TuriXMacApp.xcodeproj \
    -scheme TuriXMacApp \
    -configuration Release \
    -derivedDataPath build/ \
    clean build

# Check if build was successful
if [ $? -eq 0 ]; then
    echo "✅ Build successful!"
    echo "📦 Application built at: build/Build/Products/Release/TuriXMacApp.app"
    echo ""
    echo "To run the application:"
    echo "  open build/Build/Products/Release/TuriXMacApp.app"
else
    echo "❌ Build failed!"
    exit 1
fi
