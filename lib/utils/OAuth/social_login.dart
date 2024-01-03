import 'dart:convert';

import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:http/http.dart' as http;
import 'package:planet/components/common/custom_alert_dialog.dart';
import 'package:planet/models/api/user/login_response.dart';
import 'package:planet/screen/root.dart';
import 'package:planet/utils/OAuth/token_storage.dart';
import 'package:planet/utils/develop_domain.dart';
import 'package:kakao_flutter_sdk_user/src/model/user.dart' as KakaoUser;
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class SocialLogin {
  final apiClient = APIClient();

  String platform = "";

  SocialLogin(this.platform);

  Future<dynamic> run() async {
    switch (platform) {
      case "google":
        return signInWithGoogle();
      case "kakao":
        return _loginWithKakao();
      case "apple":
        return _loginWithApple();
      default:
        throw Exception('Unsupported platform');
    }
  }

  void signInWithGoogle() async {
    // Google 로그인 플로우 생성
    final GoogleSignIn googleSignIn = GoogleSignIn();
    try {
      // Google 계정 선택
      final GoogleSignInAccount? googleSignInAccount =
          await googleSignIn.signIn();
      if (googleSignInAccount != null) {
        // Google 계정 정보 반환
        String? name = googleSignInAccount.displayName;
        String email = googleSignInAccount.email;

        bool success = await apiClient.sendLoginData(email, name ?? "Planet");
        if (success) {
          Get.offAll(() => const RootScreen());
        } else {
          Get.dialog(CustomAlertDialog(alertContent: "서버 에러"));
        }
      }
    } catch (e) {
      Get.dialog(CustomAlertDialog(alertContent: e.toString()));
    }
  }

  void _loginWithKakao() async {
    try {
      var result = await UserApi.instance.loginWithKakaoAccount();
      KakaoUser.User userData = await UserApi.instance.me();
      String? name = userData.kakaoAccount?.profile?.nickname;
      String? email = userData.kakaoAccount?.email;

      bool success =
          await apiClient.sendLoginData(email ?? "", name ?? "Planet");
      if (success) {
        Get.offAll(() => const RootScreen());
      } else {
        Get.dialog(CustomAlertDialog(alertContent: "서버 에러"));
      }
      // 로그인 성공 시 처리
    } catch (e) {
      // 로그인 실패 시 처리
      Get.dialog(CustomAlertDialog(alertContent: "다시 시도해주세요"));
    }
  }

  void _loginWithApple() async {
    try {
      final credential = await SignInWithApple.getAppleIDCredential(scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ]);

      List<String> jwt = credential.identityToken?.split('.') ?? [];
      String payload = jwt[1];
      payload = base64.normalize(payload);

      final List<int> jsonData = base64.decode(payload);
      final userInfo = jsonDecode(utf8.decode(jsonData));
      String email = userInfo['email'];
      String givenName = credential.givenName ?? "";
      String familyName = credential.familyName ?? "";
      String name = givenName + familyName;

      bool success =
          await apiClient.sendLoginData(email ?? "", name ?? "Planet");
      if (success) {
        Get.offAll(() => const RootScreen());
      } else {
        Get.dialog(CustomAlertDialog(alertContent: "서버 에러"));
      }

      // 로그인 성공 시 처리
    } catch (e) {
      // 로그인 실패 시 처리
      Get.dialog(CustomAlertDialog(alertContent: "다시 시도해주세요"));
    }
  }
}

class APIClient {
  Future<bool> sendLoginData(String email, String name) async {
    String domain = DevelopDomain().run();
    final tokenStorage = TokenStorage();

    final response = await http.post(
      Uri.parse('$domain/users/login'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({'email': email, 'name': name}),
    );

    if (response.statusCode == 200) {
      final result = LoginResponse.fromJson(jsonDecode(response.body));
      await tokenStorage.saveToken(result.accessToken, result.refreshToken);

      return true;
    } else {
      return false;
    }
  }
}
