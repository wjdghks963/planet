import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:planet/models/api/plant/plant_add.dart';
import 'package:planet/models/api/plant/plant_summary.dart';
import 'package:get/get.dart';
import 'package:planet/utils/develop_domain.dart';

class GetPlantsApiClient extends GetConnect {
  final FlutterSecureStorage storage = const FlutterSecureStorage();

  Future<List<PlantSummary>> getPlants() async {
    String? token = await storage.read(key: 'access_token');
    String authorizationHeader = 'Bearer $token';
    String domain = DevelopDomain().run();

    final response = await get(
      '$domain/plants',
      headers: {'Authorization': authorizationHeader},
    );
    if (response.status.hasError) {
      return Future.error(response.statusText!);
    } else {
      return (response.body as List)
          .map((e) => PlantSummary.fromJson(e as Map<String, dynamic>))
          .toList();
    }
  }
}

class PostPlantApiClient extends GetConnect {
  final FlutterSecureStorage storage = const FlutterSecureStorage();

  Future<Response> addPlant(PlantAdd newPlant) async {
    String? token = await storage.read(key: 'access_token');
    String authorizationHeader = 'Bearer $token';
    String domain = DevelopDomain().run();

    final response = await post(
      '$domain/plants/add',
      {
        "nickName": newPlant.nickName,
        "scientificName": newPlant.scientificName,
        "img": newPlant.img,
      },
      headers: {'Authorization': authorizationHeader},
    );

    return response;
  }
}
