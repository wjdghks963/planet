import 'package:flutter/material.dart';

class UserInfo extends StatelessWidget {
  const UserInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return

      Container(
        width: double.infinity,
        color: Color(0xFF4CAF50),  // 4CAF50 색상
        child: Center(
          child: Text(
            'This is the Home Screen',
            style: TextStyle(
              color: Colors.white,  // 흰색 텍스트
              fontSize: 24,
            ),
          ),
        ),
      );
  }
}