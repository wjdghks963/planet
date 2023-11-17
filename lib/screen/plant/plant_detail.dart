import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:planet/components/common/custom_alert_dialog.dart';
import 'package:planet/components/common/custom_select_dialog.dart';
import 'package:planet/components/detail_info_container.dart';
import 'package:planet/components/custom_calendar.dart';
import 'package:planet/components/common/CustomAppBar.dart';
import 'package:planet/controllers/selected_plant_detail_controller.dart';
import 'package:planet/models/api/plant/plant_detail_model.dart';
import 'package:planet/screen/plant/edit_plant_form.dart';
import 'package:planet/services/plant_api_service.dart';
import 'package:planet/theme.dart';

// TODO:: 내거면 수정 가능 아니면 svg도 안뜨게
class PlantDetail extends StatefulWidget {
  const PlantDetail({super.key});

  @override
  State<PlantDetail> createState() => _PlantDetailState();
}

class _PlantDetailState extends State<PlantDetail> {
  PlantDetailModel? _plantDetail;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchPlantDetail();
  }

  void fetchPlantDetail() async {
    final selectedPlantDetailController =
        Get.find<SelectedPlantDetailController>();
    final plantApiClient = PlantsAipClient();

    try {
      final detail = await plantApiClient
          .getPlantDetail(selectedPlantDetailController.selectedPlant.plantId!);

      setState(() {
        _plantDetail = detail;
        isLoading = false;

        selectedPlantDetailController.selectDetail(
            plantId: _plantDetail!.plantId,
            nickName: _plantDetail!.nickName,
            scientificName: _plantDetail!.scientificName,
            imgUrl: _plantDetail!.imgUrl,
            heartCount: _plantDetail!.heartCount,
            hearted: _plantDetail!.hearted,
            createdAt: _plantDetail!.createdAt);
      });
    } catch (e) {
      print("Error : $e");
      // 오류 처리
      setState(() => isLoading = false);
    }
  }

  void reportPlant() async {
    final result = await Get.dialog<bool>(const CustomSelectDialog(
      title: "신고",
      content:
          "이 식물의 이미지나 설명이 부적절하다고 생각하시나요?\n\n부적절한 내용은 커뮤니티에 해를 끼치며, 신고된 내용은 우리 팀에서 신중하게 검토됩니다.\n\n실제로 부적절한 경우, 해당 내용은 삭제될 수 있습니다.\n\n정말로 이 식물을 신고하시겠습니까?",
    ));

    if (result != null && result) {
      Get.dialog(CustomAlertDialog(alertContent: "신고 완료되었습니다."));
    }
  }

  @override
  Widget build(BuildContext context) {
    final SelectedPlantDetailController selectedPlantDetailController =
        Get.find<SelectedPlantDetailController>();

    print(_plantDetail?.isMine);

    return SafeArea(
        child: Scaffold(
            backgroundColor: BgColor.mainColor,
            appBar: CustomAppBar(
                title:
                    selectedPlantDetailController.selectedPlant.nickName ?? "",
                rightComponent: _plantDetail?.isMine == true
                    ? InkWell(
                        child: const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.0),
                          child: Icon(Icons.create, color: Colors.black),
                        ),
                        onTap: () => {
                              Get.to(const EditPlantForm(),
                                  transition: Transition.rightToLeft),
                            })
                    : InkWell(
                        child: const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.0),
                          child: Icon(Icons.report, color: Colors.redAccent),
                        ),
                        onTap: () {
                          reportPlant();
                        })),
            body: isLoading
                ? const Center(child: CircularProgressIndicator())
                : Container(
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
                          child: Image.network(
                            'https://www.urbanbrush.net/web/wp-content/uploads/edd/2022/11/urbanbrush-20221108214712319041.jpg',
                            width: double.infinity,
                            height: 300,
                            fit: BoxFit.cover,
                          ),
                        ),
                        DetailInfoContainer(
                          nickName: _plantDetail?.nickName != null
                              ? "${_plantDetail?.nickName}"
                              : "${selectedPlantDetailController.selectedPlant.nickName}",
                          scientificName: _plantDetail?.scientificName != null
                              ? "${_plantDetail?.scientificName}"
                              : "${selectedPlantDetailController.selectedPlant.scientificName}",
                          period: _plantDetail?.period != null
                              ? _plantDetail!.period
                              : 0,
                          heart: _plantDetail?.heartCount != null
                              ? _plantDetail!.heartCount
                              : 0,
                          isMine: _plantDetail?.isMine != null
                              ? _plantDetail!.isMine
                              : false,
                        ),
                        CustomCalendar(
                            _plantDetail?.diaries, _plantDetail?.isMine),
                        const SizedBox(height: 30)
                      ],
                    ),
                  )));
  }
}
