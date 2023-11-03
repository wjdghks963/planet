
import 'package:flutter/material.dart';

class DairyInfoCard extends StatelessWidget {
  const DairyInfoCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4, // 그림자 효과를 주기 위해 elevation 설정
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Column(
        children: <Widget>[
          Image.network(
'https://www.urbanbrush.net/web/wp-content/uploads/edd/2022/11/urbanbrush-20221108214712319041.jpg',            width: double.infinity, // 이미지를 컨테이너 너비와 같게 설정
            height: 300, // 이미지 높이 설정
            fit: BoxFit.cover, // 이미지가 컨테이너를 채울 수 있도록 설정
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              '이미지 설명 또는 API에서 가져온 정보',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}