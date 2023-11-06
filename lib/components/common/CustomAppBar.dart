import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:planet/theme.dart';


class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  String title;
  bool? canPop;
  Widget? rightComponent;

  CustomAppBar(
      {super.key, required this.title, this.canPop, this.rightComponent});

  @override
  Size get preferredSize => const Size.fromHeight(56);

  @override
  Widget build(BuildContext context) {
    List<Widget> appBarActions = [];

    if (rightComponent != null) {
      appBarActions.add(rightComponent!);
    }

    return AppBar(
        backgroundColor: Colors.white,
        title: Text(
          title,
          style: TextStyles.appBarStyle,
          textAlign: TextAlign.center,
        ),
        centerTitle: true,
        actions: appBarActions,
        leading: canPop == null || canPop != false
            ? IconButton(
                icon: const Icon(
                  Icons.chevron_left,
                  color: Colors.black,
                ),
                onPressed: () {
                  Get.back();
                },
              )
            : null);
  }
}
