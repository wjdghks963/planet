import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:planet/components/common/CustomAppBar.dart';
import 'package:planet/components/common/custom_alert_dialog.dart';
import 'package:planet/components/common/custom_select_dialog.dart';
import 'package:planet/components/common/custom_text_button.dart';
import 'package:planet/components/common/form_textfield.dart';
import 'package:planet/controllers/plant/plant_controller.dart';
import 'package:planet/controllers/plant/plant_detail_controller.dart';
import 'package:planet/controllers/plant/selected_plant_detail_controller.dart';
import 'package:planet/models/api/plant/plant_form_model.dart';
import 'package:planet/services/plant_api_service.dart';
import 'package:planet/theme.dart';
import 'package:planet/utils/image_resizer.dart';
import 'package:planet/utils/image_select.dart';

class EditPlantForm extends StatefulWidget {
  const EditPlantForm({super.key});

  @override
  State<EditPlantForm> createState() => _EditPlantFormState();
}

class _EditPlantFormState extends State<EditPlantForm> {
  final plantsApiClient = PlantsApiClient();

  late PlantController plantController;
  late SelectedPlantDetailController selectedController;

  TextEditingController nickNameController = TextEditingController();
  TextEditingController scientificNameController = TextEditingController();

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

  Future<void> submitPlant() async {
    String nickname = nickNameController.text;
    String scientificName = scientificNameController.text;

    if (_pickedImage == null) {
      Get.dialog(CustomAlertDialog(alertContent: "사진을 등록해 주세요."));
      return;
    }
    if (nickname == "" || scientificName == "") {
      Get.dialog(CustomAlertDialog(alertContent: "빈칸을 전부 채워 주세요."));
      return;
    }

    String? compressedData = await compressImage(_pickedImage!);

    PlantFormModel newPlant = PlantFormModel(
      nickname,
      scientificName,
      compressedData!,
    );

    await plantController.editPlant(
        newPlant, selectedController.selectedPlant.plantId!);
  }

  void removePlant() async {
    var result = await Get.dialog(const CustomSelectDialog(
        title: "삭제", content: "관련된 모든 데이터가 삭제되고 복구할 수 없습니다."));

    if (result == true) {
      await plantController
          .removePlant(selectedController.selectedPlant.plantId!);
    }
  }

  @override
  void initState() {
    PlantDetailController plantDetailController =
        Get.find<PlantDetailController>();
    selectedController = Get.find<SelectedPlantDetailController>();
    plantController = Get.find<PlantController>();

    nickNameController.text =
        plantDetailController.plantDetail.value?.nickName ?? "";
    scientificNameController.text =
        plantDetailController.plantDetail.value?.scientificName ?? "";

    super.initState();
  }

  @override
  void dispose() {
    nickNameController.dispose();
    scientificNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(
          title: "식물 편집",
        ),
        body: Obx(() {
          if (plantController.isLoading.value == true) {
            return Center(
                child: Lottie.asset('assets/lotties/loading_lottie.json'));
          } else {
            return Container(
              color: BgColor.mainColor,
              child: ListView(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 10.0),
                children: [
                  Column(
                    children: [
                      FormTextField(
                        controller: nickNameController,
                        hintText: "별명",
                        labelText: "이름 (별명)",
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      FormTextField(
                          controller: scientificNameController,
                          hintText: "정확하지 않아도 괜찮습니다.",
                          labelText: "식물 학명"),
                    ],
                  ),
                  const SizedBox(
                    height: 50,
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
                  CustomTextButton(
                      content: "작성 완료",
                      backgroundColor: ColorStyles.mainAccent,
                      onPressed: () {
                        submitPlant();
                      }),
                  const SizedBox(
                    height: 10.0,
                  ),
                  CustomTextButton(
                      content: "삭제",
                      backgroundColor: Colors.red,
                      onPressed: () {
                        removePlant();
                      }),
                  const SizedBox(
                    height: 10.0,
                  ),
                ],
              ),
            );
          }
        }));
  }
}
