#!/bin/bash

echo "🚀 LetzLevitate Debug Test Script"
echo "================================="

# Navigate to the frontend directory
cd /home/imran/MVP/LL_frontend/frontend

echo "📱 Step 1: Info about storage clearing..."
echo "   Note: Use the debug button (refresh icon) on splash screen to clear storage"
echo "   Or uncomment the clearAll() line in splash_screen.dart"

echo ""
echo "🔨 Step 2: Running Flutter app in debug mode..."
echo "   Watch the console output for debug messages!"
echo "   Expected flow: Splash -> (clear storage if needed) -> Onboarding -> Login"
echo ""
echo "🎯 Testing Instructions:"
echo "   1. App shows splash screen for 2 seconds"
echo "   2. If onboarding doesn't appear, tap the debug button (🔄) on splash"
echo "   3. Then you'll see 3 onboarding screens (flight booking theme)"
echo "   4. After onboarding, you'll see login screen"
echo "   5. Use ANY email + password (6+ characters):"
echo "      ✅ user@example.com / password123"
echo "      ✅ test@gmail.com / 123456"
echo "      ✅ your.email@domain.com / yourpass"
echo "      ✅ ANY email with @ + 6+ char password!"
echo "   6. Should navigate to dashboard after successful login"
echo "   7. Any email can be used for signup (creates demo account)"
echo ""
echo "📝 Debug Tips:"
echo "   - Watch console for emoji debug messages (🚀📧✅❌)"
echo "   - If GlobalKey errors occur, restart the app"
echo "   - If onboarding doesn't show, use debug button on splash"
echo "   - Signup with any email works in demo mode"
echo ""

# Run the app
flutter run -d linux --debug
