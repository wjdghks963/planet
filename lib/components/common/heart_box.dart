import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:planet/theme.dart';

class HeartBox extends StatefulWidget {
  int heart;
  bool? isMine;
  bool? toggle;

  HeartBox({super.key, required this.heart, this.isMine, this.toggle});

  @override
  State<HeartBox> createState() => _HeartBoxState();
}

class _HeartBoxState extends State<HeartBox> {
  // 통신으로 함
  bool _isLiked = false;
  bool isMine = false;

  @override
  void initState() {
    super.initState();
    isMine = widget.isMine ?? true;
  }

  void likeToggle() {
    if (widget.toggle != null) {
      setState(() {
        _isLiked = !_isLiked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: likeToggle,
        child: Row(
          children: [
            widget.toggle == true
                ? _isLiked
                    ? SvgPicture.asset(
                        'assets/icons/fill_heart.svg',
                      )
                    : SvgPicture.asset(
                        'assets/icons/empty_heart.svg',
                      )
                : SvgPicture.asset(
                    'assets/icons/fill_heart.svg',
                  ),
            const SizedBox(width: 10),
            Text(
              "${widget.heart}" ?? "0",
              style: TextStyles.infoTextStyle,
            ),
          ],
        ));
  }
}
