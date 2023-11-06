import 'package:get/get.dart';
import 'package:planet/controllers/plant_detail_controller.dart';

class PlantDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => PlantDetailViewModel());
  }
}
