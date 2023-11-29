import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:planet/components/common/heart_box.dart';
import 'package:planet/components/common/period_box.dart';
import 'package:planet/controllers/user/user_info_controller.dart';
import 'package:planet/screen/plant/type_plants_screen.dart';
import 'package:planet/theme.dart';

class UserTotalInfo extends StatefulWidget {
  const UserTotalInfo({super.key});

  @override
  State<UserTotalInfo> createState() => _UserTotalInfoState();
}

class _UserTotalInfoState extends State<UserTotalInfo> {
  void goToMyHearts() {
    Get.to(() => const TypePlantsScreen(plantType: PlantType.hearts));
  }

  @override
  Widget build(BuildContext context) {
    UserInfoController userInfoController = Get.find<UserInfoController>();

    return Container(
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(5.0))),
        child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0),
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
                    PeriodBox(
                        period:
                            userInfoController.userInfoDetail.value?.period ??
                                0)
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
                    HeartBox(
                        heart: userInfoController
                                .userInfoDetail.value?.receivedHearts ??
                            0)
                  ],
                ),
                const SizedBox(
                  height: 15.0,
                ),
                InkWell(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "내가 준 관심",
                            style: TextStyles.normalStyle,
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Row(
                            children: [
                              SvgPicture.asset(
                                'assets/icons/interests_box.svg',
                                color: ColorStyles.mainAccent,
                              ),
                              const SizedBox(width: 10),
                              Text(
                                userInfoController.userInfoDetail.value == null
                                    ? "0"
                                    : "${userInfoController.userInfoDetail.value?.givenHearts}",
                                style: TextStyles.infoTextStyle,
                              ),
                            ],
                          )
                        ],
                      ),
                      SvgPicture.asset(
                        'assets/icons/arrow-circle-right.svg',
                        width: 35.0,
                      )
                    ],
                  ),
                  onTap: () => goToMyHearts(),
                )
              ],
            )));
  }
}
