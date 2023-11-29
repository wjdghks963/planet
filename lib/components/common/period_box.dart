import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';
import 'package:planet/theme.dart';


class PeriodBox extends StatelessWidget {
  int period;

  PeriodBox({required this.period});

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      SvgPicture.asset('assets/icons/clock.svg'),
      const SizedBox(width: 10),
      Text(
        "D+$period",
        style: TextStyles.infoTextStyle,
      ),
    ]);
  }
}
