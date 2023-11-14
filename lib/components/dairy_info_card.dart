import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:planet/components/common/period_box.dart';
import 'package:planet/controllers/selected_plant_detail_controller.dart';
import 'package:planet/screen/plant_detail.dart';
import 'package:planet/theme.dart';

class DairyInfoCard extends StatelessWidget {
  int uid;
  String? imgUrl;
  String nickName;
  int period;

  DairyInfoCard(
      {super.key,
      required this.uid,
      this.imgUrl,
      required this.nickName,
      required this.period});

  @override
  Widget build(BuildContext context) {
    final SelectedPlantDetailController selectedPlantDetailController =
        Get.find<SelectedPlantDetailController>();

    return InkWell(
      onTap: () {
        selectedPlantDetailController.selectDetail(uid, nickName, imgUrl);
        Get.to(
          () => const PlantDetail(),
          transition: Transition.rightToLeft,
        );
      },
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Column(
          children: <Widget>[
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20.0),
                topRight: Radius.circular(20.0),
              ),
              child: Image.network(
                imgUrl ??
                    'https://www.urbanbrush.net/web/wp-content/uploads/edd/2022/11/urbanbrush-20221108214712319041.jpg',
                width: double.infinity,
                height: 300,
                fit: BoxFit.cover,
              ),
            ),
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
