import 'package:planet/models/api/diary/diary_detail_model.dart';

class PlantDetailModel {
  final int plantId;
  final String nickName;
  final String scientificName;
  final String imgUrl;
  final int period;
  final int heartCount;
  final List<DiaryDetailModel> diaries;
  final bool mine;
  final bool hearted;

  PlantDetailModel(
      {required this.plantId,
      required this.nickName,
      required this.scientificName,
      required this.imgUrl,
      required this.period,
      required this.heartCount,
      required this.diaries,
      required this.mine,
      required this.hearted});

  factory PlantDetailModel.fromJson(Map<String, dynamic> json) {
    return PlantDetailModel(
        plantId: json['plantId'],
        nickName: json['nickName'],
        scientificName: json['scientificName'],
        imgUrl: json['imgUrl'],
        period: json['period'],
        heartCount: json['heartCount'],
        diaries: List<DiaryDetailModel>.from(
            json['diaries'].map((x) => DiaryDetailModel.fromJson(x))),
        mine: json['mine'],
        hearted: json['hearted']);
  }
}
