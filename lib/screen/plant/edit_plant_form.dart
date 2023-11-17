import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:planet/components/common/CustomAppBar.dart';
import 'package:planet/components/common/custom_alert_dialog.dart';
import 'package:planet/components/common/custom_select_dialog.dart';
import 'package:planet/components/common/custom_text_button.dart';
import 'package:planet/components/common/form_textfield.dart';
import 'package:planet/controllers/plant_controller.dart';
import 'package:planet/controllers/selected_plant_detail_controller.dart';
import 'package:planet/models/api/plant/plant_form_model.dart';
import 'package:planet/screen/root.dart';
import 'package:planet/services/api_manager.dart';
import 'package:planet/services/plant_api_service.dart';
import 'package:planet/theme.dart';
import 'package:planet/utils/image_resizer.dart';

class EditPlantForm extends StatefulWidget {
  const EditPlantForm({super.key});

  @override
  State<EditPlantForm> createState() => _EditPlantFormState();
}

class _EditPlantFormState extends State<EditPlantForm> {
  final plantsApiClient = PlantsAipClient();

  late SelectedPlantDetailController selectedController;

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

    // API 호출
    var result = await plantsApiClient.editPlant(
        newPlant, selectedController.selectedPlant.plantId!);

    if (result == true) {
      final plantController = Get.find<PlantController>();
      plantController.fetchPlants();

      Get.offAll(const RootScreen(), arguments: {"selectedIndex": 1});
    }
  }

  void removePlant() async {
    var result = await Get.dialog(const CustomSelectDialog(
        title: "삭제", content: "관련된 모든 데이터가 삭제되고 복구할 수 없습니다."));

    if (result == true) {
      final response = await plantsApiClient
          .removePlant(selectedController.selectedPlant.plantId!);

      if (response == true) {
        final plantController = Get.find<PlantController>();
        plantController.fetchPlants();

        Get.offAll(const RootScreen(), arguments: {"selectedIndex": 1});
      }
    }
  }

  @override
  void initState() {
    selectedController = Get.find<SelectedPlantDetailController>();

    nickNameController = TextEditingController();
    scientificNameController = TextEditingController();

    nickNameController.text = selectedController.selectedPlant.nickName!;
    scientificNameController.text =
        selectedController.selectedPlant.scientificName!;
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
                            padding: const EdgeInsets.all(50),

                            // TODO:: 여기에 selectedController에 있던 url 주소
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
        ));
  }
}
