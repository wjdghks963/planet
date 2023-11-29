import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:planet/components/common/custom_image.dart';
import 'package:planet/components/common/report_button.dart';
import 'package:planet/components/detail_info_container.dart';
import 'package:planet/components/custom_calendar.dart';
import 'package:planet/components/common/CustomAppBar.dart';
import 'package:planet/controllers/plant/plant_detail_controller.dart';
import 'package:planet/controllers/plant/selected_plant_detail_controller.dart';
import 'package:planet/screen/ai/ai_chat_screen.dart';
import 'package:planet/screen/plant/edit_plant_form.dart';
import 'package:planet/theme.dart';

class PlantDetail extends StatefulWidget {
  PlantDetail({super.key});

  @override
  State<PlantDetail> createState() => _PlantDetailState();
}

class _PlantDetailState extends State<PlantDetail> {
  void goToAI() {
    Get.to(
      () => const AIChatScreen(
        aiChatType: AiChatType.detail,
      ),
      transition: Transition.rightToLeft,
    );
  }

  void goToEdit() {
    Get.off(() => const EditPlantForm(), transition: Transition.rightToLeft);
  }

  @override
  Widget build(BuildContext context) {
    final SelectedPlantDetailController selectedPlantDetailController =
        Get.find<SelectedPlantDetailController>();
    PlantDetailController plantController = Get.put(PlantDetailController());
    plantController.getPlantDetail();

    return Obx(() {
      return Scaffold(
        backgroundColor: BgColor.mainColor,
        appBar: CustomAppBar(
            title: selectedPlantDetailController.selectedPlant.nickName ?? "",
            rightComponent: plantController.plantDetail.value?.isMine == true
                ? InkWell(
                    onTap: goToEdit,
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.0),
                      child: Icon(Icons.create, color: Colors.black),
                    ))
                : ReportButton(
                    reportType: ReportType.plant,
                  )),
        body: plantController.isLoading.value == true
            ? Center(child: Lottie.asset('assets/lotties/loading_lottie.json'))
            : Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 15.0,
                ),
                child: ListView(
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    ClipRRect(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(20.0)),
                        child: CustomImage(
                            imgUrl: plantController.plantDetail.value?.imgUrl)),
                    DetailInfoContainer(
                      nickName: plantController.plantDetail.value?.nickName !=
                              null
                          ? "${plantController.plantDetail.value?.nickName}"
                          : "${selectedPlantDetailController.selectedPlant.nickName}",
                      scientificName: plantController
                                  .plantDetail.value?.scientificName !=
                              null
                          ? "${plantController.plantDetail.value?.scientificName}"
                          : "${selectedPlantDetailController.selectedPlant.scientificName}",
                      period: plantController.plantDetail.value?.period != null
                          ? plantController.plantDetail.value!.period
                          : 0,
                      heart:
                          plantController.plantDetail.value?.heartCount != null
                              ? plantController.plantDetail.value!.heartCount
                              : 0,
                      isMine: plantController.plantDetail.value?.isMine != null
                          ? plantController.plantDetail.value!.isMine
                          : false,
                    ),
                    const CustomCalendar(),
                    const SizedBox(height: 30)
                  ],
                ),
              ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => goToAI(),
          tooltip: 'talkWithAI',
          backgroundColor: ColorStyles.mainAccent,
          child: const Icon(Icons.messenger),
        ),
      );
    });
  }
}
