class PlantDetailModel {
  final int? uid;
  final String? nickName;
  final String? imgUrl;
  final String? scientificName;
  final int? heart;
  final int? period;
  final DateTime? startDate;

  PlantDetailModel(
      {this.uid,
      this.nickName,
      this.imgUrl,
      this.scientificName,
      this.heart,
      this.period,
      this.startDate});

  factory PlantDetailModel.fromJson(Map<String, dynamic> json) =>
      PlantDetailModel(
          uid: 1,
          nickName: "asd",
          imgUrl: null,
          scientificName: "sadasddssd",
          period: 123,
          heart: 123);

  Map<String, dynamic> toJson() => {
        'uid': uid,
        'nickName': nickName,
        'imgUrl': imgUrl,
        'scientificName': scientificName,
        'period': period,
        'heart': heart
      };
}
