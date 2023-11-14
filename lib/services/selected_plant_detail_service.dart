import 'package:planet/models/selected_plant_detail_model.dart';

class SelectedPlantDetailService  {
  SelectedPlantDetailModel selectedDetail(
      {required int uid, required String nickName, String? imgUrl}) {
    return SelectedPlantDetailModel(uid: uid, nickName: nickName, imgUrl: imgUrl);
  }
}