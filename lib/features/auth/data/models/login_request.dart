class LoginRequest {
  final String employeeCode;
  final String password;
  
  LoginRequest({
    required this.employeeCode,
    required this.password,
  });
  
  Map<String, dynamic> toJson() {
    return {
      'employee_code': employeeCode,
      'password': password,
    };
  }
}