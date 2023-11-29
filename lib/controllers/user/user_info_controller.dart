import 'package:get/get.dart';
import 'package:planet/components/common/custom_alert_dialog.dart';
import 'package:planet/models/api/user/user_info_model.dart';
import 'package:planet/services/user_api_service.dart';

class UserInfoController extends GetxController {
  late final UserApiClient userApiClient;

  var userInfoDetail = Rxn<UserInfoModel>();
  var isLoading = false.obs;

  UserInfoController(this.userApiClient);

  @override
  void onInit() {
    getUserDetail();
    super.onInit();
  }

  Future<void> getUserDetail() async {
    isLoading(true);
    try {
      final userDetailModel = await userApiClient.getUserInfo();
      userInfoDetail(userDetailModel);
    } catch (e) {
      print("USER INFO ERROR"+e.toString());
      await Get.dialog(CustomAlertDialog(alertContent: e.toString()));
    } finally {
      isLoading(false);
    }
  }
}
