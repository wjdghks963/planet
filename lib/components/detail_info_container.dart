import 'package:flutter/material.dart';
import 'package:planet/components/common/heart_box.dart';
import 'package:planet/components/common/period_box.dart';
import 'package:planet/theme.dart';

class DetailInfoContainer extends StatelessWidget {
  String nickName;
  String scientificName;
  int period;
  int heart;
  bool isMine;

  DetailInfoContainer(
      {super.key,
      required this.nickName,
      required this.scientificName,
      required this.period,
      required this.heart,
      required this.isMine
      });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0), color: Colors.white),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            nickName,
            style: TextStyles.infoTextStyle,
          ),
          const SizedBox(height: 10),
          Text(
            scientificName,
            style: TextStyles.infoTextStyle,
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              PeriodBox(period: period),
              const SizedBox(width: 20),
              HeartBox(
                heart: heart,
                toggle: !isMine,
              )
            ],
          )
        ],
      ),
    );
  }
}
