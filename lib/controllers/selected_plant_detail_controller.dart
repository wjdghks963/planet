import 'package:get/get.dart';
import 'package:planet/models/selected_plant_detail_model.dart';
import 'package:planet/services/selected_plant_detail_service.dart';

class SelectedPlantDetailController extends GetxController {
  SelectedPlantDetailService service = Get.put(SelectedPlantDetailService());

  final Rx<SelectedPlantDetailModel> _selectedPlant =
      SelectedPlantDetailModel().obs;

  SelectedPlantDetailModel get selectedPlant => _selectedPlant.value;

  void selectDetail(
      {required int plantId,
      required String nickName,
      String? scientificName,
      String? imgUrl,
      int? heartCount,
      bool? hearted}) {
    SelectedPlantDetailModel model = service.selectedDetail(
        plantId: plantId,
        nickName: nickName,
        imgUrl: imgUrl,
        scientificName: scientificName,
        heartCount: heartCount,
        hearted: hearted);

    _selectedPlant(model);
  }
}
