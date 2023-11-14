import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:planet/models/api/user/login_response.dart';
import 'package:planet/screen/root.dart';
import 'package:planet/utils/OAuth/token_storage.dart';
import 'package:planet/utils/develop_domain.dart';

final tokenStorage = TokenStorage();

class SocialLogin {
  String platform = "";

  SocialLogin(this.platform);

  Future<GoogleSignInAccount?> run() async {
    switch (platform) {
      case "google":
        return signInWithGoogle();
      default:
        throw Exception('Unsupported platform');
    }
  }
}

Future<GoogleSignInAccount?> signInWithGoogle() async {
  // Google 로그인 플로우 생성
  final GoogleSignIn googleSignIn = GoogleSignIn();

  // Google 계정 선택
  final GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();

  if (googleSignInAccount != null) {
    // Google 계정 정보 반환
    String? name = googleSignInAccount.displayName;
    String email = googleSignInAccount.email;

    final apiClient = APIClient();
    final response = await apiClient.sendLoginData(email, name ?? "");
print("$name, $email");
print(response.toString());
    if (response.statusCode == 200) {
      // 성공 로직
      final loginResponse = LoginResponse.fromJson(response.body);
      await tokenStorage.saveToken(
          loginResponse.accessToken, loginResponse.refreshToken);

      return Get.to(() => const RootScreen());
    }else{
      print("asdasdadsadsads");

    }

    return googleSignInAccount;
  } else {
    return null;
  }
}

class APIClient extends GetConnect {
  Future<Response> sendLoginData(String email, String name) async {
    String domain = DevelopDomain().run();


    final response = await post(
      '$domain/users/login',
      {'email': email, 'name': name},
    );
    return response;
  }
}
