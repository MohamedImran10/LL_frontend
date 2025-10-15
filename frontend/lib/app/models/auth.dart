class AuthRequest {
  final String email;
  final String password;
  final String? name;
  final String? confirmPassword;

  AuthRequest({
    required this.email,
    required this.password,
    this.name,
    this.confirmPassword,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'email': email,
      'password': password,
    };
    
    if (name != null) {
      data['name'] = name;
    }
    
    if (confirmPassword != null) {
      data['confirm_password'] = confirmPassword;
    }
    
    return data;
  }
}

class AuthResponse {
  final bool success;
  final String? token;
  final String? message;
  final Map<String, dynamic>? user;

  AuthResponse({
    required this.success,
    this.token,
    this.message,
    this.user,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      success: json['success'] ?? false,
      token: json['token'],
      message: json['message'],
      user: json['user'],
    );
  }
}
