import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:planet/components/common/custom_alert_dialog.dart';
import 'package:planet/components/common/custom_select_dialog.dart';
import 'package:planet/components/common/report_button.dart';
import 'package:planet/components/detail_info_container.dart';
import 'package:planet/components/custom_calendar.dart';
import 'package:planet/components/common/CustomAppBar.dart';
import 'package:planet/controllers/plant/selected_plant_detail_controller.dart';
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
    final plantApiClient = PlantsApiClient();

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
      // setState(() => isLoading = false);
      await Get.dialog(CustomAlertDialog(alertContent: e.toString()));
      Get.back();
    }
  }

  @override
  Widget build(BuildContext context) {
    final SelectedPlantDetailController selectedPlantDetailController =
        Get.find<SelectedPlantDetailController>();

    return Scaffold(
        backgroundColor: BgColor.mainColor,
        appBar: CustomAppBar(
            title: selectedPlantDetailController.selectedPlant.nickName ?? "",
            rightComponent: _plantDetail?.isMine == true
                ? InkWell(
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.0),
                      child: Icon(Icons.create, color: Colors.black),
                    ),
                    onTap: () => {
                          Get.off(const EditPlantForm(),
                              transition: Transition.rightToLeft),
                        })
                : ReportButton()),
        body: isLoading
            ? Center(child: Lottie.asset('assets/lotties/loading_lottie.json'))
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
                        _plantDetail!.imgUrl,
                        width: double.infinity,
                        height: 300,
                        fit: BoxFit.fill,
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
                    CustomCalendar(_plantDetail?.diaries, _plantDetail?.isMine),
                    const SizedBox(height: 30)
                  ],
                ),
              ));
  }
}
