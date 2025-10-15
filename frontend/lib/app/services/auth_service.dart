import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/auth.dart';
import '../config/api_config.dart';

class AuthService {
  static String get baseUrl => ApiConfig.baseUrl; // Dynamic backend URL
  
  // Create HTTP client with timeout configuration
  static http.Client _createHttpClient() {
    final client = http.Client();
    return client;
  }
  
  // Helper method to check if we should use demo mode
  bool _shouldUseDemoMode(dynamic error) {
    final errorStr = error.toString().toLowerCase();
    return errorStr.contains('timeout') || 
           errorStr.contains('connection') || 
           errorStr.contains('socket') ||
           errorStr.contains('network');
  }
  
  Future<AuthResponse> login(AuthRequest request) async {
    final client = _createHttpClient();
    try {
      print('AuthService: Attempting backend login for ${request.email}');
      
      final response = await client.post(
        Uri.parse('$baseUrl/auth/login/'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'email': request.email,
          'password': request.password,
        }),
      ).timeout(
        ApiConfig.connectTimeout,
        onTimeout: () {
          throw Exception('Connection timeout');
        },
      );

      final Map<String, dynamic> responseData = jsonDecode(response.body);
      print('AuthService: Login backend response: ${response.statusCode}');
      
      if (response.statusCode == 200 && responseData['success'] == true) {
        print('AuthService: Backend login successful');
        return AuthResponse(
          success: true,
          token: responseData['token'],
          message: responseData['message'] ?? 'Login successful!',
          user: responseData['user'],
        );
      } else {
        return AuthResponse(
          success: false,
          message: responseData['message'] ?? 'Login failed',
        );
      }
    } catch (e) {
      print('AuthService: Login network error: $e');
      
      // Check if we should use demo mode based on error type
      if (_shouldUseDemoMode(e)) {
        print('AuthService: Login falling back to demo mode');
        
        return AuthResponse(
          success: true,
          token: 'demo_login_token_${DateTime.now().millisecondsSinceEpoch}',
          message: 'Login successful! (Demo Mode - Backend Offline)',
          user: {
            'id': request.email.hashCode.toString(),
            'name': request.email.split('@')[0],
            'email': request.email,
          },
        );
      } else {
        // For other errors, return failure
        return AuthResponse(
          success: false,
          message: 'Login failed: ${e.toString()}',
        );
      }
    } finally {
      client.close();
    }
  }

  Future<AuthResponse> signup(AuthRequest request) async {
    final client = _createHttpClient();
    try {
      print('AuthService: Attempting backend signup for ${request.email}');
      print('AuthService: Request data - Name: ${request.name}, Email: ${request.email}');
      
      final response = await client.post(
        Uri.parse('$baseUrl/auth/signup/'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'email': request.email,
          'password': request.password,
          'confirm_password': request.confirmPassword,
          'name': request.name,
        }),
      ).timeout(
        ApiConfig.connectTimeout,
        onTimeout: () {
          throw Exception('Connection timeout');
        },
      );

      print('AuthService: Signup backend response: ${response.statusCode}');
      print('AuthService: Response body: ${response.body}');
      
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      
      if (response.statusCode == 201 && responseData['success'] == true) {
        print('AuthService: Backend signup successful');
        return AuthResponse(
          success: true,
          token: responseData['token'],
          message: responseData['message'] ?? 'Account created successfully!',
          user: responseData['user'],
        );
      } else if (response.statusCode == 409 && responseData['existing_user'] == true) {
        // User already exists, suggest login instead
        print('AuthService: User already exists, suggesting login');
        return AuthResponse(
          success: false,
          message: 'Account already exists. Please login instead.',
        );
      } else {
        print('AuthService: Backend signup failed with errors: ${responseData['errors'] ?? responseData['message']}');
        return AuthResponse(
          success: false,
          message: responseData['message'] ?? 'Signup failed',
        );
      }
    } catch (e) {
      print('AuthService: Signup network error: $e');
      
      // Check if we should use demo mode based on error type
      if (_shouldUseDemoMode(e)) {
        print('AuthService: Signup falling back to demo mode');
        
        return AuthResponse(
          success: true,
          token: 'demo_signup_token_${DateTime.now().millisecondsSinceEpoch}',
          message: 'Account created successfully! (Demo Mode - Backend Offline)',
          user: {
            'id': request.email.hashCode.toString(),
            'name': request.name ?? request.email.split('@')[0],
            'email': request.email,
          },
        );
      } else {
        // For other errors, return failure
        return AuthResponse(
          success: false,
          message: 'Signup failed: ${e.toString()}',
        );
      }
    } finally {
      client.close();
    }
  }

  Future<bool> validateToken(String token) async {
    final client = _createHttpClient();
    try {
      final response = await client.get(
        Uri.parse('$baseUrl/auth/validate/'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      ).timeout(
        ApiConfig.connectTimeout,
        onTimeout: () {
          throw Exception('Connection timeout');
        },
      );

      return response.statusCode == 200;
    } catch (e) {
      // For MVP, always return true for demo token
      return token.startsWith('demo_') || token.startsWith('login_') || token.startsWith('signup_');
    } finally {
      client.close();
    }
  }
}
