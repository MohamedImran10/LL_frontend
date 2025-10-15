import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../models/auth.dart';
import '../models/user.dart';
import '../services/auth_service.dart';
import '../services/storage_service.dart';
import '../utils/app_routes.dart';

class AuthController extends GetxController {
  final AuthService _authService = AuthService();
  
  // Loading states
  final RxBool isLoading = false.obs;
  final RxBool isPasswordVisible = false.obs;
  
  // Current user
  final Rxn<User> currentUser = Rxn<User>();
  
  // Form controllers - initialize immediately to prevent disposal issues
  late final TextEditingController emailController;
  late final TextEditingController passwordController;
  late final TextEditingController nameController;
  late final TextEditingController confirmPasswordController;
  
  // Form keys - use lazy initialization to prevent GlobalKey conflicts
  GlobalKey<FormState>? _loginFormKey;
  GlobalKey<FormState>? _signupFormKey;
  
  GlobalKey<FormState> get loginFormKey {
    _loginFormKey ??= GlobalKey<FormState>();
    return _loginFormKey!;
  }
  
  GlobalKey<FormState> get signupFormKey {
    _signupFormKey ??= GlobalKey<FormState>();
    return _signupFormKey!;
  }

  @override
  void onInit() {
    super.onInit();
    // Initialize controllers immediately
    emailController = TextEditingController();
    passwordController = TextEditingController();
    nameController = TextEditingController();
    confirmPasswordController = TextEditingController();
    
    checkAuthStatus();
  }

  Future<void> checkAuthStatus() async {
    try {
      final isLoggedIn = await StorageService.to.isLoggedIn;
      if (isLoggedIn) {
        // Get user data from storage
        final userName = StorageService.to.userName;
        final userEmail = StorageService.to.userEmail;
        
        if (userName.isNotEmpty && userEmail.isNotEmpty) {
          currentUser.value = User(
            id: '1', // Temporary ID for MVP
            name: userName,
            email: userEmail,
          );
          Get.offAllNamed(AppRoutes.dashboard);
        }
      }
    } catch (e) {
      debugPrint('Error checking auth status: $e');
    }
  }

  Future<void> login() async {
    print('🚀 AuthController.login() called');
    print('📧 Email: ${emailController.text.trim()}');
    print('🔑 Password length: ${passwordController.text.length}');
    
    if (loginFormKey.currentState?.validate() != true) {
      print('❌ Form validation failed');
      return;
    }
    
    print('✅ Form validation passed');
    
    try {
      isLoading.value = true;
      print('⏳ Loading state set to true');
      
      final authRequest = AuthRequest(
        email: emailController.text.trim(),
        password: passwordController.text,
      );
      
      print('📤 Sending login request...');
      final response = await _authService.login(authRequest);
      print('📥 Login response received: ${response.success}');
      
      if (response.success && response.token != null) {
        print('✅ Login successful, saving data...');
        // Save token and user data
        await StorageService.to.saveToken(response.token!);
        if (response.user != null) {
          await StorageService.to.saveUserData(response.user!);
          currentUser.value = User.fromJson(response.user!);
        }
        
        print('🏠 Navigating to dashboard...');
        Get.offAllNamed(AppRoutes.dashboard);
        Get.snackbar(
          'Success',
          'Logged in successfully!',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        Get.snackbar(
          'Error',
          response.message ?? 'Login failed. Email must contain @ and password must be 6+ characters.',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Something went wrong. Please try again.',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      debugPrint('Login error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signup() async {
    print('🚀 AuthController.signup() called');
    print('👤 Name: "${nameController.text.trim()}"');
    print('📧 Email: "${emailController.text.trim()}"');
    print('🔑 Password length: ${passwordController.text.length}');
    print('🔑 Confirm Password length: ${confirmPasswordController.text.length}');
    print('🔍 Passwords match: ${passwordController.text == confirmPasswordController.text}');
    
    // Debug form state
    print('📝 Form key: ${signupFormKey.toString()}');
    print('📝 Form currentState: ${signupFormKey.currentState}');
    
    // Try manual validation first
    if (nameController.text.trim().isEmpty) {
      print('❌ Manual validation: Name is empty');
      Get.snackbar('Validation Error', 'Please enter your name');
      return;
    }
    
    if (emailController.text.trim().isEmpty) {
      print('❌ Manual validation: Email is empty');
      Get.snackbar('Validation Error', 'Please enter your email');
      return;
    }
    
    if (!emailController.text.contains('@')) {
      print('❌ Manual validation: Email invalid');
      Get.snackbar('Validation Error', 'Please enter a valid email');
      return;
    }
    
    if (passwordController.text.length < 6) {
      print('❌ Manual validation: Password too short');
      Get.snackbar('Validation Error', 'Password must be at least 6 characters');
      return;
    }
    
    if (passwordController.text != confirmPasswordController.text) {
      print('❌ Manual validation: Passwords do not match');
      Get.snackbar('Validation Error', 'Passwords do not match');
      return;
    }
    
    // Now check form validation
    final isValid = signupFormKey.currentState?.validate();
    print('📝 Form validation result: $isValid');
    
    if (isValid != true) {
      print('❌ Form validation failed after manual checks passed');
      return;
    }
    
    print('✅ Form validation passed');
    
    try {
      isLoading.value = true;
      print('⏳ Loading state set to true');
      
      final authRequest = AuthRequest(
        name: nameController.text.trim(),
        email: emailController.text.trim(),
        password: passwordController.text,
        confirmPassword: confirmPasswordController.text,
      );
      
      print('📤 Sending signup request...');
      final response = await _authService.signup(authRequest);
      print('📥 Signup response received: ${response.success}');
      
      if (response.success) {
        // Always navigate to login after successful signup, regardless of auto-login
        Get.snackbar(
          'Success',
          'Account created successfully! Please login with your credentials.',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        
        // Clear only name and password fields, keep email for convenience
        nameController.clear();
        passwordController.clear();
        confirmPasswordController.clear();
        // Keep email prefilled: emailController.text already has the signup email
        
        print('✅ Signup successful, navigating to login...');
        
        // Use regular navigation to avoid controller disposal issues
        Get.toNamed(AppRoutes.login);
      } else {
        Get.snackbar(
          'Error',
          response.message ?? 'Signup failed',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Something went wrong. Please try again.',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      debugPrint('Signup error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    try {
      await StorageService.to.clearUserData();
      currentUser.value = null;
      clearAllForms();
      Get.offAllNamed(AppRoutes.login);
      
      Get.snackbar(
        'Success',
        'Logged out successfully!',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      debugPrint('Logout error: $e');
    }
  }

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  void navigateToSignup() {
    clearLoginForm();
    Get.toNamed(AppRoutes.signup);
  }

  void navigateToLogin() {
    clearSignupForm();
    Get.toNamed(AppRoutes.login);
  }

  void clearLoginForm() {
    emailController.clear();
    passwordController.clear();
  }

  void clearSignupForm() {
    nameController.clear();
    emailController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
  }

  void clearAllForms() {
    clearLoginForm();
    clearSignupForm();
  }
  
  void resetFormKeys() {
    _loginFormKey = null;
    _signupFormKey = null;
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    confirmPasswordController.dispose();
    _loginFormKey = null;
    _signupFormKey = null;
    super.onClose();
  }
}
