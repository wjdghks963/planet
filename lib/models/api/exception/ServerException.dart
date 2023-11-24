import 'dart:convert';

class ServerException implements Exception {
  final String message;

  ServerException(this.message);

  ServerException.fromResponse(dynamic response) :
        message = _parseErrorMessage(response);

  static String _parseErrorMessage(dynamic response) {
   if(response == null){
     return "서버 에러";
   }

    try {
      final Map<String, dynamic> responseData = response is String
          ? json.decode(response)
          : response as Map<String, dynamic>;
      return responseData['errors']['message'] ?? "Unknown server error";
    } catch (_) {
      return "Error parsing server response";
    }
  }

  @override
  String toString() => message;
}

