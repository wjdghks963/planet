import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:planet/components/common/custom_alert_dialog.dart';
import 'package:planet/controllers/plant/plant_detail_controller.dart';
import 'package:planet/controllers/plant/selected_plant_detail_controller.dart';
import 'package:planet/services/plant_api_service.dart';
import 'package:planet/theme.dart';

class HeartBox extends StatefulWidget {
  int heart;
  bool? toggle;
  TextStyle? textStyle;

  HeartBox({super.key, required this.heart, this.toggle, this.textStyle});

  @override
  State<HeartBox> createState() => _HeartBoxState();
}

class _HeartBoxState extends State<HeartBox>
    with SingleTickerProviderStateMixin {
  late PlantDetailController plantDetailController;
  AnimationController? _animationController;
  Animation<double>? _animation;
  bool? _isLiked;

  @override
  void initState() {
    super.initState();
    plantDetailController = Get.find<PlantDetailController>();
    _isLiked = plantDetailController.plantDetail.value?.hearted;

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _animation =
        Tween<double>(begin: 0.0, end: 5.0).animate(_animationController!)
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              _animationController!.reverse();
            }
          });

    if (widget.toggle == true) {
      _animationController!.forward();
    }
  }

  void likeToggle() {
    final plantsApiClient = PlantsApiClient();

    final SelectedPlantDetailController selectedController =
        Get.find<SelectedPlantDetailController>();

    if (widget.toggle == true) {
        _animationController!.forward();
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
        child: AnimatedBuilder(
          animation: _animationController!,
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(0, _animation!.value),
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
                    "${widget.heart}",
                    style: widget.textStyle ?? TextStyles.infoTextStyle,
                  ),
                ],
              ),
            );
          },
        ));
  }
}
