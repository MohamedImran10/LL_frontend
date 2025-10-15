#!/bin/bash

# Flutter Android Setup Script
echo "🚀 Setting up Flutter Android Environment..."

# Set Android environment variables
export ANDROID_HOME=/home/imran/Android/Sdk
export PATH=$PATH:$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/platform-tools:$ANDROID_HOME/emulator

echo "✅ ANDROID_HOME: $ANDROID_HOME"
echo "✅ Android tools added to PATH"

# Check connected devices
echo "📱 Checking connected devices..."
flutter devices

echo ""
echo "🛠 To run the Flutter app on your device:"
echo "1. Make sure your device is connected and USB debugging is enabled"
echo "2. Run: flutter run --android-skip-build-dependency-validation"
echo ""
echo "🔧 Alternative commands:"
echo "- flutter run -d android                    # Run on Android device"
echo "- flutter run -d ZD2222GSL4                # Run on specific device"
echo "- flutter build apk                        # Build APK file"
echo "- flutter install                          # Install built APK"
echo ""

# Navigate to project directory
cd /home/imran/MVP/LL_frontend/frontend

echo "📁 Current directory: $(pwd)"
echo ""
echo "🚀 Ready to run Flutter app!"
