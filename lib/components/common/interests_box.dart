import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';
import 'package:planet/theme.dart';


class InterestsBox extends StatelessWidget {
  int interests;

  InterestsBox({super.key, required this.interests});

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      SvgPicture.asset('assets/icons/interests_box.svg'),
      const SizedBox(width: 10),
      Text(
        "$interests" ?? "0",
        style: TextStyles.infoTextStyle,
      ),
    ]);
  }
}
