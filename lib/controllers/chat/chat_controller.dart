import 'package:get/get.dart';
import 'package:planet/components/common/custom_alert_dialog.dart';
import 'package:planet/models/api/chat/chat_message.dart';
import 'package:planet/services/open_ai_service.dart';

class ChatController extends GetxController {
  late final OpenAiApiClient openAiApiClient;
  final List<ChatMessage> messages = <ChatMessage>[].obs;
  var isLoading = false.obs;
  var initialImageDescription = "".obs;

  ChatController(this.openAiApiClient);

  Future<void> aiOnlyText(String prompt) async {
    isLoading(true);
    messages.add(ChatMessage(chatRole: ChatRole.user, text: prompt));

    try {
      final chatResponse = await openAiApiClient.aiOnlyText(
          prompt, initialImageDescription.value);
      ChatMessage chatMessage =
          ChatMessage(chatRole: ChatRole.ai, text: chatResponse.content);
      messages.add(chatMessage);
    } catch (e) {
      await Get.dialog(CustomAlertDialog(alertContent: e.toString()));
    } finally {
      isLoading(false);
    }
  }

  Future<void> aiWithImage(String prompt, String filePath) async {
    isLoading(true);

    try {
      final chatResponse = await openAiApiClient.aiWithImage(prompt, filePath);
      initialImageDescription(chatResponse.content);

      ChatMessage chatMessage =
          ChatMessage(chatRole: ChatRole.ai, text: chatResponse.content);
      messages.add(chatMessage);
    } catch (e) {
      await Get.dialog(CustomAlertDialog(alertContent: e.toString()));
    } finally {
      isLoading(false);
    }
  }

  Future<void> initialImageInfo(String filePath) async {
    isLoading(true);
    try {
      final chatResponse = await openAiApiClient.initialImageInfo(filePath);
      initialImageDescription(chatResponse.content);
    } catch (e) {
      await Get.dialog(CustomAlertDialog(alertContent: e.toString()));
    } finally {
      isLoading(false);
    }
  }
}
