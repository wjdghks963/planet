import 'package:get/get_connect/connect.dart';
import 'package:planet/services/auth_api_service.dart';

class ApiManager {
  final AuthApiService authApiService = AuthApiService();

  Future<Response> performApiCall(Future<Response> Function() apiCall) async {
    try {
      var response = await apiCall();
      if (response.statusCode == 200 || response.statusCode == 201) {
        return response;
      }
      if (response.statusCode == 401) {
        // 토큰 갱신 시도
        if (await authApiService.refreshToken()) {
          // 토큰 갱신 성공 후 재시도
          response = await apiCall();
          if (response.statusCode == 200 || response.statusCode == 201) {
            return response;
          }
        }
      }
      // 오류 로그 출력
      print("API 오류: ${response.statusCode}");
      return response;
    } catch (e) {
      print("API 호출 중 예외 발생: $e");
      return const Response(
        statusCode: 500, // 또는 다른 오류 코드
        statusText: '서버 오류',
      );
    }
  }
}
