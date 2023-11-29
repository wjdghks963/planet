import 'package:get/get.dart';
import 'package:planet/models/selected_plant_detail_model.dart';

class SelectedPlantDetailController extends GetxController {
  final Rx<SelectedPlantDetailModel> _selectedPlant =
      SelectedPlantDetailModel().obs;

  SelectedPlantDetailModel get selectedPlant => _selectedPlant.value;

  void selectDetail(
      {required int plantId,
      required String nickName,
      String? scientificName,
      String? imgUrl,
      int? heartCount,
      bool? hearted,
      String? createdAt}) {
    SelectedPlantDetailModel model = SelectedPlantDetailModel(
        plantId: plantId,
        nickName: nickName,
        imgUrl: imgUrl,
        scientificName: scientificName,
        heartCount: heartCount,
        hearted: hearted,
        createdAt: createdAt);

    _selectedPlant(model);
  }
}
