class LoginResponse {
  final String accessToken;
  final String refreshToken;
  final User user;

  LoginResponse({required this.accessToken, required this.refreshToken, required this.user});

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      accessToken: json['access_token'],
      refreshToken: json['refresh_token'],
      user: User.fromJson(json['user']),
    );
  }
}

class User {
  final int id;
  final String email;
  final String name;
  final String createdAt;
  final String refreshToken;

  User({required this.id, required this.email, required this.name, required this.createdAt, required this.refreshToken});

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
