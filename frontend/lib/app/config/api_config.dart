class ApiConfig {
  // Configuration for different environments
  static const bool useLocalhost = false; // Set to false for physical device
  
  // Your development machine's IP address
  // Found automatically: 10.157.168.34
  static const String localIpAddress = '10.157.168.34'; // Your actual IP address
  
  // Network timeout configurations
  static const Duration connectTimeout = Duration(seconds: 5);
  static const Duration receiveTimeout = Duration(seconds: 10);
  
  static String get baseUrl {
    if (useLocalhost) {
      return 'http://localhost:8000/api'; // For Android emulator
    } else {
      return 'http://$localIpAddress:8000/api'; // For physical device
    }
  }
  
  // Quick method to get the correct URL based on device type
  static String getBaseUrlForDevice({bool isPhysicalDevice = true}) {
    if (isPhysicalDevice) {
      return 'http://$localIpAddress:8000/api';
    } else {
      return 'http://localhost:8000/api';
    }
  }
  
  // Health check endpoint
  static String get healthCheckUrl {
    if (useLocalhost) {
      return 'http://localhost:8000/api/auth/health/';
    } else {
      return 'http://$localIpAddress:8000/api/auth/health/';
    }
  }
}
