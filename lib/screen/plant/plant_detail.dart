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
import 'package:planet/screen/plant/edit_plant_form.dart';
import 'package:planet/theme.dart';

// TODO:: 내거면 수정 가능 아니면 svg도 안뜨게
class PlantDetail extends StatefulWidget {
  const PlantDetail({super.key});

  @override
  State<PlantDetail> createState() => _PlantDetailState();
}

class _PlantDetailState extends State<PlantDetail> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final SelectedPlantDetailController selectedPlantDetailController =
        Get.find<SelectedPlantDetailController>();

    PlantDetailController plantController = Get.find<PlantDetailController>();

    return Scaffold(
        backgroundColor: BgColor.mainColor,
        appBar: CustomAppBar(
            title: selectedPlantDetailController.selectedPlant.nickName ?? "",
            rightComponent: plantController.plantDetail.value?.isMine == true
                ? InkWell(
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.0),
                      child: Icon(Icons.create, color: Colors.black),
                    ),
                    onTap: () => {
                          Get.off(const EditPlantForm(),
                              transition: Transition.rightToLeft),
                        })
                : ReportButton()),
        body: Obx(() {
          if (plantController.isLoading.value == true) {
            return Center(
                child: Lottie.asset('assets/lotties/loading_lottie.json'));
          } else {
            return Container(
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
                    heart: plantController.plantDetail.value?.heartCount != null
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
            );
          }
        }));
  }
}
