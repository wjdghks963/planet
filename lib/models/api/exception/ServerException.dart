import 'dart:convert';

class ServerException implements Exception {
  final String message;

  ServerException.fromResponse(dynamic response) :
        message = _parseErrorMessage(response);

  static String _parseErrorMessage(dynamic response) {
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

