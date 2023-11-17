import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:planet/components/common/CustomAppBar.dart';
import 'package:planet/components/common/custom_alert_dialog.dart';
import 'package:planet/components/common/custom_text_button.dart';
import 'package:planet/controllers/selected_plant_detail_controller.dart';
import 'package:planet/models/api/diary/diary_detail_model.dart';
import 'package:planet/models/api/diary/diary_form_dto.dart';
import 'package:planet/services/diary_api_service.dart';
import 'package:planet/theme.dart';
import 'package:planet/utils/image_resizer.dart';

class DiaryEditForm extends StatefulWidget {
  const DiaryEditForm({super.key});

  @override
  State<DiaryEditForm> createState() => _DiaryEditFormState();
}

class _DiaryEditFormState extends State<DiaryEditForm> {
  final DiaryDetailModel diaryDetail = Get.arguments["diary"];

  final TextEditingController _contentController = TextEditingController();

  final ImagePicker _picker = ImagePicker();
  XFile? _pickedImage;

  void getImage(ImageSource source) async {
    final XFile? image = await _picker.pickImage(source: source);

    setState(() {
      _pickedImage = image;
    });
  }

  bool isPublic = false;

  Future<void> editForm() async {
    SelectedPlantDetailController selectedPlantDetailController =
        Get.find<SelectedPlantDetailController>();

    // 이미지 압축
    String? compressedData = await compressImage(_pickedImage!);

    DiaryApiClient apiDiaryForm = DiaryApiClient();

    DiaryFormDTO diaryFormDTO = DiaryFormDTO(
        plantId: selectedPlantDetailController.selectedPlant.plantId!,
        content: _contentController.text,
        imgData: compressedData!,
        isPublic: isPublic,
        createdAt: Get.arguments["date"]);

    try {
      await apiDiaryForm.editForm(diaryDetail.id, diaryFormDTO);
      return Get.back();
    } catch (e) {
      Get.dialog(CustomAlertDialog(alertContent: e.toString()));
    }
  }

  Future<void> removeDiary() async {
    DiaryApiClient apiDiaryForm = DiaryApiClient();

    try {
      await apiDiaryForm.removeDiary(diaryDetail.id);

      return Get.back();
    } catch (e) {
      Get.dialog(CustomAlertDialog(alertContent: e.toString()));
    }
  }

  @override
  void initState() {
    _contentController.text = diaryDetail.content;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final SelectedPlantDetailController selectedPlantDetailController =
        Get.find<SelectedPlantDetailController>();

    return Scaffold(
        appBar: CustomAppBar(
          title: "일지 작성",
        ),
        body: Container(
          color: BgColor.mainColor,
          child: ListView(
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        selectedPlantDetailController.selectedPlant.nickName ??
                            "",
                        style: TextStyles.whiteTitleStyle,
                      ),
                      Text(
                        Get.arguments["date"] ?? "",
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
                            child: SvgPicture.asset('assets/icons/image.svg'),
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
                    editForm();
                  }),
              const SizedBox(
                height: 10.0,
              ),
              CustomTextButton(
                  content: "삭제",
                  backgroundColor: Colors.red,
                  onPressed: () {
                    removeDiary();
                  }),
            ],
          ),
        ));
  }
}
