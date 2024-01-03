import 'package:get/get.dart';
import 'package:planet/utils/OAuth/token_storage.dart';
import 'package:planet/utils/develop_domain.dart';

class AuthApiService extends GetConnect {
  final storage = TokenStorage();
  String domain = DevelopDomain().run();

  Future<bool> refreshToken() async {
    try {
      String? refreshToken = await storage.getToken(TokenType.refresh);

      if (refreshToken == null) {
        return false;
      }
      final response = await post(
        '$domain/users/refresh',
        {},
        query: {'refreshToken': refreshToken},
      );

      if (response.statusCode == 200) {
        await storage.saveToken(
            response.body['access_token'], response.body['refresh_token']);
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }
}
