import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService extends GetxService {
  static StorageService get to => Get.find();
  
  SharedPreferences? _prefs;

  Future<StorageService> init() async {
    _prefs = await SharedPreferences.getInstance();
    return this;
  }

  // Onboarding
  bool get isFirstTime => _prefs?.getBool('isFirstTime') ?? true;
  Future<void> setFirstTime(bool value) async {
    await _prefs?.setBool('isFirstTime', value);
  }

  // Authentication
  Future<void> saveToken(String token) async {
    await _prefs?.setString('auth_token', token);
  }

  Future<String?> getToken() async {
    return _prefs?.getString('auth_token');
  }

  Future<void> removeToken() async {
    await _prefs?.remove('auth_token');
  }

  Future<bool> get isLoggedIn async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }

  // User data
  Future<void> saveUserData(Map<String, dynamic> userData) async {
    await _prefs?.setString('user_name', userData['name'] ?? '');
    await _prefs?.setString('user_email', userData['email'] ?? '');
  }

  String get userName => _prefs?.getString('user_name') ?? '';
  String get userEmail => _prefs?.getString('user_email') ?? '';

  Future<void> clearUserData() async {
    await _prefs?.remove('user_name');
    await _prefs?.remove('user_email');
    await removeToken();
  }

  // Clear all data (for testing/debugging)
  Future<void> clearAll() async {
    await _prefs?.clear();
    print('StorageService: All data cleared');
  }
  
  // Debug method to check current storage state
  void debugStorage() {
    print('=== StorageService Debug ===');
    print('isFirstTime: ${isFirstTime}');
    print('userName: $userName');
    print('userEmail: $userEmail');
    print('===========================');
  }
}
