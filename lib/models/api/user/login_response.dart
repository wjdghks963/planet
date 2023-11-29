class LoginResponse {
  final String accessToken;
  final String refreshToken;

  LoginResponse({required this.accessToken, required this.refreshToken});

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      accessToken: json['access_token'],
      refreshToken: json['refresh_token'],
    );
  }
}

class User {
  final int id;
  final String email;
  final String name;
  final String createdAt;
  final String refreshToken;

  User(
      {required this.id,
      required this.email,
      required this.name,
      required this.createdAt,
      required this.refreshToken});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      email: json['email'],
      name: json['name'],
      createdAt: json['createdAt'],
      refreshToken: json['refreshToken'],
    );
  }
}
