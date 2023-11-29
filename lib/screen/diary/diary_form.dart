import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:planet/components/common/CustomAppBar.dart';
import 'package:planet/components/common/custom_alert_dialog.dart';
import 'package:planet/components/common/custom_select_dialog.dart';
import 'package:planet/components/common/custom_text_button.dart';
import 'package:planet/controllers/diary/diary_controller.dart';
import 'package:planet/controllers/plant/selected_plant_detail_controller.dart';
import 'package:planet/models/api/diary/diary_form_dto.dart';
import 'package:planet/services/diary_api_service.dart';
import 'package:planet/theme.dart';
import 'package:planet/utils/image_resizer.dart';
import 'package:planet/utils/image_select.dart';

class DiaryForm extends StatefulWidget {
  const DiaryForm({super.key});

  @override
  State<DiaryForm> createState() => _DiaryFormState();
}

class _DiaryFormState extends State<DiaryForm> {
  final TextEditingController _contentController = TextEditingController();

  final ImagePicker _picker = ImagePicker();
  XFile? _pickedImage;

  void getImage(ImageSource source) async {
    var permissionGranted = await requestImgPermission();
    if (permissionGranted) {
      selectedImg(source);
    }
  }

  void selectedImg(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(source: source);

      setState(() {
        _pickedImage = image;
      });
    } catch (e) {
      Get.dialog(CustomAlertDialog(alertContent: "지원하지 않는 파일 형식입니다."));
    }
  }

  bool isPublic = false;

  Future<void> postForm() async {
    DiaryController diaryController = Get.find<DiaryController>();

    String content = _contentController.text;

    if (_pickedImage == null) {
      Get.dialog(CustomAlertDialog(alertContent: "사진을 등록해 주세요."));
      return;
    }
    if (content == "") {
      Get.dialog(CustomAlertDialog(alertContent: "빈칸을 전부 채워 주세요."));
      return;
    }

    SelectedPlantDetailController selectedPlantDetailController =
        Get.find<SelectedPlantDetailController>();

    // 이미지 압축
    String? compressedData = await compressImage(_pickedImage!);

    DiaryFormDTO diaryFormDTO = DiaryFormDTO(
        plantId: selectedPlantDetailController.selectedPlant.plantId!,
        content: _contentController.text,
        imgData: compressedData!,
        isPublic: isPublic,
        createdAt: Get.arguments["date"]);

    await diaryController.addDiary(diaryFormDTO);
  }

  @override
  void initState() {
    Get.put(DiaryController(DiaryApiClient()));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final SelectedPlantDetailController selectedPlantDetailController =
        Get.find<SelectedPlantDetailController>();
    final DiaryController diaryController = Get.find<DiaryController>();
    String? nickName =
        selectedPlantDetailController.selectedPlant.nickName ?? "";

    return Scaffold(
        appBar: CustomAppBar(
          title: "일지 작성",
        ),
        body: Obx(() {
          if (diaryController.isLoading.value == true) {
            return Center(
                child: Lottie.asset('assets/lotties/loading_lottie.json'));
          } else {
            return Container(
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
                            nickName.length > 8
                                ? "${nickName.substring(0, 8)}..."
                                : nickName,
                            style: TextStyles.whiteTitleStyle,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                          ),
                          Text(
                            Get.arguments?["date"] ?? "",
                            style: TextStyles.whiteTitleStyle,
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          const Text(
                            "공개",
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                          Switch(
                              value: isPublic,
                              activeColor: ColorStyles.mainAccent,
                              onChanged: (value) {
                                setState(() {
                                  isPublic = value;
                                });
                              })
                        ],
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ClipRRect(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(20.0),
                      ),
                      child: _pickedImage != null
                          ? InkWell(
                              onTap: () => getImage(ImageSource.gallery),
                              child: Image.file(
                                File(_pickedImage!.path),
                                fit: BoxFit.fitWidth,
                                height: 300,
                              ),
                            )
                          : InkWell(
                              onTap: () => getImage(ImageSource.gallery),
                              child: Container(
                                color: Colors.white,
                                height: 300,
                                padding: EdgeInsets.all(100),
                                child:
                                    SvgPicture.asset('assets/icons/image.svg'),
                              ),
                            )),
                  const SizedBox(
                    height: 50,
                  ),
                  SizedBox(
                    height: 400,
                    child: TextField(
                      controller: _contentController,
                      maxLines: 200,
                      keyboardType: TextInputType.multiline,
                      decoration: InputDecoration(
                        hintText: "기록하고 싶은 내용을 입력하세요.",
                        fillColor: Colors.white,
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          borderSide:
                              const BorderSide(color: ColorStyles.mainAccent),
                        ),
                      ),
                      style: const TextStyle(height: 1.5),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  CustomTextButton(
                      content: "작성 완료",
                      backgroundColor: ColorStyles.mainAccent,
                      onPressed: () {
                        postForm();
                      }),
                  const SizedBox(
                    height: 30,
                  ),
                ],
              ),
            );
          }
        }));
  }
}
