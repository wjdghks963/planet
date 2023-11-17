import 'package:get/get.dart';
import 'package:planet/models/api/diary/diary_detail_model.dart';
import 'package:planet/models/api/diary/diary_form_dto.dart';
import 'package:planet/models/api/exception/ServerException.dart';
import 'package:planet/services/api_manager.dart';
import 'package:planet/utils/OAuth/token_storage.dart';
import 'package:planet/utils/develop_domain.dart';

class DiaryApiClient extends GetConnect {
  String domain = DevelopDomain().run();
  TokenStorage tokenStorage = TokenStorage();
  final ApiManager apiManager = ApiManager();

  Future<Map<String, String>> _getAuthHeader() async {
    String? token = await tokenStorage.getToken(TokenType.acc);
    return {'Authorization': 'Bearer $token'};
  }

  Future<Response> postForm(DiaryFormDTO diaryFormDTO) async {
    final response = await apiManager.performApiCall(() async => post(
          "$domain/diary/add",
          headers: await _getAuthHeader(),
          {
            'plantId': diaryFormDTO.plantId,
            'imgData': diaryFormDTO.imgData,
            'content': diaryFormDTO.content,
            'isPublic': diaryFormDTO.isPublic,
            'createdAt': diaryFormDTO.createdAt
          },
        ));
    if (response.statusCode == 200) {
      return response;
    } else {
      throw ServerException.fromResponse(response.body);
    }
  }

  Future<Response> editForm(int diaryId, DiaryFormDTO diaryFormDTO) async {
    final response = await apiManager.performApiCall(() async => post(
          "$domain/diary/edit/$diaryId",
          headers: await _getAuthHeader(),
          {
            'plantId': diaryFormDTO.plantId,
            'imgData': diaryFormDTO.imgData,
            'content': diaryFormDTO.content,
            'isPublic': diaryFormDTO.isPublic,
            'createdAt': diaryFormDTO.createdAt
          },
        ));

    if (response.statusCode == 200) {
      return response;
    } else {
      throw ServerException.fromResponse(response.body);
    }
  }

  Future<Response> removeDiary(int diaryId) async {
    final response = await apiManager.performApiCall(() async => delete(
          "$domain/diary/remove/$diaryId",
          headers: await _getAuthHeader(),
        ));

    if (response.statusCode == 200) {
      return response;
    } else {
      throw ServerException.fromResponse(response.body);
    }
  }

  Future<DiaryDetailModel> getDiaryDetail(int diaryId) async {
    final response = await apiManager.performApiCall(() async => get(
          "$domain/diary/$diaryId",
          headers: await _getAuthHeader(),
        ));
    if (response.statusCode == 200) {
      return DiaryDetailModel.fromJson(response.body);
    } else {
      throw ServerException.fromResponse(response.body);
    }
  }
}
