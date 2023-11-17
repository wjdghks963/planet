class SelectedPlantDetailModel {
  final int? plantId;
  final String? nickName;
  final String? imgUrl;
  final String? scientificName;
  final int? heartCount;
  final bool? hearted;
  final String? createdAt;

  SelectedPlantDetailModel(
      {this.plantId,
      this.nickName,
      this.imgUrl,
      this.scientificName,
      this.heartCount,
      this.hearted,
      this.createdAt});

  factory SelectedPlantDetailModel.fromJson(Map<String, dynamic> json) =>
      SelectedPlantDetailModel(
          plantId: 1, nickName: "asd", imgUrl: "", scientificName: "");
}
