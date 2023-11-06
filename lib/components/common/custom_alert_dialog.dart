import 'package:flutter/material.dart';
import 'package:planet/theme.dart';

class CustomAlertDialog extends StatelessWidget {
  final String alertContent;

  TextStyle contentTextStyle = TextStyles.infoTextStyle.copyWith(
    fontSize: 18, // 폰트 크기 변경
  );

  CustomAlertDialog({super.key, required this.alertContent});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        "알림",
        style: TextStyles.dialogTextStyle,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
        side: const BorderSide(color: ColorStyles.mainAccent, width: 5.0),

        //border: Border.all(color: ColorStyles.mainAccent, width: 2)
      ),
      content: Text(
        alertContent,
        style: contentTextStyle,
      ),
    );
  }
}
