import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:planet/components/common/CustomAppBar.dart';
import 'package:planet/components/common/custom_alert_dialog.dart';
import 'package:planet/components/common/custom_text_button.dart';
import 'package:planet/components/common/form_textfield.dart';
import 'package:planet/controllers/plant/plant_controller.dart';
import 'package:planet/models/api/plant/plant_form_model.dart';
import 'package:planet/theme.dart';
import 'package:planet/utils/image_resizer.dart';
import 'package:planet/utils/image_select.dart';

class AddPlantForm extends StatefulWidget {
  const AddPlantForm({super.key});

  @override
  State<AddPlantForm> createState() => _AddPlantFormState();
}

class _AddPlantFormState extends State<AddPlantForm> {
  late PlantController plantController;
  late TextEditingController nickNameController;
  late TextEditingController scientificNameController;

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

    await plantController.addNewPlant(newPlant);
  }

  @override
  void initState() {
    plantController = Get.find<PlantController>();
    nickNameController = TextEditingController();
    scientificNameController = TextEditingController();
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
          title: "식물 추가",
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
                          labelText: "이름 (별명)"),
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
                                padding: const EdgeInsets.all(100),
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
                ],
              ),
            );
          }
        }));
  }
}
