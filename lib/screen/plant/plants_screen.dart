import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:planet/components/common/component_title.dart';
import 'package:planet/components/common/custom_ad_widget.dart';
import 'package:planet/components/plant/my_plant_detail_card.dart';
import 'package:planet/components/common/custom_alert_dialog.dart';
import 'package:planet/controllers/plant/plant_controller.dart';
import 'package:planet/controllers/user/user_info_controller.dart';
import 'package:planet/screen/plant/add_plant_form.dart';
import 'package:planet/theme.dart';

class PlantsScreen extends StatefulWidget {
  const PlantsScreen({super.key});

  @override
  State<PlantsScreen> createState() => _PlantsScreenState();
}

class _PlantsScreenState extends State<PlantsScreen> {

  Future? goToAddForm() async {
    UserInfoController userInfoController = Get.find<UserInfoController>();

    PlantController plantController = Get.find<PlantController>();

    int maxPlantsCount =
        userInfoController.userInfoDetail.value?.maxPlants ?? 3;

    if (plantController.myPlants.length + 1 > maxPlantsCount) {
      return Get.dialog(CustomAlertDialog(
          alertContent:
              "$maxPlantsCount 개 이상은 등록할 수 없습니다.\n카페를 참고 아니면 마이 페이지에서 등급을 올려주세요."));
    } else {
      return Get.to(
        () => const AddPlantForm(),
        transition: Transition.rightToLeft,
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    PlantController plantController = Get.find<PlantController>();

    return Scaffold(
      body: Container(
        width: double.infinity,
        color: BgColor.mainColor,
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 20,
            ),
            ComponentTitle("내 식물"),
            Expanded(child: Obx(() {
              if (plantController.isLoading.value == true) {
                return Center(
                    child: Lottie.asset('assets/lotties/loading_lottie.json'));
              } else {
                return RefreshIndicator(
                  onRefresh: () async {
                    plantController.fetchMyPlants();
                  },
                  child: ListView.builder(
                    itemCount: plantController.myPlants.length + 1,
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        // 첫 번째 아이템에 광고 위젯 삽입
                        return const CustomAdWidget();
                      }
                      final plant = plantController.myPlants[index - 1];

                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 25.0),
                        child: MyPlantDetailCard(
                          nickName: plant.nickName,
                          plantId: plant.plantId,
                          period: plant.period,
                          imgUrl: plant.imgUrl,
                        ),
                      );
                    },
                  ),
                );
              }
            })),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => goToAddForm(),
        tooltip: 'addPlant',
        backgroundColor: ColorStyles.mainAccent,
        child: const Icon(Icons.add),
      ),
    );
  }
}
