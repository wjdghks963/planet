import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:planet/components/plant/my_plant_detail_card.dart';
import 'package:planet/components/common/custom_alert_dialog.dart';
import 'package:planet/controllers/plant/plant_controller.dart';
import 'package:planet/screen/plant/add_plant_form.dart';
import 'package:planet/theme.dart';

class PlantsScreen extends StatefulWidget {
  const PlantsScreen({super.key});

  @override
  State<PlantsScreen> createState() => _PlantsScreenState();
}

class _PlantsScreenState extends State<PlantsScreen> {
  late PlantController plantController;

  // TODO:: 최대 아이템 카운트 설정해야함
  Future? goToAddForm(int maxItemCount) {
    if (maxItemCount > 2) {
      return Get.dialog(
          CustomAlertDialog(alertContent: "$maxItemCount개 이상은 등록할 수 없습니다."));
    } else {
      return Get.to(
        () => const AddPlantForm(),
        transition: Transition.rightToLeft,
      );
    }
  }

  @override
  void initState() {
    plantController = Get.find<PlantController>();
    plantController.myPlants();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
            const Text("내 식물",
                textAlign: TextAlign.left,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                )),
            Expanded(child: Obx(() {
              if (plantController.isLoading == true) {
                return Center(
                    child: Lottie.asset('assets/lotties/loading_lottie.json'));
              } else {
                return ListView.builder(
                  itemCount: plantController.myPlants.length,
                  itemBuilder: (context, index) {
                    final plant = plantController.myPlants[index];

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
                );
              }
            })),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => goToAddForm(plantController.myPlants.length),
        tooltip: 'addPlant',
        backgroundColor: ColorStyles.mainAccent,
        child: const Icon(Icons.add),
      ),
    );
  }
}
