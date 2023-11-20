import 'package:get/get.dart';
import 'package:planet/controllers/diary_controller.dart';
import 'package:planet/controllers/plant/pagenation_plants_controller.dart';
import 'package:planet/controllers/plant/plant_controller.dart';
import 'package:planet/controllers/plant/plant_detail_controller.dart';
import 'package:planet/controllers/plant/selected_plant_detail_controller.dart';
import 'package:planet/services/diary_api_service.dart';
import 'package:planet/services/plant_api_service.dart';

class CustomBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(SelectedPlantDetailController(), permanent: true);
    Get.lazyPut(() => PlantController(PlantsApiClient()));
    Get.lazyPut(() => PlantDetailController(PlantsApiClient()), fenix: true);
    Get.put(DiaryController(DiaryApiClient()));
    Get.lazyPut(() => RecentPlantsController());
    Get.lazyPut(() => PopularPlantsController());
  }
}
