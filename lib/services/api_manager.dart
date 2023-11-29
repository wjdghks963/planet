import 'package:get/get.dart';
import 'package:planet/main.dart';
import 'package:planet/models/api/exception/ServerException.dart';
import 'package:planet/services/auth_api_service.dart';

class ApiManager {
  final AuthApiService authApiService = AuthApiService();

  Future<Response> performApiCall(Future<Response> Function() apiCall) async {
    try {
      var response = await apiCall();
      // 성공 응답 처리
      if (response.statusCode == 200 || response.statusCode == 201) {
        return response;
      }
      // 인증 실패 처리
      if (response.statusCode == 401) {
        // 토큰 갱신 후 재시도
        final isRefreshed = await authApiService.refreshToken();
        if (isRefreshed) {
          response = await apiCall();
          if (response.statusCode == 200 || response.statusCode == 201) {
            return response;
          }
        } else {
          Get.offAll(() => const LoginScreen());
        }
      }
      throw ServerException.fromResponse(response.body);
    } catch (e) {
      print("API 호출 중 예외 발생: $e");
      rethrow;
    }
  }
}
