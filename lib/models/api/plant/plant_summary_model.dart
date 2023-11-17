class PlantSummaryModel {
  final int plantId;
  final String nickName;
  final String imgUrl;
  final int period;
  final int heartCount;

  PlantSummaryModel({required this.plantId,required this.nickName, required this.imgUrl, required this.period, required this.heartCount});

  factory PlantSummaryModel.fromJson(Map<String, dynamic> json) {
    return PlantSummaryModel(
      plantId: json['id'] as int,
      nickName: json['nickName'] as String,
      imgUrl: json['imgUrl'] as String,
      period: json['period'] as int,
      heartCount: json['heartCount'] as int,
    );
  }
}

