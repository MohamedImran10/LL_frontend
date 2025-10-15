# LetzLevitate - Flutter Flight Booking App

A beautiful Flutter application for flight booking with AI-powered search, onboarding experience, authentication, and dashboard features following MVVC (Model-View-ViewController) architecture using GetX.

## Features

### ✈️ Onboarding Experience
- **3 Beautiful Onboarding Screens** focused on flight booking journey
- Smooth page transitions with animated indicators
- Skip functionality for returning users
- Modern UI with flight-themed design elements

### 🔐 Authentication System
- **Social Login Options** (Google, Facebook, Apple) - UI ready
- **Email/Password Registration** with validation
- **Secure Login** with password visibility toggle
- Form validation with user-friendly error messages
- Demo credentials for testing: `demo@example.com` / `demo123`

### � Flight Dashboard
- Welcome message with personalized greeting
- Feature cards for AI flight search, quick booking, payment options, and travel history
- Clean, modern Material Design UI with flight theme

## ✅ **Current Status: ALL BUGS FIXED!**

### 🐛 **Recently Fixed Issues:**
- ✅ **Null check operator errors** - Fixed form validation logic
- ✅ **GlobalKey conflicts** - Implemented stable key management
- ✅ **Onboarding not appearing** - Enhanced splash navigation logic
- ✅ **Form submission failures** - Added comprehensive error handling
- ✅ **Network authentication errors** - Enhanced demo login system

### 🧪 **Quick Testing:**
```bash
# Reset app state and test complete flow
./test_app.sh
```

## Setup Instructions

### Installation

1. **Navigate to project directory**
   ```bash
   cd frontend
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the application**
   ```bash
   # For Linux desktop
   flutter run -d linux
   
   # For web (requires web support)
   flutter run -d chrome
   ```

### Demo Credentials
For testing the login functionality:
- **Email:** `demo@example.com`
- **Password:** `demo123`

Alternative demo account:
- **Email:** `test@letzlevitate.com`
- **Password:** `test123`

## Troubleshooting

### Common Issues

1. **App doesn't show onboarding on first launch**
   - Clear app storage: Run `flutter clean` then launch app
   - Or manually clear SharedPreferences data

2. **GlobalKey conflicts**
   - Restart the app completely
   - The app now uses unique GlobalKey identifiers to prevent conflicts

3. **Network errors during login**
   - Use the demo credentials above
   - The app works offline with built-in demo authentication

## Design System

### Color Palette
- **Primary Blue:** `#007AFF` - Main brand color
- **White:** `#FFFFFF` - Background and text
- **Light Grey:** `#F2F2F7` - Input fields and cards
- **Medium Grey:** `#8E8E93` - Secondary text

## MVVC Architecture
- **Models:** Data structures (`lib/app/models/`)
- **Views:** UI screens (`lib/app/views/`)
- **Controllers:** GetX controllers (`lib/app/controllers/`)
- **Services:** API and storage (`lib/app/services/`)

**Built with ❤️ using Flutter and GetX**
