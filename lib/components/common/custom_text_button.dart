import 'package:flutter/material.dart';
import 'package:planet/theme.dart';

class CustomTextButton extends StatelessWidget {
  String content;
  Color backgroundColor;
  Function onPressed;

  CustomTextButton({
    super.key,
    required this.content,
    required this.backgroundColor,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        backgroundColor: backgroundColor,
        minimumSize: const Size(double.infinity, 0),
      ),
      onPressed: () => onPressed(),
      child: Text(
        content,
        style: TextStyles.buttonTextStyle,
      ),
    );
  }
}
