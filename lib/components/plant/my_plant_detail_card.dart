import 'package:flutter/material.dart';
import 'package:get/get.dart';
리import 'package:planet/components/common/custom_image.dart';
import 'package:planet/components/common/period_box.dart';
import 'package:planet/controllers/plant/selected_plant_detail_controller.dart';
import 'package:planet/screen/plant/plant_detail.dart';
import 'package:planet/theme.dart';

class MyPlantDetailCard extends StatelessWidget {
  int plantId;
  String imgUrl;
  String nickName;
  int period;

  MyPlantDetailCard(
      {super.key,
      required this.plantId,
      required this.imgUrl,
      required this.nickName,
      required this.period});

  @override
  Widget build(BuildContext context) {
    final SelectedPlantDetailController selectedPlantDetailController =
        Get.find<SelectedPlantDetailController>();

    Future? goToDetail() {
      selectedPlantDetailController.selectDetail(
          plantId: plantId, nickName: nickName, imgUrl: imgUrl);

      return Get.to(() =>  PlantDetail());
    }

    return InkWell(
      onTap: goToDetail,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Column(
          children: <Widget>[
            ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10.0),
                  topRight: Radius.circular(10.0),
                ),
                child: CustomImage(
                  imgUrl: imgUrl,
                )),
            Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 9.0, vertical: 10.0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(nickName ?? "이름", style: TextStyles.infoTextStyle),
                      const SizedBox(height: 6),
                      PeriodBox(period: period)
                    ])),
          ],
        ),
      ),
    );
  }
}
