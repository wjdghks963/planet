import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:planet/theme.dart';


class HeartBox extends StatelessWidget {
  int? heart;

  HeartBox({required this.heart});

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      SvgPicture.asset(
        'assets/icons/fill_heart.svg',
      ),
      const SizedBox(width: 10),
      Text(
        "$heart" ?? "0",
        style: TextStyles.infoTextStyle,
      ),
    ]);
  }
}
