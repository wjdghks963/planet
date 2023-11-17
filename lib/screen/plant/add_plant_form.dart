import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:planet/components/common/CustomAppBar.dart';
import 'package:planet/components/common/custom_alert_dialog.dart';
import 'package:planet/components/common/custom_text_button.dart';
import 'package:planet/components/common/form_textfield.dart';
import 'package:planet/controllers/plant_controller.dart';
import 'package:planet/models/api/plant/plant_form_model.dart';
import 'package:planet/services/api_manager.dart';
import 'package:planet/services/plant_api_service.dart';
import 'package:planet/theme.dart';
import 'package:planet/utils/image_resizer.dart';

class AddPlantForm extends StatefulWidget {
  const AddPlantForm({super.key});

  @override
  State<AddPlantForm> createState() => _AddPlantFormState();
}

class _AddPlantFormState extends State<AddPlantForm> {
  late TextEditingController nickNameController;
  late TextEditingController scientificNameController;

  final ImagePicker _picker = ImagePicker();
  XFile? _pickedImage;

  void getImage(ImageSource source) async {
    final XFile? image = await _picker.pickImage(source: source);

    setState(() {
      _pickedImage = image;
    });
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

    try {
      await PlantsApiClient().addPlant(newPlant);

      final plantController = Get.find<PlantController>();
      plantController.fetchPlants();
      Get.back();
    } catch (e) {
      await Get.dialog(CustomAlertDialog(alertContent: e.toString()));
      Get.back();
    }
  }

  @override
  void initState() {
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
        body: Container(
          color: BgColor.mainColor,
          child: ListView(
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
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
                            padding: EdgeInsets.all(100),
                            child: SvgPicture.asset('assets/icons/image.svg'),
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
        ));
  }
}
