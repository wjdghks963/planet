import 'dart:convert';

import 'package:planet/models/api/exception/ServerException.dart';
import 'package:planet/models/api/plant/plant_form_model.dart';
import 'package:planet/models/api/plant/plant_detail_model.dart';
import 'package:get/get.dart';
import 'package:planet/services/api_manager.dart';
import 'package:planet/utils/OAuth/token_storage.dart';
import 'package:planet/utils/develop_domain.dart';

class PlantsApiClient extends GetConnect {
  TokenStorage tokenStorage = TokenStorage();

  Future<Map<String, String>> _getAuthHeader() async {
    String? token = await tokenStorage.getToken(TokenType.acc);
    return {'Authorization': 'Bearer $token'};
  }

  final ApiManager apiManager = ApiManager();

  String domain = DevelopDomain().run();

  // 내 plants 조회
  Future<Response> getPlants() async {
    final response = await get(
      '$domain/plants/my',
      headers: await _getAuthHeader(),
    );

    if (response.statusCode == 200) {
      return response;
    } else {
      throw ServerException.fromResponse(response.body);
    }
  }

  // plants 추가
  Future<bool> addPlant(PlantFormModel newPlant) async {
    final response = await apiManager.performApiCall(() async => post(
        '$domain/plants/add',
        {
          "nickName": newPlant.nickName,
          "scientificName": newPlant.scientificName,
          "imgData": newPlant.imgData,
        },
        headers: await _getAuthHeader()));

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseBody =
          jsonDecode(response.bodyString!);
      return responseBody['ok'] ?? false;
    } else {
      throw ServerException.fromResponse(response.body);
    }
  }

  // plants 수정
  Future<bool> editPlant(PlantFormModel newPlant, int plantId) async {
    final response = await apiManager.performApiCall(() async => post(
          '$domain/plants/edit/$plantId',
          headers: await _getAuthHeader(),
          {
            "nickName": newPlant.nickName,
            "scientificName": newPlant.scientificName,
            "imgData": newPlant.imgData,
          },
        ));

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseBody =
          jsonDecode(response.bodyString!);
      return responseBody['ok'] ?? false;
    } else {
      throw ServerException.fromResponse(response.body);
    }
  }

  // plant 삭제
  Future<bool> removePlant(int plantId) async {
    final response = await apiManager.performApiCall(() async => delete(
        '$domain/plants/remove/$plantId',
        headers: await _getAuthHeader()));

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseBody =
          jsonDecode(response.bodyString!);
      return responseBody['ok'] ?? false;
    } else {
      throw ServerException.fromResponse(response.body);
    }
  }

// plant detail
  Future<PlantDetailModel> getPlantDetail(int plantId) async {
    final response = await apiManager.performApiCall(() async =>
        get('$domain/plants/$plantId', headers: await _getAuthHeader()));

    if (response.statusCode == 200) {
      return PlantDetailModel.fromJson(response.body);
    } else {
      throw ServerException.fromResponse(response.body);
    }
  }

  // 랜덤 plants
  Future<Response> getRandomPlants() async {
    final response = await get(
      '$domain/plants/random',
    );

    if (response.statusCode == 200) {
      return response;
    } else {
      throw ServerException.fromResponse(response.body);
    }
  }

  // plants recent pagenation
  Future<Response> getRecentPlants(int page) async {
    final response = await get('$domain/plants?page=$page');
    if (response.statusCode == 200) {
      return response;
    } else {
      throw ServerException.fromResponse(response.body);
    }
  }

  // heart toggle
  Future<Response?> toggleHeartPlant(int plantId) async {
    final response = await apiManager.performApiCall(() async => post(
        "$domain/plants/heart/$plantId", {},
        headers: await _getAuthHeader()));
    if (response.statusCode == 200) {
      return response;
    } else {
      throw ServerException.fromResponse(response.body);
    }
  }
}
