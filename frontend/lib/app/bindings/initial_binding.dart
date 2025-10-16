import 'package:get/get.dart';
import '../controllers/onboarding_controller.dart';
import '../controllers/auth_controller.dart';
import '../controllers/flight_search_controller.dart';
import '../services/flight_agent_service.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    // Initialize services first
    Get.lazyPut<FlightAgentService>(() => FlightAgentService());
    
    // Initialize controllers as needed
    Get.lazyPut<OnboardingController>(() => OnboardingController());
    Get.lazyPut<AuthController>(() => AuthController());
    Get.lazyPut<FlightSearchController>(() => FlightSearchController());
  }
}
