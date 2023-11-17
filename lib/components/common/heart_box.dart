import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:planet/components/common/custom_alert_dialog.dart';
import 'package:planet/controllers/selected_plant_detail_controller.dart';
import 'package:planet/services/plant_api_service.dart';
import 'package:planet/theme.dart';

class HeartBox extends StatefulWidget {
  int heart;
  bool? toggle;

  HeartBox({super.key, required this.heart, this.toggle});

  @override
  State<HeartBox> createState() => _HeartBoxState();
}

class _HeartBoxState extends State<HeartBox> {
  late SelectedPlantDetailController selectedPlantDetailController;
  bool? _isLiked;

  @override
  void initState() {
    super.initState();
    selectedPlantDetailController = Get.find<SelectedPlantDetailController>();
    _isLiked = selectedPlantDetailController.selectedPlant.hearted;
  }

  void likeToggle() {
    final plantsApiClient = PlantsApiClient();

    final SelectedPlantDetailController selectedController =
        Get.find<SelectedPlantDetailController>();

    if (widget.toggle == true) {
      try {
        plantsApiClient
            .toggleHeartPlant(selectedController.selectedPlant.plantId!);
      } catch (e) {
        Get.dialog(CustomAlertDialog(alertContent: e.toString()));
      }

      setState(() {
        if (_isLiked == true) {
          // 좋아요 취소
          widget.heart--; // 좋아요 수 감소
        } else {
          // 좋아요
          widget.heart++; // 좋아요 수 증가
        }

        _isLiked = !_isLiked!;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: likeToggle,
        child: Row(
          children: [
            widget.toggle == true
                ? _isLiked == true
                    ? SvgPicture.asset(
                        'assets/icons/fill_heart.svg',
                      )
                    : SvgPicture.asset(
                        'assets/icons/empty_heart.svg',
                      )
                : SvgPicture.asset(
                    'assets/icons/fill_heart.svg',
                  ),
            const SizedBox(width: 10),
            Text(
              "${widget.heart}" ?? "0",
              style: TextStyles.infoTextStyle,
            ),
          ],
        ));
  }
}
