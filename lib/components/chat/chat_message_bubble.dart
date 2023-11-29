import 'dart:io';

import 'package:flutter/material.dart';
import 'package:planet/models/api/chat/chat_message.dart';
import 'package:planet/theme.dart';

class ChatMessageBubble extends StatelessWidget {
  ChatRole? chatRole;
  String? message;
  String? filePath;

  ChatMessageBubble({super.key, this.chatRole, this.message, this.filePath});

  String addNewLinesToPeriods(String text) {
    var sentences = text.trim().split('. ');

    return sentences.join('.\n');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
      margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
      width: MediaQuery.of(context).size.width * 0.8,
      decoration: BoxDecoration(
        border: Border.all(
          color: chatRole == ChatRole.user
              ? ColorStyles.mainAccent
              : BgColor.mainColor,
          width: 2.0,
        ),
        borderRadius: BorderRadius.circular(10.0),
        color: chatRole == ChatRole.user
            ? ColorStyles.deepGreen
            : ColorStyles.mainAccent,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          filePath != null
              ? Padding(

                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Image.file(
                    File(filePath!),
                    width: 200,
                    height: 100,
                  ),
                )
              : const SizedBox(),
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Text(
              addNewLinesToPeriods("$message"),
              style: TextStyles.chatMessageTextStyle,
            ),
          ),
        ],
      ),
    );
  }
}
