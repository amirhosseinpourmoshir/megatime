class LoginResponse {
  final String? access;
  final String? refresh;
  
  LoginResponse({
    this.access,
    this.refresh,
  });
  
  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      access: json['access'],
      refresh: json['refresh'],
    );
  }
}