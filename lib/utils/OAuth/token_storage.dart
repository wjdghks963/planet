import 'package:flutter_secure_storage/flutter_secure_storage.dart';

enum TokenType { acc, refresh }


class TokenStorage {
  final FlutterSecureStorage storage = const FlutterSecureStorage();

  Future<void> saveToken(String accessToken, String refreshToken) async {
    await storage.write(key: 'access_token', value: accessToken);
    await storage.write(key: 'refresh_token', value: refreshToken);
  }

  Future<bool> hasToken(TokenType tokenType ) async {
    switch (tokenType) {
      case TokenType.acc:
        return await storage.read(key: 'access_token') != null;
      case TokenType.refresh:
        return await storage.read(key: 'refresh_token') != null;
      default:
        return false;
    }

  }

  Future<String?> getToken(TokenType tokenType) async{
    switch (tokenType) {
      case TokenType.acc:
        return await storage.read(key: 'access_token');
      case TokenType.refresh:
        return await storage.read(key: 'refresh_token');
      default:
        return null;
    }
  }

  Future<void> removeToken() async {
    await storage.delete(key: 'access_token');
    await storage.delete(key: 'refresh_token');
  }
}
