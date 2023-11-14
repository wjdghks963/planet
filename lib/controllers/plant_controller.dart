import 'package:get/get.dart';
import 'package:planet/models/api/plant/plant_summary.dart';
import 'package:planet/services/plant_api_service.dart';


class PlantController extends GetxController {
  var summaryPlants = <PlantSummary>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchPlants();
  }

  void fetchPlants() async {
    var plantApiClient = GetPlantsApiClient();
    var plantsData = await plantApiClient.getPlants();
    summaryPlants.value = plantsData;
  }
}
