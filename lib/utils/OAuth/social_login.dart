import 'dart:convert';

import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:planet/components/common/custom_alert_dialog.dart';
import 'package:planet/models/api/exception/ServerException.dart';
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

  Future<GoogleSignInAccount?> signInWithGoogle() async {
    // Google 로그인 플로우 생성
    final GoogleSignIn googleSignIn = GoogleSignIn();

    // Google 계정 선택
    final GoogleSignInAccount? googleSignInAccount =
        await googleSignIn.signIn();

    if (googleSignInAccount != null) {
      // Google 계정 정보 반환
      String? name = googleSignInAccount.displayName;
      String email = googleSignInAccount.email;

      try {
        await apiClient.sendLoginData(email, name ?? "");
      } catch (e) {
        Get.dialog(CustomAlertDialog(alertContent: e.toString()));
      }

      return googleSignInAccount;
    } else {
      return null;
    }
  }

  void _loginWithKakao() async {
    try {
      await UserApi.instance.loginWithKakaoAccount();
      KakaoUser.User userData = await UserApi.instance.me();
      String? name = userData.kakaoAccount?.profile?.nickname;
      String? email = userData.kakaoAccount?.email;
      print("KAKAO :$name   $email");

      try {
        await apiClient.sendLoginData(email ?? "", name ?? "");
      } catch (e) {
        Get.dialog(CustomAlertDialog(alertContent: e.toString()));
      }
      // 로그인 성공 시 처리
    } catch (e) {
      // 로그인 실패 시 처리
      Get.dialog(CustomAlertDialog(alertContent: "다시 시도해주세요"));
    }
  }

  void _loginWithApple() async {
    try {
      await Get.dialog(CustomAlertDialog(
          alertContent: "이메일을 허용하지 않을 시\n같은 계정이어도 다른 소셜 로그인 시 다른 계정이 생성됩니다."));

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

      try {
        await apiClient.sendLoginData(email ?? "", name);
      } catch (e) {
        Get.dialog(CustomAlertDialog(alertContent: e.toString()));
      }
      // 로그인 성공 시 처리
    } catch (e) {
      // 로그인 실패 시 처리
      Get.dialog(CustomAlertDialog(alertContent: "다시 시도해주세요"));
    }
  }
}

class APIClient extends GetConnect {
  Future<Response> sendLoginData(String email, String name) async {
    String domain = DevelopDomain().run();
    final tokenStorage = TokenStorage();

    final response = await post(
      '$domain/users/login',
      {'email': email, 'name': name},
    );

    if (response.statusCode == 200) {
      final result = LoginResponse.fromJson(response.body);
      await tokenStorage.saveToken(result.accessToken, result.refreshToken);

      return await Get.to(() => const RootScreen());
    } else {
      throw ServerException.fromResponse(response.body);
    }
  }
}
