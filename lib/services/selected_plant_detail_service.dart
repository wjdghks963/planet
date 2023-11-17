import 'package:planet/models/selected_plant_detail_model.dart';

class SelectedPlantDetailService {
  SelectedPlantDetailModel selectedDetail(
      {required int plantId,
      required String nickName,
      String? imgUrl,
      String? scientificName,
      int? heartCount,
      bool? hearted}) {
    return SelectedPlantDetailModel(
        plantId: plantId,
        nickName: nickName,
        imgUrl: imgUrl,
        scientificName: scientificName,
        heartCount: heartCount,
        hearted: hearted);
  }
}
