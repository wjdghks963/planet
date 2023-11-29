import 'package:flutter/material.dart';
import 'package:planet/theme.dart';

class UserProfile extends StatefulWidget {
  final String name;

  const UserProfile({super.key, required this.name});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(5.0))),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              const CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage('assets/images/alter_image.png'),
              ),
              Expanded(
                  child: Text(widget.name,
                      textAlign: TextAlign.center,
                      style: TextStyles.normalStyle))
            ],
          ),
        ));
  }
}
