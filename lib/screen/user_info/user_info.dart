import 'package:flutter/material.dart';
import 'package:planet/components/common/custom_text_button.dart';
import 'package:planet/screen/user_info/user_profile.dart';
import 'package:planet/screen/user_info/user_total_info.dart';
import 'package:planet/theme.dart';

class UserInfo extends StatelessWidget {
  const UserInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(20.0),
        width: double.infinity,
        color: BgColor.mainColor,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            UserProfile(),
            UserTotalInfo(
                myTotalHeart: 123, userPeriod: 123, myInterests: 213123),
         Column(
           children: [
             CustomTextButton(content: "로그아웃", onPressed: ()=> print("ads")),
             const SizedBox(height: 30.0,),
             CustomTextButton(content: "탈퇴", onPressed: ()=> print("ads"))
           ],
         )
          ],
        ));
  }
}
