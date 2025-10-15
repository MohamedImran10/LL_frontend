import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/auth_controller.dart';
import '../../utils/app_theme.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/social_login_button.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Use Get.put with permanent flag to prevent disposal during navigation
    final authController = Get.put(AuthController(), permanent: true);
    
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
                'Sign up',
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
                        Get.snackbar('Info', 'Google signup not implemented in MVP');
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: SocialLoginButton(
                      icon: Icons.facebook,
                      onPressed: () {
                        // Facebook login functionality
                        Get.snackbar('Info', 'Facebook signup not implemented in MVP');
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: SocialLoginButton(
                      icon: Icons.apple,
                      onPressed: () {
                        // Apple login functionality
                        Get.snackbar('Info', 'Apple signup not implemented in MVP');
                      },
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 32),
              
              // Signup form
              Form(
                key: authController.signupFormKey,
                child: Column(
                  children: [
                    // Name field
                    CustomTextField(
                      controller: authController.nameController,
                      hintText: 'Name',
                      keyboardType: TextInputType.name,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your name';
                        }
                        if (value.length < 2) {
                          return 'Name must be at least 2 characters';
                        }
                        return null;
                      },
                    ),
                    
                    const SizedBox(height: 16),
                    
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
                        if (value.length < 6) {
                          return 'Password must be at least 6 characters';
                        }
                        return null;
                      },
                    )),
                    
                    const SizedBox(height: 16),
                    
                    // Confirm Password field
                    Obx(() => CustomTextField(
                      controller: authController.confirmPasswordController,
                      hintText: 'Confirm Password',
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
                          return 'Please confirm your password';
                        }
                        if (value != authController.passwordController.text) {
                          return 'Passwords do not match';
                        }
                        return null;
                      },
                    )),
                    
                    const SizedBox(height: 24),
                    
                    // Signup button
                    SizedBox(
                      width: double.infinity,
                      child: Obx(() => ElevatedButton(
                        onPressed: authController.isLoading.value 
                            ? null 
                            : authController.signup,
                        child: authController.isLoading.value
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.white),
                                ),
                              )
                            : const Text('Sign up'),
                      )),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Login link
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Already have an account? ',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.grey,
                    ),
                  ),
                  GestureDetector(
                    onTap: authController.navigateToLogin,
                    child: Text(
                      'Sign in',
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
