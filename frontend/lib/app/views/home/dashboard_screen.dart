import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../services/storage_service.dart';
import '../../utils/app_theme.dart';
import '../../utils/app_routes.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: const Text('Dashboard'),
        backgroundColor: AppColors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Logout'),
                  content: const Text('Are you sure you want to logout?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        Navigator.pop(context);
                        // Clear user data and navigate to login
                        await StorageService.to.clearUserData();
                        Get.offAllNamed(AppRoutes.login);
                        Get.snackbar(
                          'Success',
                          'Logged out successfully!',
                          backgroundColor: Colors.green,
                          colorText: Colors.white,
                        );
                      },
                      child: const Text('Logout'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome message
              FutureBuilder<String>(
                future: _getUserName(),
                builder: (context, snapshot) {
                  final userName = snapshot.data ?? 'User';
                  return Text(
                    'Welcome, $userName!',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: AppColors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                },
              ),
              
              const SizedBox(height: 8),
              
              Text(
                'Ready to book your next flight?',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.grey,
                ),
              ),
              
              const SizedBox(height: 32),
              
              // Quick action cards
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1.2, // Increased aspect ratio to give more height
                  children: [
                    _buildFeatureCard(
                      context,
                      'AI Flight Search',
                      'Chat with AI to find flights',
                      Icons.search,
                      () {
                        Get.toNamed(AppRoutes.flightSearch);
                      },
                    ),
                    _buildFeatureCard(
                      context,
                      'Quick Booking',
                      'Book flights in seconds',
                      Icons.flight_takeoff,
                      () {
                        Get.snackbar('Info', 'Quick booking feature coming soon!');
                      },
                    ),
                    _buildFeatureCard(
                      context,
                      'Payment Options',
                      'Flexible payment methods',
                      Icons.payment,
                      () {
                        Get.snackbar('Info', 'Payment options feature coming soon!');
                      },
                    ),
                    _buildFeatureCard(
                      context,
                      'Travel History',
                      'View your past bookings',
                      Icons.history,
                      () {
                        Get.snackbar('Info', 'Travel history feature coming soon!');
                      },
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 16), // Reduced spacing
              
              // Demo login info - made more compact
              Container(
                padding: const EdgeInsets.all(12), // Reduced padding
                decoration: BoxDecoration(
                  color: AppColors.lightGrey,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Demo Information',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith( // Smaller text
                        fontWeight: FontWeight.w600,
                        color: AppColors.black,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'For demo purposes, use:\nEmail: demo@example.com\nPassword: demo123',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.grey,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureCard(
    BuildContext context,
    String title,
    String description,
    IconData icon,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16), // Reduced padding
        decoration: BoxDecoration(
          color: AppColors.lightGrey,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40, // Reduced icon container size
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                color: AppColors.white,
                size: 20, // Reduced icon size
              ),
            ),
            
            const SizedBox(height: 12), // Reduced spacing
            
            Expanded( // Use Expanded to prevent overflow
              child: Text(
                title,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.black,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            
            const SizedBox(height: 4),
            
            Expanded( // Use Expanded to prevent overflow
              child: Text(
                description,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.grey,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<String> _getUserName() async {
    try {
      final userName = StorageService.to.userName;
      return userName.isNotEmpty ? userName : 'User';
    } catch (e) {
      return 'User';
    }
  }
}
