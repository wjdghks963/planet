import 'package:get/get.dart';
import 'package:planet/controllers/selected_plant_detail_controller.dart';

class CustomBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(SelectedPlantDetailController(), permanent: true);
    //Get.lazyPut(()=>SelectedPlantDetailController());
  }
}
