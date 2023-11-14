import 'package:flutter/material.dart';
import 'package:planet/components/common/period_box.dart';
import 'package:planet/theme.dart';

class UserTotalInfo extends StatelessWidget {
  int myTotalHeart;
  int userPeriod;
  int myInterests;

  UserTotalInfo(
      {super.key,
      required this.myTotalHeart,
      required this.userPeriod,
      required this.myInterests});

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(5.0))),
        child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 40.0),
            child: Column(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "식물과 함께 한지",
                      style: TextStyles.normalStyle,
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    PeriodBox(period: userPeriod)
                  ],
                ),
                const SizedBox(
                  height: 15.0,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "내가 받은 관심",
                      style: TextStyles.normalStyle,
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    PeriodBox(period: userPeriod)
                  ],
                ),
                const SizedBox(
                  height: 15.0,
                ),
                InkWell(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "내가 준 관심",
                        style: TextStyles.normalStyle,
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      PeriodBox(period: userPeriod)
                    ],
                  ),
                  onTap: ()=>print("ads"),
                )
              ],
            )));
  }
}
