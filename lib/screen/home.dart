import 'package:flutter/material.dart';
import 'package:planet/components/home/popular_of_week.dart';
import 'package:planet/theme.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        color: BgColor.mainColor,
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: ListView(
          children: [
            const SizedBox(
              height: 25.0,
            ),
            Column(
              children: const [
                SizedBox(
                    width: double.infinity,
                    child: Text("주간 인기",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ))),
                SizedBox(
                  height: 10.0,
                ),
                PopularWeekCarousel(),
              ],
            ),
            const SizedBox(
              height: 25.0,
            ),
            Column(
              children: [
                SizedBox(
                    width: double.infinity,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text("랜덤",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                            )),
                        InkWell(
                          child: Text("더 보기",
                              textAlign: TextAlign.left,
                              style: TextStyles.whiteLabelTextStyle),
                        )
                      ],
                    )),
                PopularWeekCarousel(),
              ],
            ),
          ],
        ));
  }
}
