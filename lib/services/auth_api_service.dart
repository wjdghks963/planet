import 'package:get/get.dart';
import 'package:get/get_connect/connect.dart';
import 'package:planet/main.dart';
import 'package:planet/utils/OAuth/token_storage.dart';
import 'package:planet/utils/develop_domain.dart';

class AuthApiService extends GetConnect {
  final storage = TokenStorage();
  String domain = DevelopDomain().run();

  Future<bool> refreshToken() async {
    try {
      String? accessToken = await storage.getToken(TokenType.acc);
      String? refreshToken = await storage.getToken(TokenType.refresh);

      if (refreshToken == null) {
        return false;
      }
      String authorizationHeader = 'Bearer $accessToken';
      final response = await get(
        '$domain/refresh',
        headers: {'Authorization': authorizationHeader},
        query: {'refreshToken': refreshToken},
      );

      if (response.statusCode == 200) {
        await storage.saveToken(
            response.body['access_token'], response.body['refresh_token']);

        return true;
      }
      if (response.statusCode == 403) {
        Get.offAll(() => const HomeScreen());
      }
      return false;
    } catch (e) {
      print("Error refreshing token: $e");
      return false;
    }
  }
}
