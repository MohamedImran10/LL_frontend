import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/auth_controller.dart';
import '../../utils/app_theme.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/social_login_button.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Use Get.find() if exists, otherwise create new instance
    final authController = Get.isRegistered<AuthController>() 
        ? Get.find<AuthController>() 
        : Get.put(AuthController());
    
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 32),
              
              // Logo and brand
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.flight,
                      color: AppColors.white,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'LetzLevitate',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: AppColors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 48),
              
              // Title
              Text(
                'Sign in',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: AppColors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              
              const SizedBox(height: 8),
              
              // Subtitle
              Text(
                "Let's come together to share your experiences\nwith the products you have used.",
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.grey,
                  height: 1.4,
                ),
              ),
              
              const SizedBox(height: 32),
              
              // Social login buttons
              Row(
                children: [
                  Expanded(
                    child: SocialLoginButton(
                      icon: Icons.g_mobiledata,
                      onPressed: () {
                        // Google login functionality
                        Get.snackbar('Info', 'Google login not implemented in MVP');
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: SocialLoginButton(
                      icon: Icons.facebook,
                      onPressed: () {
                        // Facebook login functionality
                        Get.snackbar('Info', 'Facebook login not implemented in MVP');
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: SocialLoginButton(
                      icon: Icons.apple,
                      onPressed: () {
                        // Apple login functionality
                        Get.snackbar('Info', 'Apple login not implemented in MVP');
                      },
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 32),
              
              // Login form
              Form(
                key: authController.loginFormKey,
                child: Column(
                  children: [
                    // Email field
                    CustomTextField(
                      controller: authController.emailController,
                      hintText: 'Email',
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        // Enhanced email validation
                        final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
                        if (!emailRegex.hasMatch(value.trim())) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Password field
                    Obx(() => CustomTextField(
                      controller: authController.passwordController,
                      hintText: 'Password',
                      obscureText: !authController.isPasswordVisible.value,
                      suffixIcon: IconButton(
                        icon: Icon(
                          authController.isPasswordVisible.value
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: AppColors.grey,
                        ),
                        onPressed: authController.togglePasswordVisibility,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }
                        return null;
                      },
                    )),
                    
                    const SizedBox(height: 24),
                    
                    // Login button
                    SizedBox(
                      width: double.infinity,
                      child: Obx(() => ElevatedButton(
                        onPressed: authController.isLoading.value 
                            ? null 
                            : authController.login,
                        child: authController.isLoading.value
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.white),
                                ),
                              )
                            : const Text('Sign in'),
                      )),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Sign up link
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don't have an account? ",
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.grey,
                    ),
                  ),
                  GestureDetector(
                    onTap: authController.navigateToSignup,
                    child: Text(
                      'Sign up',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
