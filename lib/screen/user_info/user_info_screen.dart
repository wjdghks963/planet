import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:planet/components/common/custom_alert_dialog.dart';
import 'package:planet/components/common/custom_select_dialog.dart';
import 'package:planet/components/common/custom_text_button.dart';
import 'package:planet/controllers/plant/plant_controller.dart';
import 'package:planet/controllers/user/user_info_controller.dart';
import 'package:planet/main.dart';
import 'package:planet/components/user/user_profile.dart';
import 'package:planet/components/user/user_total_info.dart';
import 'package:planet/screen/ai/ai_chat_screen.dart';
import 'package:planet/services/user_api_service.dart';
import 'package:planet/theme.dart';
import 'package:planet/utils/OAuth/token_storage.dart';
import 'package:http/http.dart' as http;
import 'package:planet/utils/develop_domain.dart';

class UserInfoScreen extends StatelessWidget {
  const UserInfoScreen({super.key});

  void logout() async {
    await TokenStorage().removeToken();
    Get.delete<PlantController>();
    Get.delete<UserInfoController>();
    Get.offAll(() => const LoginScreen());
  }

  void removeUser() async {
    var result = await Get.dialog(const CustomSelectDialog(
      title: '회원 탈퇴',
      content: '회원 탈퇴시 모든 데이터가 삭제되고 복구할 수 없습니다.',
    ));
    if (result == true) {
      UserApiClient userApiClient = UserApiClient();
      try {
        await userApiClient.removeUser();

        await TokenStorage().removeToken();

        Get.offAll(() => const LoginScreen());
      } catch (e) {
        Get.dialog(CustomAlertDialog(alertContent: e.toString()));
      }
    }
  }

  void requestGradeUp() async {
    final UserInfoController userInfoController =
        Get.find<UserInfoController>();

    var result = await Get.dialog(const CustomSelectDialog(
        title: "등급 업그레이드",
        content:
            "등급 업그레이드를 신청해 주셔서 감사합니다!\n\n처리 과정에 최대 7일이 소요될 수 있습니다.\n\n이 기간 동안 계속 앱을 즐겨주시기 바랍니다.\n\n업그레이드가 완료되면 더 많은 식물을 관리하실 수 있습니다."));

    if (result == true) {
      if (userInfoController.userInfoDetail.value?.aiServiceAccess == true) {
        Get.dialog(CustomAlertDialog(alertContent: "이미 프리미엄 유저입니다"));
      } else {
        TokenStorage tokenStorage = TokenStorage();
        String? token = await tokenStorage.getToken(TokenType.acc);

        String domain = DevelopDomain().run();
        final url = Uri.parse('$domain/users/request/grade-up');

        final headers = {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        };

        await http.post(url, headers: headers);
      }
    }
  }

  void goToAiChat() async {
    UserInfoController userInfoController = Get.find<UserInfoController>();
    if (userInfoController.userInfoDetail.value?.aiServiceAccess == true) {
      Get.to(() => const AIChatScreen(aiChatType: AiChatType.question));
    } else {
      await Get.dialog(CustomAlertDialog(
        alertContent: '프리미엄 유저 이용 가능\n네이버 카페나 등급 올리기 버튼을 이용해 주세요.',
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final UserInfoController userInfoController =
        Get.find<UserInfoController>();

    return Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/bg_image.png'),
            fit: BoxFit.fill,
          ),
        ),
        padding: const EdgeInsets.all(20.0),
        width: double.infinity,
        child: Obx(() {
          if (userInfoController.isLoading.value) {
            return Center(
                child: Lottie.asset('assets/lotties/loading_lottie.json'));
          } else {
            return ListView(
              children: [
                UserProfile(
                  name:
                      userInfoController.userInfoDetail.value?.name ?? "Planet",
                ),
                const SizedBox(
                  height: 40.0,
                ),
                // InkWell(
                //   onTap: goToAiChat,
                //   child: Container(
                //     decoration: const BoxDecoration(
                //         color: Colors.white,
                //         borderRadius: BorderRadius.all(Radius.circular(5.0))),
                //     padding: const EdgeInsets.symmetric(
                //         horizontal: 5.0, vertical: 5.0),
                //     child: Row(
                //       mainAxisAlignment: MainAxisAlignment.center,
                //       children: [
                //         Image.asset(
                //           'assets/images/ai_image_chat.png',
                //           width: 70,
                //           height: 70,
                //         ),
                //         const Text(
                //           "AI에게 식물 물어보기",
                //           style: TextStyles.normalStyle,
                //         ),
                //       ],
                //     ),
                //   ),
                // ),
                // const SizedBox(
                //   height: 40.0,
                // ),
                const UserTotalInfo(),
                const SizedBox(
                  height: 80.0,
                ),

                InkWell(
                  onTap: requestGradeUp,
                  child: Container(
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(5.0))),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 5.0, vertical: 5.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/gradeup.png',
                          width: 60,
                          height: 60,
                        ),
                        const SizedBox(
                          width: 20.0,
                        ),
                        const Text(
                          "등급 올리기",
                          style: TextStyles.normalStyle,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 80.0,
                ),
                Column(
                  children: [
                    CustomTextButton(
                        content: "로그아웃",
                        backgroundColor: ColorStyles.mainAccent,
                        onPressed: () => logout()),
                    const SizedBox(
                      height: 30.0,
                    ),
                    CustomTextButton(
                        content: "탈퇴",
                        backgroundColor: ColorStyles.darkGray,
                        onPressed: () => removeUser())
                  ],
                )
              ],
            );
          }
        }));
  }
}
