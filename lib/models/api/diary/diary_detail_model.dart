class DiaryDetailModel {
  final int id;
  final String content;
  final String imgUrl;
  final String createdAt;
  final bool isPublic;
  final bool isMine;

  DiaryDetailModel({
    required this.id,
    required this.content,
    required this.imgUrl,
    required this.createdAt,
    required this.isPublic,
    required this.isMine,
  });

  factory DiaryDetailModel.fromJson(Map<String, dynamic> json) {
    return DiaryDetailModel(
      id: json['id'],
      content: json['content'],
      imgUrl: json['imgUrl'],
      createdAt: json['createdAt'],
      isPublic: json['public'],
      isMine: json['mine'],
    );
  }
}
