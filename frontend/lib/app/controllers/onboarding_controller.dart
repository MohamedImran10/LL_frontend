import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../services/storage_service.dart';
import '../utils/app_routes.dart';

class OnboardingController extends GetxController {
  final PageController pageController = PageController();
  final RxInt currentIndex = 0.obs;

  final List<OnboardingItem> onboardingItems = [
    OnboardingItem(
      title: "Your Journey,\nSimplified",
      description: "Let our AI Agent find the best flights for you—faster, cheaper, and stress-free. Just tell it where and when to go.",
      icon: Icons.flight_takeoff,
    ),
    OnboardingItem(
      title: "Chat. Search. Fly.",
      description: "Simply chat with your AI Agent to book flights, modify dates, or check flight details—no forms, no hassle.",
      icon: Icons.chat_bubble_outline,
    ),
    OnboardingItem(
      title: "Flexible Payments,\nZero Effort",
      description: "Pay the traditional way or go digital—choose UPI, cards, or wallets. Your transactions are fast and secure.",
      icon: Icons.payment,
    ),
  ];

  void nextPage() {
    if (currentIndex.value < onboardingItems.length - 1) {
      currentIndex.value++;
      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void previousPage() {
    if (currentIndex.value > 0) {
      currentIndex.value--;
      pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void skipToEnd() {
    currentIndex.value = onboardingItems.length - 1;
    pageController.animateToPage(
      onboardingItems.length - 1,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  Future<void> completeOnboarding() async {
    print('OnboardingController: Completing onboarding'); // Debug log
    await StorageService.to.setFirstTime(false);
    print('OnboardingController: First time set to false'); // Debug log
    Get.offAllNamed(AppRoutes.login);
  }

  void onPageChanged(int index) {
    currentIndex.value = index;
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}

class OnboardingItem {
  final String title;
  final String description;
  final IconData icon;

  OnboardingItem({
    required this.title,
    required this.description,
    required this.icon,
  });
}
