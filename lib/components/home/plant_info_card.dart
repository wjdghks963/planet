import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:planet/components/common/custom_image.dart';
import 'package:planet/components/common/heart_box.dart';
import 'package:planet/controllers/plant/selected_plant_detail_controller.dart';
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

  void goToDetail() {
    SelectedPlantDetailController selectedController =
        Get.find<SelectedPlantDetailController>();

    selectedController.selectDetail(
        plantId: plantId, nickName: nickName, imgUrl: imgUrl);

    Get.to(() => PlantDetail());
  }

  @override
  Widget build(BuildContext context) {
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
                topLeft: Radius.circular(10.0),
                topRight: Radius.circular(10.0),
              ),
              child: CustomImage(
                imgUrl: imgUrl,
              ),
            ),
            Positioned.fill(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: 60,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.9),
                      ],
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6.0),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(nickName ?? "이름",
                              style: TextStyles.whiteInfoTextStyle),
                          const SizedBox(height: 3),
                          HeartBox(
                            heart: heart,
                            textStyle: TextStyles.whiteInfoTextStyle,
                          )
                        ]),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
