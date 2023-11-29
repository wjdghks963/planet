import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:planet/components/common/custom_alert_dialog.dart';
import 'package:planet/components/common/custom_select_dialog.dart';
import 'package:planet/controllers/plant/selected_plant_detail_controller.dart';
import 'package:planet/services/user_api_service.dart';

enum ReportType { plant, diary }

class ReportButton extends StatelessWidget {
  final ReportType reportType;
  dynamic diaryId;

  ReportButton({super.key, required this.reportType, this.diaryId});

  void reportPlant() async {
    final result = await Get.dialog<bool>(const CustomSelectDialog(
      title: "신고",
      content:
          "이 식물의 이미지나 설명이 부적절하다고 생각하시나요?\n\n부적절한 내용은 커뮤니티에 해를 끼치며, 신고된 내용은 우리 팀에서 신중하게 검토됩니다.\n\n실제로 부적절한 경우, 해당 내용은 삭제될 수 있습니다.\n\n정말로 이 식물을 신고하시겠습니까?",
    ));

    if (result != null && result) {
      UserApiClient userApiClient = UserApiClient();
      final SelectedPlantDetailController selectedPlantDetailController =
          Get.find<SelectedPlantDetailController>();
      if (reportType == ReportType.plant) {
        await userApiClient
            .reportPlant(selectedPlantDetailController.selectedPlant.plantId!);
      } else {
        await userApiClient.reportDiary(diaryId ?? 0);
      }

      Get.dialog(CustomAlertDialog(alertContent: "신고 완료되었습니다."));
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
        child: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: Icon(Icons.report, color: Colors.redAccent),
        ),
        onTap: () {
          reportPlant();
        });
  }
}
