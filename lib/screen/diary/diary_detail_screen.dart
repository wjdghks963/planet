import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:planet/components/common/CustomAppBar.dart';
import 'package:planet/components/common/custom_alert_dialog.dart';
import 'package:planet/components/common/custom_image.dart';
import 'package:planet/components/common/report_button.dart';
import 'package:planet/controllers/plant/selected_plant_detail_controller.dart';
import 'package:planet/models/api/diary/diary_detail_model.dart';
import 'package:planet/screen/diary/diary_edit_form.dart';
import 'package:planet/services/diary_api_service.dart';
import 'package:planet/theme.dart';

class DiaryDetailScreen extends StatefulWidget {
  @override
  State<DiaryDetailScreen> createState() => _DiaryDetailScreenState();
}

class _DiaryDetailScreenState extends State<DiaryDetailScreen> {
  TextEditingController contentController = TextEditingController();
  DiaryDetailModel? diaryDetail;
  bool isLoading = true;

  final diaryId = Get.arguments["diaryId"];

  final SelectedPlantDetailController selectedPlantDetailController =
      Get.find<SelectedPlantDetailController>();

  void fetchDiaryDetail() async {
    try {
      final diaryApiClient = DiaryApiClient();
      final detail = await diaryApiClient.getDiaryDetail(diaryId);
      setState(() {
        diaryDetail = detail;
        contentController.text = diaryDetail!.content;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      await Get.dialog(CustomAlertDialog(alertContent: e.toString()));
      Get.back();
    }
  }

  @override
  void initState() {
    super.initState();
    fetchDiaryDetail();
  }

  @override
  Widget build(BuildContext context) {
    bool readOnly = true;
    return Scaffold(
        appBar: CustomAppBar(
            title: "일지",
            rightComponent: diaryDetail?.isMine == true
                ? InkWell(
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.0),
                      child: Icon(Icons.create, color: Colors.black),
                    ),
                    onTap: () => Get.off(() => const DiaryEditForm(),
                        arguments: {
                          "diary": diaryDetail,
                          "date": Get.arguments["date"]
                        }),
                  )
                : ReportButton(
                    reportType: ReportType.diary,
                    diaryId: diaryId,
                  )),
        body: isLoading
            ? Center(child: Lottie.asset('assets/lotties/loading_lottie.json'))
            : Container(
                color: BgColor.mainColor,
                child: ListView(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 10.0),
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              selectedPlantDetailController
                                      .selectedPlant.nickName ??
                                  "",
                              style: TextStyles.whiteTitleStyle,
                            ),
                            Text(
                              Get.arguments["date"] ?? "",
                              style: TextStyles.whiteTitleStyle,
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    ClipRRect(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(20.0),
                        ),
                        child: CustomImage(imgUrl: diaryDetail!.imgUrl)),
                    const SizedBox(
                      height: 50,
                    ),
                    SizedBox(
                      height: 400,
                      child: TextField(
                        controller: contentController,
                        readOnly: readOnly,
                        maxLines: 200,
                        keyboardType: TextInputType.multiline,
                        decoration: InputDecoration(
                          fillColor: Colors.white,
                          filled: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
                            borderSide: const BorderSide(
                                color: ColorStyles
                                    .mainAccent), // 초점이 맞춰진 상태의 테두리 색상 설정
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ));
  }
}
