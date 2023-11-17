import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:planet/components/common/heart_box.dart';
import 'package:planet/controllers/plant_controller.dart';
import 'package:planet/controllers/selected_plant_detail_controller.dart';
import 'package:planet/models/selected_plant_detail_model.dart';
import 'package:planet/screen/plant/plant_detail.dart';
import 'package:planet/theme.dart';

class PlantInfoCard extends StatelessWidget {
  int plantId;
  String imgUrl;
  String nickName;
  int heart;

  PlantInfoCard(
      {super.key,
      required this.plantId,
      required this.imgUrl,
      required this.nickName,
      required this.heart});

  @override
  Widget build(BuildContext context) {
    final SelectedPlantDetailController selectedController =
        Get.find<SelectedPlantDetailController>();

    Future? goToDetail() {
      selectedController.selectDetail(
          plantId: plantId, nickName: nickName, imgUrl: imgUrl);
      return Get.to(() => const PlantDetail());
    }

    return InkWell(
      onTap: goToDetail,
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Stack(
          children: <Widget>[
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20.0),
                topRight: Radius.circular(20.0),
              ),
              child: Image.network(
                imgUrl ??
                    'https://www.urbanbrush.net/web/wp-content/uploads/edd/2022/11/urbanbrush-20221108214712319041.jpg',
                width: 300,
                height: 300,
                fit: BoxFit.cover,
              ),
            ),
            Positioned(
              bottom: 0,
              child: Container(
                width: 300,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                      // bottomLeft: Radius.circular(20.0),
                      // bottomRight: Radius.circular(20.0),
                      ),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.5),
                    ],
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 6.0, horizontal: 6.0),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(nickName ?? "이름", style: TextStyles.infoTextStyle),
                        const SizedBox(height: 3),
                        HeartBox(heart: heart)
                      ]),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
