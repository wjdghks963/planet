class UserInfoModel {
  final String name;
  final int receivedHearts;
  final int givenHearts;
  final int period;
  final int maxPlants;
  final bool aiServiceAccess;

  UserInfoModel(
      {required this.name,
      required this.receivedHearts,
      required this.givenHearts,
      required this.period,
      required this.maxPlants,
      required this.aiServiceAccess});

  factory UserInfoModel.fromJson(Map<String, dynamic> json) {
    return UserInfoModel(
        name: json['name'],
        receivedHearts: json['receivedHearts'],
        givenHearts: json['givenHearts'],
        period: json['period'],
        maxPlants: json['maxPlants'],
        aiServiceAccess: json['aiServiceAccess']);
  }
}
