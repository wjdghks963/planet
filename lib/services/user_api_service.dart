import 'package:get/get.dart';
import 'package:planet/models/api/user/user_info_model.dart';
import 'package:planet/services/api_manager.dart';
import 'package:planet/utils/OAuth/token_storage.dart';
import 'package:planet/utils/develop_domain.dart';

class UserApiClient extends GetConnect {
  String domain = DevelopDomain().run();
  TokenStorage tokenStorage = TokenStorage();
  final ApiManager apiManager = ApiManager();

  Future<Map<String, String>> _getAuthHeader() async {
    String? token = await tokenStorage.getToken(TokenType.acc);
    return {'Authorization': 'Bearer $token'};
  }

  Future<UserInfoModel> getUserInfo() async {
    final response = await apiManager.performApiCall(() async => get(
          "$domain/users/my-info",
          headers: await _getAuthHeader(),
        ));

    return UserInfoModel.fromJson(response.body);
  }

  Future<Response> removeUser() async {
    final response = await apiManager.performApiCall(() async => delete(
          "$domain/users/remove",
          headers: await _getAuthHeader(),
        ));

    return response;
  }

  Future<Response> reportPlant(int plantId) async {
    final response = await apiManager.performApiCall(() async => post(
        "$domain/report/plant/$plantId", {},
        headers: await _getAuthHeader()));
    return response;
  }

  Future<Response> reportDiary(int diaryId) async {
    final response = await apiManager.performApiCall(() async => post(
        "$domain/report/diary/$diaryId", {},
        headers: await _getAuthHeader()));
    return response;
  }
}
