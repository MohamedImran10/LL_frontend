import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb, defaultTargetPlatform, TargetPlatform;
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'app/utils/app_theme.dart';
import 'app/utils/app_routes.dart';
import 'app/services/storage_service.dart';
import 'app/bindings/initial_binding.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase with options (skip on Linux desktop for now)
  if (!kIsWeb && defaultTargetPlatform != TargetPlatform.linux) {
    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      debugPrint('✅ Firebase initialized successfully');
    } catch (e) {
      debugPrint('⚠️ Firebase initialization failed: $e');
      debugPrint('⚠️ Google Sign-In will not work until Firebase is configured');
    }
  } else {
    debugPrint('ℹ️ Running on ${kIsWeb ? 'Web' : 'Linux Desktop'}');
    debugPrint('ℹ️ Firebase/Google Sign-In disabled for this platform');
    debugPrint('ℹ️ For full features, run on Android device or emulator');
  }
  
  // Initialize services
  await Get.putAsync(() => StorageService().init());
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'LetzLevitate',
      theme: AppTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.splash,
      getPages: AppRoutes.routes,
      initialBinding: InitialBinding(),
    );
  }
}
