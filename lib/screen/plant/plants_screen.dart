import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:planet/components/dairy_info_card.dart';
import 'package:planet/components/common/custom_alert_dialog.dart';
import 'package:planet/controllers/plant_controller.dart';
import 'package:planet/screen/plant/add_plant_form.dart';
import 'package:planet/theme.dart';

class PlantsScreen extends StatelessWidget {
  const PlantsScreen({super.key});

  Future? goToAddForm(int maxItemCount) {
    if (maxItemCount > 2) {
      return Get.dialog(
          CustomAlertDialog(alertContent: "$maxItemCount개 이상은 등록할 수 없습니다."));
    } else {
      return Get.to(
        const AddPlantForm(),
        transition: Transition.rightToLeft,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final plantController = Get.find<PlantController>();

    return Scaffold(
      body: Container(
        width: double.infinity,
        color: BgColor.mainColor,
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20,),
            const Text("내 식물",
                textAlign: TextAlign.left,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                )),
            Expanded(
              child: Obx(() => ListView.builder(
                    itemCount: plantController.summaryPlants.length,
                    itemBuilder: (context, index) {
                      final plant = plantController.summaryPlants[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 25.0),
                        child: DairyInfoCard(
                          nickName: plant.nickName,
                          uid: plant.plantId,
                          period: plant.period,
                        ),
                      );
                    },
                  )),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => goToAddForm(plantController.summaryPlants.length),
        tooltip: 'Increment',
        backgroundColor: ColorStyles.mainAccent,
        child: const Icon(Icons.add),
      ),
    );
  }
}
