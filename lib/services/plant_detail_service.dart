import 'package:get/get.dart';
import 'package:planet/models/plant_detail_model.dart';

class PlantDetailService {
  PlantDetailModel selectedDetail(int uid, String nickName, String? imgUrl) {
    return PlantDetailModel(uid: uid, nickName: nickName, imgUrl: imgUrl);
  }

  Future<List<PlantDetailModel>?> fetchDetail() async {
    // await

    return [
      PlantDetailModel(
          uid: 12,
          nickName: 'asd',
          imgUrl: null,
          scientificName: "asdads",
          period: 123,
          heart: 123)
    ];
  }
}
