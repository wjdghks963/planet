import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:planet/models/api/chat/chat_message_model.dart';
import 'package:planet/models/api/exception/ServerException.dart';

class OpenAiApiClient {
  Future<ChatMessageModel> aiOnlyText(
      String prompt, String imgDescription) async {
    String? apiKey = dotenv.env['OPENAI_API_KEY'];
    final url = Uri.parse('https://api.openai.com/v1/chat/completions');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $apiKey'
    };
    final body = json.encode({
      'model': "gpt-3.5-turbo-1106",
      "messages": [
        {
          "role": "system",
          "content":
          "You are a helpful assistant trained to provide information in a plain text format. Avoid using any markdown or special formatting in your responses."
        },
        {
          "role": "system",
          "content":
              "I am a knowledgeable bot trained to answer questions about plants. Ask me anything about plant species, care, habitats, or botany, and I will provide you with detailed, accurate information. How can I assist you with your plant-related inquiries today? "
        },
        {
          "role": "system",
          "content": "you got picture that about $imgDescription"
        },
        {"role": "user", "content": prompt},
      ],
    });

    try {
      final response = await http.post(url, headers: headers, body: body);

      var data = utf8.decode(response.bodyBytes);
      var decodedData = json.decode(data);

      var choices = decodedData["choices"] as List;
      var messageData = choices[0]['message'];

      ChatMessageModel message = ChatMessageModel.fromJson(messageData);
      return message;
    } catch (e) {
      print(e.toString());
      throw ServerException("AI 오류\n나중에 다시 시도해 주세요.");
    }
  }

  Future<ChatMessageModel> aiWithImage(String prompt, String filePath) async {
    String? apiKey = dotenv.env['OPENAI_API_KEY'];
    final url = Uri.parse('https://api.openai.com/v1/chat/completions');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $apiKey'
    };
    final body = json.encode({
      'model': "gpt-4-vision-preview",
      'max_tokens': 1000,
      'messages': [
        {
          "role": "system",
          "content":
          "You are a helpful assistant trained to provide information in a plain text format. Avoid using any markdown or special formatting in your responses."
        },
        {
          "role": "system",
          "content":
              "I am a knowledgeable bot trained to answer questions about plants. Ask me anything about plant species, care, habitats, or botany, and I will provide you with detailed, accurate information. How can I assist you with your plant-related inquiries today?"
        },
        {"role": "system", "content": "Identify the plant in this image."},
        {
          "role": "user",
          "content": [
            {"type": "text", "text": prompt},
            {
              "type": "image_url",
              "image_url": {
                "url": filePath,
                "detail": "low",
              }
            }
          ]
        }
      ],
    });

    try {
      final response = await http.post(url, headers: headers, body: body);

      var decodedData = json.decode(response.body);
      var choices = decodedData["choices"] as List;
      var messageData = choices[0]['message'];

      ChatMessageModel message = ChatMessageModel.fromJson(messageData);
      return message;
    } catch (e) {
      print(e.toString());
      throw ServerException("AI 오류\n나중에 다시 시도해 주세요.");
    }
  }

  Future<ChatMessageModel> initialImageInfo(String filePath) async {
    String? apiKey = dotenv.env['OPENAI_API_KEY'];
    final url = Uri.parse('https://api.openai.com/v1/chat/completions');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $apiKey'
    };
    final body = json.encode({
      'model': "gpt-4-vision-preview",
      'max_tokens': 1000,
      'messages': [
        {
          "role": "system",
          "content":
          "You are a helpful assistant trained to provide information in a plain text format. Avoid using any markdown or special formatting in your responses."
        },
        {
          "role": "system",
          "content":
              "I am a knowledgeable bot trained to answer questions about plants. Ask me anything about plant species, care, habitats, or botany, and I will provide you with detailed, accurate information. How can I assist you with your plant-related inquiries today?"
        },
        {"role": "system", "content": "Identify the plant in this image."},
        {
          "role": "user",
          "content": [
            {
              "type": "text",
              "text": "what is this plant. give me detail of this plant"
            },
            {
              "type": "image_url",
              "image_url": {
                "url": filePath,
                "detail": "low",
              }
            }
          ]
        }
      ],
    });

    try {
      final response = await http.post(url, headers: headers, body: body);

      var decodedData = json.decode(response.body);
      var choices = decodedData["choices"] as List;
      var messageData = choices[0]['message'];

      ChatMessageModel message = ChatMessageModel.fromJson(messageData);
      return message;
    } catch (e) {
      print(e.toString());
      throw ServerException("AI 오류\n나중에 다시 시도해 주세요.");
    }
  }
}
