import 'package:shared_preferences/shared_preferences.dart';

Future<void> clearAppStorage() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.clear();
  print('✅ Storage cleared! App will show onboarding on next launch.');
}

Future<void> debugStorage() async {
  final prefs = await SharedPreferences.getInstance();
  print('=== Storage Debug ===');
  print('isFirstTime: ${prefs.getBool('isFirstTime') ?? true}');
  print('auth_token: ${prefs.getString('auth_token') ?? 'null'}');
  print('user_name: ${prefs.getString('user_name') ?? 'null'}');
  print('user_email: ${prefs.getString('user_email') ?? 'null'}');
  print('All keys: ${prefs.getKeys()}');
  print('===================');
}

Future<void> forceOnboarding() async {
  final prefs = await SharedPreferences.getInstance();
  // Clear all data first
  await prefs.clear();
  // Explicitly set first time to true
  await prefs.setBool('isFirstTime', true);
  print('✅ Forced onboarding state! isFirstTime set to true');
}

void main() async {
  print('🚀 Debug Storage Utility - FORCING ONBOARDING');
  print('Before clearing:');
  await debugStorage();
  
  await forceOnboarding();
  
  print('\nAfter forcing onboarding:');
  await debugStorage();
  
  print('\n🎯 Storage has been reset. Restart the app to see onboarding!');
}
