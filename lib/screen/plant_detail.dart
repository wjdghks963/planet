import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:planet/components/DetailInfoContainer.dart';
import 'package:planet/components/calendar.dart';
import 'package:planet/components/common/CustomAppBar.dart';
import 'package:planet/controllers/plant_detail_controller.dart';
import 'package:planet/theme.dart';


class PlantDetail extends StatefulWidget {
  const PlantDetail({super.key});

  @override
  State<PlantDetail> createState() => _PlantDetailState();
}

class _PlantDetailState extends State<PlantDetail> {
  @override
  Widget build(BuildContext context) {
    final PlantDetailViewModel controller = Get.find<PlantDetailViewModel>();

    return SafeArea(
        child: Scaffold(
            backgroundColor: BgColor.mainColor,
            appBar: CustomAppBar(
              title: controller.selectedPlant.nickName ?? "",
            ),
            body: Container(
              padding: const EdgeInsets.all(15.0),
              child: ListView(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(20.0)),
                    child: Image.network(
                      'https://www.urbanbrush.net/web/wp-content/uploads/edd/2022/11/urbanbrush-20221108214712319041.jpg',
                      width: double.infinity,
                      height: 300,
                      fit: BoxFit.cover,
                    ),
                  ),
                  DetailInfoCotainer(
                      nickName: controller.selectedPlant.nickName != null
                          ? controller.selectedPlant.nickName as String
                          : "",
                      scientificName: "scientificName",
                      period: 12,
                      heart: 123),
                  CustomCalendar()
                ],
              ),
            )));
  }
}
