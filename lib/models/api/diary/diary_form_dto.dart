class DiaryFormDTO {
  final int plantId;
  final String content;
  final String imgData;
  final bool isPublic;
  final String createdAt;

  DiaryFormDTO({
    required this.plantId,
    required this.content,
    required this.imgData,
    required this.isPublic,
    required this.createdAt
  });
}
