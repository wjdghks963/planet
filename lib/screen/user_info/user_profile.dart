import 'package:flutter/material.dart';
import 'package:planet/theme.dart';

class UserProfile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(5.0))),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: const [
              CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage('https://www.urbanbrush.net/web/wp-content/uploads/edd/2022/11/urbanbrush-20221108214712319041.jpg'),
              ),
              Expanded(child: Text("유저 이름", textAlign: TextAlign.center,style: TextStyles.normalStyle))
            ],
          ),
        ));
  }
}
