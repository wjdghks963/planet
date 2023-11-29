import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:planet/components/chat/chat_message_bubble.dart';
import 'package:planet/components/common/CustomAppBar.dart';
import 'package:planet/components/common/custom_alert_dialog.dart';
import 'package:planet/controllers/chat/chat_controller.dart';
import 'package:planet/controllers/plant/selected_plant_detail_controller.dart';
import 'package:planet/models/api/chat/chat_message.dart';
import 'package:planet/services/open_ai_service.dart';
import 'package:planet/theme.dart';
import 'package:planet/utils/image_select.dart';

enum AiChatType { detail, question }

class AIChatScreen extends StatefulWidget {
  final AiChatType aiChatType;

  const AIChatScreen({super.key, required this.aiChatType});

  @override
  State<AIChatScreen> createState() => _AIChatScreenState();
}

class _AIChatScreenState extends State<AIChatScreen> {
  late ChatController chatController;

  final TextEditingController textEditingController = TextEditingController();
  final ScrollController scrollController = ScrollController();

  final FocusNode textFocusNode = FocusNode();

  final ImagePicker _picker = ImagePicker();
  XFile? _pickedImage;

  void getImage(ImageSource source) async {
    var permissionGranted = await requestImgPermission();
    if (permissionGranted) {
      selectedImg(source);
    }
  }

  void selectedImg(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(source: source);

      setState(() {
        _pickedImage = image;
      });
    } catch (e) {
      Get.dialog(CustomAlertDialog(alertContent: "지원하지 않는 파일 형식입니다."));
    }
  }

  void sendMessage() async {
    var messages = chatController.messages;

    if (textEditingController.text.isNotEmpty) {
      if (_pickedImage != null) {
        File selectedImgFile = File(_pickedImage!.path);
        List<int> imageBytes = await selectedImgFile.readAsBytes();
        String base64Image = base64Encode(imageBytes);

        chatController.aiWithImage(
            textEditingController.text, "data:image/jpeg;base64,$base64Image");

        messages.add(ChatMessage(
            text: textEditingController.text, imagePath: _pickedImage!.path));
        setState(() {
          _pickedImage = null; // Reset the image file after sending
        });
      } else {
        chatController.aiOnlyText(textEditingController.text);
      }
      textEditingController.clear();
      scrollToBottom();
    }
  }

  void scrollToBottom() {
    scrollController.animateTo(
      scrollController.position.maxScrollExtent + 80,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  @override
  void initState() {
    chatController = Get.put(ChatController(OpenAiApiClient()));

    if (widget.aiChatType == AiChatType.detail) {
      final SelectedPlantDetailController selectedPlantDetailController =
          Get.find<SelectedPlantDetailController>();
      chatController.initialImageInfo(
          selectedPlantDetailController.selectedPlant.imgUrl!);
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(textFocusNode);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
          title:
              widget.aiChatType == AiChatType.detail ? "AI 식물 질문" : "AI 식물 진단"),
      body: Column(
        children: <Widget>[
          Obx(() {
            if (chatController.messages.isEmpty) {
              return Expanded(
                  child: Center(
                      child: chatController.isLoading.value
                          ? Column(
                              children: [
                                const SizedBox(height: 30.0),
                                const Text(
                                  "식물을 분석 중입니다.",
                                  style: TextStyles.normalStyle,
                                ),
                                Lottie.asset(
                                    'assets/lotties/loading_lottie.json')
                              ],
                            )
                          : const Text("채팅 기록은 저장되지 않습니다.")));
            }

            return Expanded(
                child: ListView.builder(
              controller: scrollController,
              itemCount: chatController.messages.length,
              itemBuilder: (context, index) {
                final message = chatController.messages[index];
                return Align(
                  alignment: Alignment.centerLeft,
                  child: ChatMessageBubble(
                    chatRole: message.chatRole,
                    message: message.text,
                    filePath: message.imagePath,
                  ),
                );
              },
            ));
          }),
          if (_pickedImage != null)
            Image.file(
              File(_pickedImage!.path),
              width: 150,
              height: 150,
            ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: <Widget>[
                widget.aiChatType == AiChatType.question
                    ? IconButton(
                        icon: const Icon(Icons.photo),
                        onPressed: () => getImage(ImageSource.gallery),
                      )
                    : const SizedBox(
                        width: 25.0,
                      ),
                Expanded(
                  child: TextField(
                    focusNode: textFocusNode,
                    controller: textEditingController,
                    decoration: const InputDecoration(hintText: ''),
                  ),
                ),
                SizedBox(
                  width: 50.0,
                  height: 50.0,
                  child: Obx(
                    () => chatController.isLoading.value
                        ? Center(
                            child: Lottie.asset(
                                'assets/lotties/loading_lottie.json'))
                        : IconButton(
                            icon: const Icon(Icons.send),
                            onPressed: sendMessage,
                          ),
                  ),
                )
              ],
            ),
          ),
          const SizedBox(height: 20.0)
        ],
      ),
    );
  }

  @override
  void dispose() {
    scrollController.dispose();
    textEditingController.dispose();
    textFocusNode.dispose();
    super.dispose();
  }
}
