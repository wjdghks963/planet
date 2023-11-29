import 'package:get/get.dart';
import 'package:planet/components/common/custom_alert_dialog.dart';
import 'package:planet/controllers/plant/selected_plant_detail_controller.dart';
import 'package:planet/models/api/plant/plant_detail_model.dart';
import 'package:planet/services/plant_api_service.dart';

class PlantDetailController extends GetxController {
  var plantDetail = Rxn<PlantDetailModel>();
  var isLoading = false.obs;

  // CRUD
  Future<void> getPlantDetail() async {
    final PlantsApiClient plantsApiClient = PlantsApiClient();
    isLoading(true);
    try {
      SelectedPlantDetailController selectedPlantDetailController =
          Get.find<SelectedPlantDetailController>();

      final plantDetailModel = await plantsApiClient.getPlantDetail(
          selectedPlantDetailController.selectedPlant.plantId ?? 1);
      plantDetail(plantDetailModel);
    } catch (e) {
      await Get.dialog(CustomAlertDialog(alertContent: e.toString()));
      Get.back();
    } finally {
      isLoading(false);
    }
  }
}
