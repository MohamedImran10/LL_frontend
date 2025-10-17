import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../models/auth.dart';
import '../models/user.dart';
import '../services/auth_service.dart';
import '../services/flight_agent_service.dart';
import '../services/google_signin_service.dart';
import '../services/storage_service.dart';
import '../utils/app_routes.dart';

class AuthController extends GetxController {
  final AuthService _authService = AuthService();
  final GoogleSignInService _googleSignInService = GoogleSignInService();
  
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
  
  // Form keys - create unique keys for each screen
  GlobalKey<FormState>? _loginFormKey;
  GlobalKey<FormState>? _signupFormKey;
  
  GlobalKey<FormState> get loginFormKey {
    _loginFormKey ??= GlobalKey<FormState>(debugLabel: 'loginForm');
    return _loginFormKey!;
  }
  
  GlobalKey<FormState> get signupFormKey {
    _signupFormKey ??= GlobalKey<FormState>(debugLabel: 'signupForm');
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
          
          // Only navigate to dashboard if we're not already there
          final currentRoute = Get.currentRoute;
          if (currentRoute != AppRoutes.dashboard) {
            Get.offAllNamed(AppRoutes.dashboard);
          }
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
        
        // Show success message with loading
        Get.snackbar(
          'Success',
          'Logged in successfully! Redirecting...',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(milliseconds: 1200),
        );
        
        // Add a brief delay to show the success message
        await Future.delayed(const Duration(milliseconds: 800));
        
        print('🏠 Navigating to dashboard...');
        Get.offAllNamed(AppRoutes.dashboard);
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
          'Account created successfully! Redirecting to login...',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(milliseconds: 1200),
        );
        
        // Clear only name and password fields, keep email for convenience
        nameController.clear();
        passwordController.clear();
        confirmPasswordController.clear();
        // Keep email prefilled: emailController.text already has the signup email
        
        print('✅ Signup successful, navigating to login...');
        
        // Add a brief delay to show the success message
        await Future.delayed(const Duration(milliseconds: 800));
        
        // Reset form keys before navigation to prevent conflicts
        resetFormKeys();
        
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
      // Sign out from Google if signed in
      await _googleSignInService.signOut();
      
      // Clear user data (but keep user-specific chat history)
      await StorageService.to.clearUserData();
      currentUser.value = null;
      clearAllForms();
      resetFormKeys();
      
      // Clear chat history from FlightAgentService
      try {
        final flightAgent = Get.find<FlightAgentService>();
        flightAgent.clearChatHistory();
      } catch (e) {
        // FlightAgentService might not be initialized yet
        debugPrint('FlightAgentService not found: $e');
      }
      
      Get.snackbar(
        'Success',
        'Logged out successfully!',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
      
      // Navigate to login
      Get.offAllNamed(AppRoutes.login);
    } catch (e) {
      debugPrint('Logout error: $e');
    }
  }

  /// Sign in with Google
  Future<void> signInWithGoogle() async {
    try {
      isLoading.value = true;
      
      final result = await _googleSignInService.signInWithGoogle();
      
      if (result != null && result['success'] == true) {
        // Save user data to storage
        await StorageService.to.saveToken(result['token']);
        await StorageService.to.saveUserData({
          'name': result['name'],
          'email': result['email'],
        });
        
        // Set current user
        currentUser.value = User(
          id: result['uid'],
          name: result['name'],
          email: result['email'],
        );
        
        Get.snackbar(
          'Success',
          'Welcome ${result['name']}!',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        
        // Navigate to dashboard
        Get.offAllNamed(AppRoutes.dashboard);
      } else if (result != null && result['success'] == false) {
        // Show error from service
        Get.snackbar(
          'Error',
          result['error'] ?? 'Failed to sign in with Google',
          backgroundColor: Colors.orange,
          colorText: Colors.white,
          duration: const Duration(seconds: 4),
        );
      }
    } catch (e) {
      debugPrint('Google Sign-In error: $e');
      Get.snackbar(
        'Error',
        'Failed to sign in with Google. Please ensure Firebase is configured.',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 4),
      );
    } finally {
      isLoading.value = false;
    }
  }

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  void navigateToSignup() {
    clearLoginForm();
    resetFormKeys(); // Reset form keys to prevent conflicts
    Get.toNamed(AppRoutes.signup);
  }

  void navigateToLogin() {
    clearSignupForm();
    resetFormKeys(); // Reset form keys to prevent conflicts
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
