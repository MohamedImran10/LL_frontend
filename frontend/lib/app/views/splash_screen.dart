import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/storage_service.dart';
import '../utils/app_routes.dart';
import '../utils/app_theme.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToNextScreen();
  }

  Future<void> _navigateToNextScreen() async {
    await Future.delayed(const Duration(seconds: 2));
    
    try {
      // Debug current storage state
      StorageService.to.debugStorage();
      
      // Check if we should force onboarding (for debugging)
      // Uncomment next line to force onboarding every time during development
      await StorageService.to.clearAll(); // ENABLE THIS TO FORCE ONBOARDING
      
      // Always check first time status first
      final isFirstTime = StorageService.to.isFirstTime;
      print('SplashScreen: isFirstTime = $isFirstTime'); // Debug log
      
      if (isFirstTime) {
        print('SplashScreen: Navigating to onboarding'); // Debug log
        Get.offAllNamed(AppRoutes.onboarding);
        return;
      }
      
      // Only check login status if not first time
      final isLoggedIn = await StorageService.to.isLoggedIn;
      print('SplashScreen: isLoggedIn = $isLoggedIn'); // Debug log
      
      if (isLoggedIn) {
        print('SplashScreen: Navigating to dashboard'); // Debug log
        Get.offAllNamed(AppRoutes.dashboard);
      } else {
        print('SplashScreen: Navigating to login'); // Debug log
        Get.offAllNamed(AppRoutes.login);
      }
    } catch (e) {
      print('SplashScreen: Error occurred: $e'); // Debug log
      // If there's an error, default to onboarding
      Get.offAllNamed(AppRoutes.onboarding);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Stack(
        children: [
          // Main splash content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // App Icon/Logo
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: const Icon(
                    Icons.flight,
                    size: 60,
                    color: AppColors.white,
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // App Title
                Text(
                  'LetzLevitate',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: AppColors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                
                const SizedBox(height: 8),
                
                // Subtitle
                Text(
                  'Your Journey, Simplified',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.grey,
                  ),
                ),
                
                const SizedBox(height: 48),
                
                // Loading indicator
                const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                ),
              ],
            ),
          ),
          
          // Debug button in bottom corner for development
          Positioned(
            bottom: 50,
            right: 20,
            child: FloatingActionButton.small(
              backgroundColor: AppColors.primary.withOpacity(0.1),
              onPressed: () async {
                await StorageService.to.clearAll();
                Get.snackbar('Debug', 'Storage cleared! Restart app for onboarding.');
              },
              child: const Icon(Icons.refresh, size: 20),
            ),
          ),
        ],
      ),
    );
  }
}
