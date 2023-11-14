

class SelectedPlantDetailModel {
  final int? uid;
  final String? nickName;
  final String? imgUrl;
  final String? scientificName;

  SelectedPlantDetailModel(
      {this.uid, this.nickName, this.imgUrl, this.scientificName});

  factory SelectedPlantDetailModel.fromJson(Map<String, dynamic> json) =>
      SelectedPlantDetailModel(
          uid: 1, nickName: "asd", imgUrl: "", scientificName: "");

  Map<String, dynamic> toJson() => {
        'uid': uid,
        'nickName': nickName,
        'imgUrl': imgUrl,
        'scientificName': scientificName,
      };


}
