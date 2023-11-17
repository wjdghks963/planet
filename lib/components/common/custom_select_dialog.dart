import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:planet/theme.dart';

class CustomSelectDialog extends StatelessWidget {
  final String title;
  final String content;

  const CustomSelectDialog(
      {super.key, required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 18.0,
          fontWeight: FontWeight.bold,
          color: ColorStyles.mainAccent,
        ),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
        side: const BorderSide(color: ColorStyles.mainAccent, width: 5.0),
      ),
      content: Text(
        content,
        style: const TextStyle(
          fontSize: 16.0,
          color: Colors.black87,
        ),
      ),
      actions: [
        TextButton(
          child: const Text(
            "네",
            style: TextStyle(
              color: ColorStyles.mainAccent,
            ),
          ),
          onPressed: () {
            Get.back(result: true);
          },
        ),
        TextButton(
          child: const Text(
            "아니요",
            style: TextStyle(
              color: Colors.black54,
            ),
          ),
          onPressed: () {
            Get.back(result: false);
          },
        ),
      ],
    );
  }
}
