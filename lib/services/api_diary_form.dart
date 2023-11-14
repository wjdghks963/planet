import 'dart:typed_data';

import 'package:get/get.dart';

class ApiDiaryForm extends GetConnect {
  Future<Response> postForm(int uid, String url, Uint8List imageData,
      String content, bool isPublic) async {
    FormData formData = FormData({
      'plantId': uid,
      'image': MultipartFile(imageData, filename: 'image.jpg'),
      'content': content,
      'isPublic': isPublic,
    });
    print(uid);
    return await post(url, formData);
  }
}

// "plantId": 2,
// "title": "asdasdadsds",
// "imgUrl":"",
// "content":"",
// "isPublic":true
