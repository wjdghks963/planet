import 'dart:io' show Platform;

class DevelopDomain {
  String baseUrl = "";

  String run (){
    if (Platform.isAndroid) {
      baseUrl = 'http://10.0.2.2:8080'; // 안드로이드 에뮬레이터용 로컬 주소
    } else if (Platform.isIOS) {
      baseUrl = 'http://localhost:8080'; // iOS 에뮬레이터/실제 장치용 로컬 주소
    }

    return baseUrl;
  }

}