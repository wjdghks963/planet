import 'package:planet/models/plant_detail_model.dart';

class PlantDetailService {


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
