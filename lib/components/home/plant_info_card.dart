import 'package:flutter/material.dart';
import 'package:planet/components/common/heart_box.dart';
import 'package:planet/theme.dart';

class PlantInfoCard extends StatelessWidget {
  String? imgUrl;
  String? nickName;
  int? heart;

  PlantInfoCard({super.key, this.imgUrl, this.nickName, this.heart});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Stack(
        children: <Widget>[
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20.0),
              topRight: Radius.circular(20.0),
            ),
            child: Image.network(
              imgUrl ??
                  'https://www.urbanbrush.net/web/wp-content/uploads/edd/2022/11/urbanbrush-20221108214712319041.jpg',
              width: 300,
              height: 300,
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            bottom: 0,
            child: Container(
              width: 300,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                    // bottomLeft: Radius.circular(20.0),
                    // bottomRight: Radius.circular(20.0),
                    ),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.5),
                  ],
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 6.0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(nickName ?? "이름", style: TextStyles.infoTextStyle),
                      const SizedBox(height: 3),
                      HeartBox(heart: heart)
                    ]),
              ),
            ),
          )
        ],
      ),
    );
  }
}
