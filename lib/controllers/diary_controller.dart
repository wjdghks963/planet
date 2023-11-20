import 'package:get/get.dart';
import 'package:planet/components/common/custom_alert_dialog.dart';
import 'package:planet/controllers/plant/plant_detail_controller.dart';
import 'package:planet/models/api/diary/diary_form_dto.dart';
import 'package:planet/services/diary_api_service.dart';

class DiaryController extends GetxController {
  late final DiaryApiClient diaryApiClient;

  var isLoading = false.obs;

  DiaryController(this.diaryApiClient);

  // CRUD
  Future<void> addDiary(DiaryFormDTO diaryFormDTO) async {
    PlantDetailController plantDetailController =
        Get.find<PlantDetailController>();

    isLoading(true);
    try {
      await diaryApiClient.postForm(diaryFormDTO);
      plantDetailController.getPlantDetail();
      Get.back();
    } catch (e) {
      Get.dialog(CustomAlertDialog(alertContent: e.toString()));
    } finally {
      isLoading(false);
    }
  }

  Future<void> editDiary(int diaryId, DiaryFormDTO diaryFormDTO) async {
    isLoading(true);
    try {
      await diaryApiClient.editForm(diaryId, diaryFormDTO);
      Get.back();
    } catch (e) {
      Get.dialog(CustomAlertDialog(alertContent: e.toString()));
    } finally {
      isLoading(false);
    }
  }

  Future<void> removeDiary(int diaryId) async {
    PlantDetailController plantDetailController =
        Get.find<PlantDetailController>();

    isLoading(true);

    try {
      await diaryApiClient.removeDiary(diaryId);
      plantDetailController.getPlantDetail();

      Get.back();
    } catch (e) {
      Get.dialog(CustomAlertDialog(alertContent: e.toString()));
    } finally {
      isLoading(false);
    }
  }
}
