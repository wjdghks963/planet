import 'package:get/get.dart';
import 'package:planet/components/common/custom_alert_dialog.dart';
import 'package:planet/models/api/plant/plant_form_model.dart';
import 'package:planet/models/api/plant/plant_summary_model.dart';
import 'package:planet/services/api_manager.dart';
import 'package:planet/services/plant_api_service.dart';

class PlantController extends GetxController {
  late final PlantsApiClient plantsApiClient;

  var myPlants = <PlantSummaryModel>[].obs;
  var randomPlants = <PlantSummaryModel>[].obs;
  var reachedEndOfPage = false.obs;
  var lastPageOfData = false.obs;
  var isLoading = false.obs;

  PlantController(this.plantsApiClient);

  int currentPage = 0;

  @override
  void onInit() {
    super.onInit();
    fetchMyPlants();
    fetchRandomPlants();
  }

  void fetchMyPlants() async {
    final apiManager = ApiManager();
    final plantsApiClient = PlantsApiClient();
    try {
      final response =
          await apiManager.performApiCall(() => plantsApiClient.getPlants());

      myPlants.value = (response.body as List)
          .map((e) => PlantSummaryModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      Get.dialog(CustomAlertDialog(alertContent: e.toString()));
    }
  }

  void fetchRandomPlants() async {
    final plantsApiClient = PlantsApiClient();

    try {
      final response = await plantsApiClient.getRandomPlants();

      randomPlants.value = (response.body as List)
          .map((e) => PlantSummaryModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      Get.dialog(CustomAlertDialog(alertContent: e.toString()));
    }
  }

  // CRUD
  Future<void> addNewPlant(PlantFormModel newPlant) async {
    isLoading(true);
    try {
      await plantsApiClient.addPlant(newPlant);
      fetchMyPlants();
      Get.back();
    } catch (e) {
      await Get.dialog(CustomAlertDialog(alertContent: e.toString()));
      Get.back();
    } finally {
      isLoading(false);
    }
  }

  Future<void> editPlant(PlantFormModel newPlant, int plantId) async {
    isLoading(true);

    try {
      await plantsApiClient.editPlant(newPlant, plantId);
      fetchMyPlants();
      await Get.dialog(
          CustomAlertDialog(alertContent: "사진은 바뀌기까지 몇분이 걸릴 수 있습니다."));

      Get.back();
    } catch (e) {
      await Get.dialog(CustomAlertDialog(alertContent: e.toString()));
      Get.back();
    } finally {
      isLoading(false);
    }
  }

  Future<void> removePlant(int plantId) async {
    isLoading(true);

    try {
      await plantsApiClient.removePlant(plantId);
      fetchMyPlants();
      Get.back();
    } catch (e) {
      await Get.dialog(CustomAlertDialog(alertContent: e.toString()));
      Get.back();
    } finally {
      isLoading(false);
    }
  }
}
