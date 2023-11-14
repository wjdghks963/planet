import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:planet/components/detail_info_container.dart';
import 'package:planet/components/calendar.dart';
import 'package:planet/components/common/CustomAppBar.dart';
import 'package:planet/controllers/plant_detail_controller.dart';
import 'package:planet/controllers/selected_plant_detail_controller.dart';
import 'package:planet/screen/diary/edit_plant_form.dart';
import 'package:planet/theme.dart';

// TODO:: 내거면 수정 가능 아니면 svg도 안뜨게
class PlantDetail extends StatefulWidget {
  const PlantDetail({super.key});

  @override
  State<PlantDetail> createState() => _PlantDetailState();
}

class _PlantDetailState extends State<PlantDetail> {
  @override
  Widget build(BuildContext context) {
    final SelectedPlantDetailController selectedPlantDetailController =
        Get.find<SelectedPlantDetailController>();

    print(selectedPlantDetailController.selectedPlant.uid);
    return SafeArea(
        child: Scaffold(
            backgroundColor: BgColor.mainColor,
            appBar: CustomAppBar(
              title: selectedPlantDetailController.selectedPlant.nickName ?? "",
              rightComponent: InkWell(
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  child: Icon(Icons.create, color: Colors.black),
                ),
                onTap: () => Get.to(const EditPlantForm(),
                    transition: Transition.rightToLeft),
              ),
            ),
            body: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 15.0,
              ),
              child: ListView(
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(20.0)),
                    child: Image.network(
                      'https://www.urbanbrush.net/web/wp-content/uploads/edd/2022/11/urbanbrush-20221108214712319041.jpg',
                      width: double.infinity,
                      height: 300,
                      fit: BoxFit.cover,
                    ),
                  ),
                  DetailInfoContainer(
                      nickName: selectedPlantDetailController
                                  .selectedPlant.nickName !=
                              null
                          ? selectedPlantDetailController.selectedPlant.nickName
                              as String
                          : "",
                      scientificName: "scientificName",
                      period: 12,
                      heart: 123),
                  CustomCalendar(),
                  const SizedBox(height: 30)
                ],
              ),
            )));
  }
}
