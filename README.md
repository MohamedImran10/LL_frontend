# LL Frontend - Flutter Smart Home App

A beautiful Flutter application for smart home control with onboarding, authentication, and dashboard features following MVVC (Model-View-ViewController) architecture using GetX.

## Features

### 🎯 Onboarding Experience
- **3 Beautiful Onboarding Screens** inspired by smart home concepts
- Smooth page transitions with animated indicators
- Skip functionality for returning users
- Modern UI with floating design elements

### 🔐 Authentication System
- **Social Login Options** (Google, Facebook, Apple) - UI ready
- **Email/Password Registration** with validation
- **Secure Login** with password visibility toggle
- Form validation with user-friendly error messages
- Demo credentials for testing: `demo@example.com` / `demo123`

### 🏠 Smart Dashboard
- Welcome message with personalized greeting
- Feature cards for future smart home functionality
- Clean, modern Material Design UI
- Logout functionality with confirmation dialog

### 🏗️ Architecture
- **MVVC Architecture** using GetX for state management
- **Separation of Concerns** with models, views, and controllers
- **Service Layer** for API calls and data persistence
- **Secure Storage** for authentication tokens
- **Route Management** with GetX navigation

## Technical Stack

- **Flutter 3.0+** - Cross-platform framework
- **GetX** - State management and navigation
- **Shared Preferences** - Local data storage
- **Flutter Secure Storage** - Secure token storage
- **HTTP** - API communication
- **Email Validator** - Form validation

## Setup Instructions

### Prerequisites
- Flutter SDK 3.0 or higher
- Dart SDK 3.0 or higher
- Android Studio / VS Code with Flutter extensions

### Installation

1. **Navigate to project directory**
   ```bash
   cd LL_frontend
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the application**
   ```bash
   flutter run
   ```

### Demo Credentials
For testing the login functionality:
- **Email:** `demo@example.com`
- **Password:** `demo123`

## Design System

### Color Palette
- **Primary Blue:** `#007AFF` - Main brand color
- **White:** `#FFFFFF` - Background and text
- **Light Grey:** `#F2F2F7` - Input fields and cards
- **Medium Grey:** `#8E8E93` - Secondary text
- **Success Green:** `#34C759`
- **Error Red:** `#FF3B30`

### Typography
- **Font Family:** Inter
- **Weights:** Regular (400), Medium (500), SemiBold (600), Bold (700)

**Built with ❤️ using Flutter and GetX**